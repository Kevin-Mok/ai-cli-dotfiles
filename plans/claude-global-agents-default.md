# ExecPlan: Make `dot_codex/AGENTS.md` Claude's Global Default

- [x] Inspect the current Claude configuration surface in this repo and on
  the machine to identify the correct global instruction hook.
- [x] Add a tracked global Claude instructions file under `dot_claude/`
  that imports `/home/kevin/linux-config/dot_codex/AGENTS.md`.
- [x] Update the root `README.md` so it truthfully describes Claude's
  global default instruction path alongside the existing Codex surface.
- [x] Update `docs/smoke-tests.md` with a reusable manual verification
  step for the Claude global instructions import.
- [x] Run `refresh-config` so the tracked Claude config is applied to the
  live `~/.claude/` install.
- [x] Verify the rendered Claude file and imported path are present after
  refresh, then review the diff for only the intended files.

## Assumptions

- Claude Code on this machine auto-loads a global `~/.claude/CLAUDE.md`.
- Claude's `CLAUDE.md` import syntax with `@/absolute/path` is supported
  in the installed version.
- The user's desired global default is to share the repo-tracked
  `/home/kevin/linux-config/dot_codex/AGENTS.md` verbatim instead of
  maintaining a Claude-specific copy.

## Notes

- This task changes the repo's AI operating surface, so `README.md`
  and smoke-test guidance must stay aligned in the same change.
- The repo already had unrelated dirty files before this task:
  `aliases/key_aliases.tmpl`, `dot_codex/config.toml`, and
  `dot_config/fish/config.fish.tmpl`.
