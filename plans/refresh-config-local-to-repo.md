# ExecPlan: Refresh Config Local To Repo

## Checklist

- [x] Add a regression test for `refresh-config` that expects local `~/.codex/config.toml` to overwrite repo `dot_codex/config.toml` before `chezmoi apply`.
- [x] Update the tracked `refresh-config` fish helpers to copy the local Codex config into the repo and then run `chezmoi apply`.
- [x] Align repo docs and reusable guidance with the new `refresh-config` direction.
- [x] Run targeted verification and review the final diff for scope.

## Assumptions

- The user wants `rf` and `refresh-config` to mean the same existing helper, not a new command.
- The sync direction change is intentional repo behavior, not a one-off manual recovery.
- Overwriting the repo-tracked `dot_codex/config.toml` from `~/.codex/config.toml` should happen before the general `chezmoi apply` step in the helper.

## Review Notes

- Added `tests/test_refresh_config_function.sh` to exercise the real fish helper with stubbed `chezmoi`, `cp`, and `sync-shortcuts`.
- Updated both tracked `refresh-config` fish helpers to resolve the target path via `chezmoi source-path ~/.codex/config.toml`, removing any dependency on the current working directory.
- Aligned `AGENTS.repo.md`, `README.md`, `docs/smoke-tests.md`, `tasks/lessons.md`, and the feedback log with the new local-to-repo sync direction.
- Ran the targeted regression test successfully and then ran `fish -ic 'refresh-config'`; the local-to-repo copy step succeeded, while the broader apply path hit sandbox permission errors for live home-directory state.
