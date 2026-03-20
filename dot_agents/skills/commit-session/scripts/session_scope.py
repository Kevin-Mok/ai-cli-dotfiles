#!/usr/bin/env python3
"""Compute a high-confidence file scope for the current Codex session."""

from __future__ import annotations

import argparse
import json
import os
import re
import subprocess
from dataclasses import asdict, dataclass
from pathlib import Path
from typing import Any


GIT_STATUS_CMD_RE = re.compile(r"^\s*git\s+status\s+--short(?:\s|$)")
EXIT_CODE_RE = re.compile(r"Process exited with code (\d+)")
PATCH_FILE_RE = re.compile(r"^\*\*\* (?:Update|Add|Delete) File: (.+)$", re.MULTILINE)
PATCH_MOVE_RE = re.compile(r"^\*\*\* Move to: (.+)$", re.MULTILINE)
INIT_SKILL_DIR_RE = re.compile(r"^\[OK\] Created skill directory: (.+)$", re.MULTILINE)


@dataclass
class StatusEntry:
    raw_status: str
    canonical_path: str
    stage_paths: list[str]
    is_untracked_dir: bool = False


@dataclass
class FunctionCall:
    call_id: str
    name: str
    timestamp: str
    arguments: dict[str, Any]


@dataclass
class ScopeResult:
    status: str
    session_id: str | None
    session_file: str | None
    repo_root: str
    session_cwd: str | None
    first_write_at: str | None
    baseline_at: str | None
    touched_files: list[str]
    current_dirty: list[StatusEntry]
    commitable: list[StatusEntry]
    skipped_preexisting: list[StatusEntry]
    skipped_unknown: list[StatusEntry]
    unsafe_reason: str | None


def normalize_path(raw_path: str, base_dir: Path, repo_root: Path) -> str | None:
    candidate = Path(raw_path.strip().strip('"').strip("'"))
    if not candidate.is_absolute():
        candidate = base_dir / candidate

    resolved = candidate.resolve(strict=False)
    try:
        return resolved.relative_to(repo_root).as_posix()
    except ValueError:
        return None


def workdir_in_repo(workdir: str | None, repo_root: Path, session_cwd: Path) -> bool:
    base = Path(workdir).expanduser() if workdir else session_cwd
    resolved = base.resolve(strict=False)
    try:
        resolved.relative_to(repo_root)
        return True
    except ValueError:
        return False


def extract_output_text(raw_output: str) -> str:
    marker = "Output:\n"
    if marker in raw_output:
        return raw_output.split(marker, 1)[1]
    return raw_output


def command_succeeded(raw_output: str) -> bool:
    match = EXIT_CODE_RE.search(raw_output)
    return bool(match and match.group(1) == "0")


def parse_status_output(raw_status: str, base_dir: Path, repo_root: Path) -> list[StatusEntry]:
    entries: list[StatusEntry] = []

    for line in raw_status.splitlines():
        if not line.strip():
            continue
        if len(line) < 4:
            continue

        raw_code = line[:2]
        raw_path = line[3:]
        stage_paths: list[str] = []
        canonical_path: str | None
        is_untracked_dir = raw_code == "??" and raw_path.rstrip().endswith("/")

        if " -> " in raw_path:
            old_path, new_path = raw_path.split(" -> ", 1)
            old_rel = normalize_path(old_path, base_dir, repo_root)
            new_rel = normalize_path(new_path, base_dir, repo_root)
            if new_rel is None:
                continue
            canonical_path = new_rel
            if old_rel is not None:
                stage_paths.append(old_rel)
            stage_paths.append(new_rel)
        else:
            canonical_path = normalize_path(raw_path, base_dir, repo_root)
            if canonical_path is None:
                continue
            stage_paths.append(canonical_path)

        entries.append(
            StatusEntry(
                raw_status=raw_code,
                canonical_path=canonical_path,
                stage_paths=sorted(set(stage_paths)),
                is_untracked_dir=is_untracked_dir,
            )
        )

    return entries


def parse_patch_paths(patch_text: str, base_dir: Path, repo_root: Path) -> set[str]:
    touched: set[str] = set()

    for match in PATCH_FILE_RE.finditer(patch_text):
        relative = normalize_path(match.group(1), base_dir, repo_root)
        if relative is not None:
            touched.add(relative)

    for match in PATCH_MOVE_RE.finditer(patch_text):
        relative = normalize_path(match.group(1), base_dir, repo_root)
        if relative is not None:
            touched.add(relative)

    return touched


def extract_written_paths_from_exec(cmd: str, raw_output: str, repo_root: Path) -> set[str]:
    touched: set[str] = set()

    if "init_skill.py" not in cmd:
        return touched

    match = INIT_SKILL_DIR_RE.search(extract_output_text(raw_output))
    if not match:
        return touched

    skill_dir = Path(match.group(1).strip()).resolve(strict=False)
    try:
        skill_dir.relative_to(repo_root)
    except ValueError:
        return touched

    for suffix in ("SKILL.md", "agents/openai.yaml"):
        relative = (skill_dir / suffix).resolve(strict=False).relative_to(repo_root).as_posix()
        touched.add(relative)

    return touched


def looks_like_repo_write_command(cmd: str) -> bool:
    stripped = cmd.strip()
    if not stripped or GIT_STATUS_CMD_RE.search(stripped):
        return False

    patterns = (
        r"(^|\s)(mkdir|cp|mv|touch|install|ln)\b",
        r"\b(sed|perl)\b.*\s-i\b",
        r"\btee\b",
        r"(^|\s)cat\s+.+>",
        r">>",
        r"(?<!-)>(?!\|)",
        r"\binit_skill\.py\b",
        r"\bgenerate_openai_yaml\.py\b",
        r"\bchezmoi\s+apply\b",
        r"\bgit\s+apply\b",
    )
    return any(re.search(pattern, stripped) for pattern in patterns)


def locate_session_file(session_id: str) -> Path | None:
    sessions_root = Path.home() / ".codex" / "sessions"
    matches = sorted(sessions_root.rglob(f"*{session_id}.jsonl"))
    return matches[-1] if matches else None


def git_repo_root(path: Path) -> Path:
    completed = subprocess.run(
        ["git", "rev-parse", "--show-toplevel"],
        cwd=path,
        check=True,
        capture_output=True,
        text=True,
    )
    return Path(completed.stdout.strip()).resolve(strict=False)


def git_current_dirty(repo_root: Path) -> list[StatusEntry]:
    completed = subprocess.run(
        ["git", "status", "--short", "--untracked-files=all"],
        cwd=repo_root,
        check=True,
        capture_output=True,
        text=True,
    )
    return parse_status_output(completed.stdout, repo_root, repo_root)


def path_is_preexisting(path: str, baseline_entries: list[StatusEntry]) -> bool:
    for entry in baseline_entries:
        if path == entry.canonical_path:
            return True
        if entry.is_untracked_dir and path.startswith(f"{entry.canonical_path}/"):
            return True
    return False


def analyze_session(repo_root: Path, session_id: str | None) -> ScopeResult:
    if not session_id:
        return ScopeResult(
            status="unsafe",
            session_id=None,
            session_file=None,
            repo_root=repo_root.as_posix(),
            session_cwd=None,
            first_write_at=None,
            baseline_at=None,
            touched_files=[],
            current_dirty=git_current_dirty(repo_root),
            commitable=[],
            skipped_preexisting=[],
            skipped_unknown=[],
            unsafe_reason="CODEX_THREAD_ID is not set, so the current Codex session cannot be identified.",
        )

    session_file = locate_session_file(session_id)
    current_dirty = git_current_dirty(repo_root)
    if session_file is None:
        return ScopeResult(
            status="unsafe",
            session_id=session_id,
            session_file=None,
            repo_root=repo_root.as_posix(),
            session_cwd=None,
            first_write_at=None,
            baseline_at=None,
            touched_files=[],
            current_dirty=current_dirty,
            commitable=[],
            skipped_preexisting=[],
            skipped_unknown=[],
            unsafe_reason="The matching Codex session log could not be found under ~/.codex/sessions.",
        )

    session_cwd = repo_root
    function_calls: dict[str, FunctionCall] = {}
    statuses: list[tuple[str, str, list[StatusEntry]]] = []
    write_events: list[str] = []
    touched_files: set[str] = set()

    with session_file.open(encoding="utf-8") as handle:
        for raw_line in handle:
            raw_line = raw_line.strip()
            if not raw_line:
                continue

            try:
                item = json.loads(raw_line)
            except json.JSONDecodeError:
                continue

            timestamp = item.get("timestamp", "")
            payload = item.get("payload", {})

            if item.get("type") == "session_meta":
                meta_cwd = payload.get("cwd")
                if meta_cwd:
                    session_cwd = Path(meta_cwd).resolve(strict=False)
                continue

            if item.get("type") != "response_item":
                continue

            payload_type = payload.get("type")
            if payload_type == "function_call":
                arguments: dict[str, Any]
                try:
                    arguments = json.loads(payload.get("arguments", "{}"))
                except json.JSONDecodeError:
                    arguments = {}
                function_calls[payload.get("call_id", "")] = FunctionCall(
                    call_id=payload.get("call_id", ""),
                    name=payload.get("name", ""),
                    timestamp=timestamp,
                    arguments=arguments,
                )
                continue

            if payload_type == "function_call_output":
                call = function_calls.get(payload.get("call_id", ""))
                if call is None or call.name != "exec_command":
                    continue

                cmd = str(call.arguments.get("cmd", ""))
                workdir = call.arguments.get("workdir")
                raw_output = str(payload.get("output", ""))

                if not workdir_in_repo(workdir, repo_root, session_cwd):
                    continue
                if not command_succeeded(raw_output):
                    continue

                base_dir = Path(workdir).resolve(strict=False) if workdir else session_cwd
                if GIT_STATUS_CMD_RE.search(cmd):
                    statuses.append(
                        (
                            timestamp,
                            str(base_dir),
                            parse_status_output(extract_output_text(raw_output), base_dir, repo_root),
                        )
                    )

                inferred_files = extract_written_paths_from_exec(cmd, raw_output, repo_root)
                if inferred_files:
                    touched_files.update(inferred_files)
                    write_events.append(timestamp)
                elif looks_like_repo_write_command(cmd):
                    write_events.append(timestamp)
                continue

            if payload_type == "custom_tool_call" and payload.get("name") == "apply_patch":
                if payload.get("status") != "completed":
                    continue
                touched = parse_patch_paths(str(payload.get("input", "")), session_cwd, repo_root)
                if touched:
                    touched_files.update(touched)
                    write_events.append(timestamp)

    if not write_events:
        return ScopeResult(
            status="unsafe",
            session_id=session_id,
            session_file=session_file.as_posix(),
            repo_root=repo_root.as_posix(),
            session_cwd=session_cwd.as_posix(),
            first_write_at=None,
            baseline_at=None,
            touched_files=sorted(touched_files),
            current_dirty=current_dirty,
            commitable=[],
            skipped_preexisting=[],
            skipped_unknown=[],
            unsafe_reason="No successful repo-writing actions were detected in the current Codex session.",
        )

    first_write_at = min(write_events)
    pre_write_statuses = [entry for entry in statuses if entry[0] < first_write_at]
    if not pre_write_statuses:
        return ScopeResult(
            status="unsafe",
            session_id=session_id,
            session_file=session_file.as_posix(),
            repo_root=repo_root.as_posix(),
            session_cwd=session_cwd.as_posix(),
            first_write_at=first_write_at,
            baseline_at=None,
            touched_files=sorted(touched_files),
            current_dirty=current_dirty,
            commitable=[],
            skipped_preexisting=[],
            skipped_unknown=[],
            unsafe_reason="No successful `git status --short` baseline was captured before the first repo write in this session.",
        )

    baseline_at, _, baseline_entries = pre_write_statuses[-1]

    commitable: list[StatusEntry] = []
    skipped_preexisting: list[StatusEntry] = []
    skipped_unknown: list[StatusEntry] = []

    for entry in current_dirty:
        if path_is_preexisting(entry.canonical_path, baseline_entries):
            skipped_preexisting.append(entry)
        elif entry.canonical_path in touched_files:
            commitable.append(entry)
        else:
            skipped_unknown.append(entry)

    status = "ready" if commitable else "empty"
    return ScopeResult(
        status=status,
        session_id=session_id,
        session_file=session_file.as_posix(),
        repo_root=repo_root.as_posix(),
        session_cwd=session_cwd.as_posix(),
        first_write_at=first_write_at,
        baseline_at=baseline_at,
        touched_files=sorted(touched_files),
        current_dirty=current_dirty,
        commitable=commitable,
        skipped_preexisting=skipped_preexisting,
        skipped_unknown=skipped_unknown,
        unsafe_reason=None,
    )


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument(
        "--repo-root",
        type=Path,
        default=Path.cwd(),
        help="Path inside the target git repository. Defaults to the current working directory.",
    )
    parser.add_argument(
        "--session-id",
        default=None,
        help="Codex session id. Defaults to CODEX_THREAD_ID.",
    )
    args = parser.parse_args()

    try:
        repo_root = git_repo_root(args.repo_root)
    except subprocess.CalledProcessError as exc:
        print(
            json.dumps(
                {
                    "status": "unsafe",
                    "unsafe_reason": "The provided path is not inside a git repository.",
                    "stderr": exc.stderr,
                },
                indent=2,
            )
        )
        return 1

    result = analyze_session(repo_root, args.session_id or os.environ.get("CODEX_THREAD_ID"))
    print(json.dumps(asdict(result), indent=2))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
