# Revert Default Terminal To Kitty

- [x] Confirm the current primary-terminal settings, docs, and tests that changed the repo to `st`.
- [x] Update or add a regression test so the expected primary terminal is `kitty`, then run it and confirm it fails for the current repo state.
- [x] Restore `kitty` as the default i3 terminal while preserving the existing alternate `st` tooling and launcher support.
- [x] Update `README.md` and `docs/smoke-tests.md` so they describe `kitty` as the default terminal and `st` as an optional alternate workflow where relevant.
- [x] Run the targeted regression tests, inspect the final diff, and note whether `refresh-config` was run or deferred.

## Review

- Red phase: `bash tests/test_st_terminal_workflow.sh` failed because `dot_config/i3/config.tmpl` still set `/home/kevin/scripts/st-terminal` as `$term`.
- Green phase: updated i3, README, and smoke tests so `kitty` is the default terminal again while `st-terminal` remains the alternate launcher.
- Verification: `bash tests/test_st_terminal_workflow.sh` and `bash tests/test_st_terminal_wrapper.sh` both passed after the config and docs changes.
- `refresh-config` was intentionally deferred because this worktree already contains unrelated tracked config changes, and applying the live config would also push those unfinished changes into `$HOME`.
