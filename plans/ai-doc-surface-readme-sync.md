# ExecPlan: Keep README In Sync With AI Operating Surface Updates

## Checklist

- [x] Add a repo-local rule in `AGENTS.repo.md` requiring `README.md`
  updates when core AI operating files or directories change.
- [x] Name the tracked AI operating surfaces explicitly:
  `AGENTS.md`, `AGENTS.repo.md`, `dot_codex/`, `dot_agents/`,
  and `plans/`.
- [x] Update `README.md` so those files and directories are presented
  as current highlights of the repo's AI operating environment.
- [x] Verify the documentation changes with targeted reads, grep
  checks, and a diff.

## Assumptions

- The requested "AI files" are the repo surfaces the user named:
  `AGENTS.md`, `AGENTS.repo.md`, `dot_codex/`, `dot_agents/`,
  and `plans/`.
- The README should keep its existing four-Codex framing while
  becoming more explicit about those tracked AI surfaces and why
  they matter.
- This task is documentation-only; no behavior or runtime config
  changes are required.

## Review Notes

- Added a new `README Sync For AI Surface Changes` section to
  `AGENTS.repo.md` so repo-local guidance now requires README refreshes
  when `AGENTS.md`, `AGENTS.repo.md`, `dot_codex/`, `dot_agents/`,
  or `plans/` change in meaningful ways.
- Added an `AI Layer Highlights` section to `README.md` and linked it
  from the table of contents so the tracked AI operating surfaces are
  presented as active highlights instead of only background structure.
- Left unrelated dirty files in the worktree untouched.
- Verification completed with:
  - `sed -n '1,220p' AGENTS.repo.md`
  - `sed -n '1,220p' README.md`
  - `rg -n 'AI Layer Highlights|README Sync For AI Surface Changes|AGENTS.repo.md|dot_codex/|dot_agents/|plans/' AGENTS.repo.md README.md plans/ai-doc-surface-readme-sync.md`
  - `git diff -- AGENTS.repo.md README.md plans/ai-doc-surface-readme-sync.md`
  - `git status --short AGENTS.repo.md README.md plans/ai-doc-surface-readme-sync.md`
