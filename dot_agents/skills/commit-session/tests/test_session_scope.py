import importlib.util
import json
import subprocess
import sys
import tempfile
import unittest
from pathlib import Path


SCRIPT_PATH = Path(__file__).resolve().parents[1] / "scripts" / "session_scope.py"


def load_session_scope_module():
    spec = importlib.util.spec_from_file_location("test_session_scope_module", SCRIPT_PATH)
    module = importlib.util.module_from_spec(spec)
    sys.modules[spec.name] = module
    spec.loader.exec_module(module)
    return module


class SessionScopeTestCase(unittest.TestCase):
    def setUp(self):
        self.module = load_session_scope_module()
        self.tmpdir = tempfile.TemporaryDirectory()
        self.addCleanup(self.tmpdir.cleanup)
        self.repo = Path(self.tmpdir.name) / "repo"
        self.repo.mkdir()
        self.run_git("init")
        self.run_git("config", "user.email", "test@example.com")
        self.run_git("config", "user.name", "Test User")

    def run_git(self, *args):
        return subprocess.run(
            ["git", *args],
            cwd=self.repo,
            check=True,
            capture_output=True,
            text=True,
        )

    def write_repo_file(self, relative_path: str, content: str) -> None:
        path = self.repo / relative_path
        path.parent.mkdir(parents=True, exist_ok=True)
        path.write_text(content, encoding="utf-8")

    def commit_repo_file(self, relative_path: str, content: str = "base\n") -> None:
        self.write_repo_file(relative_path, content)
        self.run_git("add", relative_path)
        self.run_git("commit", "-m", f"add {relative_path}")

    def session_log_path(self) -> Path:
        return Path(self.tmpdir.name) / "session.jsonl"

    def write_session_log(self, entries: list[dict]) -> Path:
        log_path = self.session_log_path()
        with log_path.open("w", encoding="utf-8") as handle:
            for entry in entries:
                handle.write(json.dumps(entry) + "\n")
        return log_path

    def baseline_output(self, lines: list[str]) -> str:
        output = "\n".join(lines)
        return (
            "Chunk ID: baseline\n"
            "Wall time: 0.0000 seconds\n"
            "Process exited with code 0\n"
            "Original token count: 0\n"
            f"Output:\n{output}"
        )

    def exec_output(self, chunk_id: str = "write") -> str:
        return (
            f"Chunk ID: {chunk_id}\n"
            "Wall time: 0.0000 seconds\n"
            "Process exited with code 0\n"
            "Original token count: 0\n"
            "Output:\n"
        )

    def session_meta(self) -> dict:
        return {
            "timestamp": "2026-03-20T10:00:00Z",
            "type": "session_meta",
            "payload": {"id": "test-session", "cwd": str(self.repo)},
        }

    def baseline_call_items(self, lines: list[str]) -> list[dict]:
        return [
            {
                "timestamp": "2026-03-20T10:00:01Z",
                "type": "response_item",
                "payload": {
                    "type": "function_call",
                    "name": "exec_command",
                    "call_id": "call_baseline",
                    "arguments": json.dumps(
                        {"cmd": "git status --short", "workdir": str(self.repo)}
                    ),
                },
            },
            {
                "timestamp": "2026-03-20T10:00:02Z",
                "type": "response_item",
                "payload": {
                    "type": "function_call_output",
                    "call_id": "call_baseline",
                    "output": self.baseline_output(lines),
                },
            },
        ]

    def exec_call_items(self, call_id: str, timestamp: str, cmd: str) -> list[dict]:
        return [
            {
                "timestamp": timestamp,
                "type": "response_item",
                "payload": {
                    "type": "function_call",
                    "name": "exec_command",
                    "call_id": call_id,
                    "arguments": json.dumps({"cmd": cmd, "workdir": str(self.repo)}),
                },
            },
            {
                "timestamp": timestamp.replace("Z", ".100Z"),
                "type": "response_item",
                "payload": {
                    "type": "function_call_output",
                    "call_id": call_id,
                    "output": self.exec_output(call_id),
                },
            },
        ]

    def apply_patch_item(self, timestamp: str, patch_text: str) -> dict:
        return {
            "timestamp": timestamp,
            "type": "response_item",
            "payload": {
                "type": "custom_tool_call",
                "name": "apply_patch",
                "status": "completed",
                "input": patch_text,
            },
        }

    def analyze_with_log(self, log_entries: list[dict]):
        log_path = self.write_session_log(log_entries)
        self.module.locate_session_file = lambda session_id: log_path
        return self.module.analyze_session(self.repo, "test-session")

    def test_apply_patch_marks_direct_edit_as_observed_touch(self):
        self.commit_repo_file("tracked.txt")
        self.write_repo_file("tracked.txt", "base\nchanged\n")

        result = self.analyze_with_log(
            [
                self.session_meta(),
                *self.baseline_call_items([]),
                self.apply_patch_item(
                    "2026-03-20T10:00:03Z",
                    "*** Begin Patch\n*** Update File: tracked.txt\n@@\n-base\n+base\n+changed\n*** End Patch\n",
                ),
            ]
        )

        self.assertEqual("ready", result.status)
        self.assertEqual(["tracked.txt"], [entry.canonical_path for entry in result.commitable])
        self.assertEqual(["observed_touch"], [entry.ownership_reason for entry in result.commitable])
        self.assertEqual([], result.skipped_unknown)

    def test_newly_dirty_file_is_commitable_after_generic_repo_write(self):
        self.commit_repo_file("tracked.txt")
        self.write_repo_file("tracked.txt", "base\nchanged\n")

        result = self.analyze_with_log(
            [
                self.session_meta(),
                *self.baseline_call_items([]),
                *self.exec_call_items("call_write", "2026-03-20T10:00:03Z", "python3 tool.py"),
            ]
        )

        self.assertEqual("ready", result.status)
        self.assertEqual(["tracked.txt"], [entry.canonical_path for entry in result.commitable])
        self.assertEqual(
            ["newly_dirty_since_baseline"],
            [entry.ownership_reason for entry in result.commitable],
        )
        self.assertEqual([], result.skipped_unknown)

    def test_generated_companion_file_uses_newly_dirty_reason(self):
        self.commit_repo_file("source.txt")
        self.write_repo_file("source.txt", "base\nchanged\n")
        self.write_repo_file("generated.txt", "artifact\n")

        result = self.analyze_with_log(
            [
                self.session_meta(),
                *self.baseline_call_items([]),
                self.apply_patch_item(
                    "2026-03-20T10:00:03Z",
                    "*** Begin Patch\n*** Update File: source.txt\n@@\n-base\n+base\n+changed\n*** End Patch\n",
                ),
            ]
        )

        reasons = {entry.canonical_path: entry.ownership_reason for entry in result.commitable}
        self.assertEqual("observed_touch", reasons["source.txt"])
        self.assertEqual("newly_dirty_since_baseline", reasons["generated.txt"])

    def test_direct_touch_reclaims_preexisting_dirty_file(self):
        self.commit_repo_file("tracked.txt")
        self.write_repo_file("tracked.txt", "base\nchanged\n")

        result = self.analyze_with_log(
            [
                self.session_meta(),
                *self.baseline_call_items([" M tracked.txt"]),
                self.apply_patch_item(
                    "2026-03-20T10:00:03Z",
                    "*** Begin Patch\n*** Update File: tracked.txt\n@@\n-base\n+base\n+changed\n*** End Patch\n",
                ),
            ]
        )

        self.assertEqual("ready", result.status)
        self.assertEqual(["tracked.txt"], [entry.canonical_path for entry in result.commitable])
        self.assertEqual(
            ["observed_touch"],
            [entry.ownership_reason for entry in result.commitable],
        )
        self.assertEqual([], result.skipped_preexisting)

    def test_untouched_preexisting_dirty_file_stays_skipped(self):
        self.commit_repo_file("tracked.txt")
        self.write_repo_file("tracked.txt", "base\nchanged\n")

        result = self.analyze_with_log(
            [
                self.session_meta(),
                *self.baseline_call_items([" M tracked.txt"]),
                *self.exec_call_items("call_write", "2026-03-20T10:00:03Z", "python3 tool.py"),
            ]
        )

        self.assertEqual([], result.commitable)
        self.assertEqual(["tracked.txt"], [entry.canonical_path for entry in result.skipped_preexisting])
        self.assertEqual(
            ["preexisting_at_baseline"],
            [entry.ownership_reason for entry in result.skipped_preexisting],
        )

    def test_preexisting_untracked_directory_prefix_stays_skipped(self):
        (self.repo / "cache").mkdir()
        self.write_repo_file("cache/data.txt", "artifact\n")

        result = self.analyze_with_log(
            [
                self.session_meta(),
                *self.baseline_call_items(["?? cache/"]),
                *self.exec_call_items("call_write", "2026-03-20T10:00:03Z", "python3 tool.py"),
            ]
        )

        self.assertEqual([], result.commitable)
        self.assertEqual(
            ["cache/data.txt"],
            [entry.canonical_path for entry in result.skipped_preexisting],
        )

    def test_missing_baseline_remains_unsafe(self):
        self.commit_repo_file("tracked.txt")
        self.write_repo_file("tracked.txt", "base\nchanged\n")

        result = self.analyze_with_log(
            [
                self.session_meta(),
                *self.exec_call_items("call_write", "2026-03-20T10:00:03Z", "python3 tool.py"),
            ]
        )

        self.assertEqual("unsafe", result.status)
        self.assertIn("No successful `git status --short` baseline", result.unsafe_reason)

    def test_missing_baseline_allows_direct_touches_and_skips_other_dirties(self):
        self.commit_repo_file("tracked.txt")
        self.write_repo_file("tracked.txt", "base\nchanged\n")
        self.write_repo_file("unrelated.txt", "left-alone\n")

        result = self.analyze_with_log(
            [
                self.session_meta(),
                self.apply_patch_item(
                    "2026-03-20T10:00:03Z",
                    "*** Begin Patch\n*** Update File: tracked.txt\n@@\n-base\n+base\n+changed\n*** End Patch\n",
                ),
            ]
        )

        self.assertEqual("ready", result.status)
        self.assertEqual(["tracked.txt"], [entry.canonical_path for entry in result.commitable])
        self.assertEqual(
            ["observed_touch"],
            [entry.ownership_reason for entry in result.commitable],
        )
        self.assertEqual(["unrelated.txt"], [entry.canonical_path for entry in result.skipped_unknown])
        self.assertEqual(
            ["missing_baseline_unattributed"],
            [entry.ownership_reason for entry in result.skipped_unknown],
        )
        self.assertIsNone(result.unsafe_reason)


if __name__ == "__main__":
    unittest.main()
