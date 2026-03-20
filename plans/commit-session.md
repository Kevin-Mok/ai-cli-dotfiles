# ExecPlan: Add `commit-session` Skill

## Checklist

- [x] Inspect the existing git workflow skills and confirm `commit-session` should remain separate from `commit-push`.
- [x] Scaffold `dot_agents/skills/commit-session/` with agent metadata.
- [x] Replace the scaffolded content with a session-scoped commit-and-push workflow that excludes unrelated dirty files.
- [x] Update the related skill docs, repo docs, and durable lessons.
- [x] Validate the new skill and review the resulting diff.

## Assumptions

- The user wants an explicit `commit-session` skill rather than a behavior change to `commit-push`.
- Session-scoped shipping should fail closed: ambiguous files stay uncommitted instead of being guessed into the commit.
- Future sessions should capture a pre-write `git status --short` baseline so the skill can distinguish pre-existing dirty files from session work.

## Review Notes

- Added a new `commit-session` skill with explicit-only agent metadata and a fail-closed workflow that scopes commits to the current `CODEX_THREAD_ID`.
- Implemented `dot_agents/skills/commit-session/scripts/session_scope.py` to parse Codex session logs, require a pre-write `git status --short` baseline, and classify dirty files into `commitable`, `skipped_preexisting`, and `skipped_unknown`.
- Tightened the helper so current dirty state uses `git status --short --untracked-files=all`, which prevents new untracked directories from being collapsed into ambiguous directory entries.
- Added baseline prefix matching for collapsed untracked directories, so files that were already dirty under an untracked directory remain excluded even when current git status expands them to individual files.
- Updated `commit-push`, the local skills catalog, the root README, `dot_codex/config.toml`, and `tasks/lessons.md` so the new session-scoped shipping behavior is documented and future sessions capture the needed baseline.
- Validation completed with `python3 /home/kevin/.codex/skills/.system/skill-creator/scripts/quick_validate.py /home/kevin/linux-config/dot_agents/skills/commit-session`.
- Validation completed with `PYTHONDONTWRITEBYTECODE=1 python3 dot_agents/skills/commit-session/scripts/session_scope.py --repo-root /home/kevin/linux-config`.
- Validation completed with synthetic positive and negative repo scenarios under `/tmp` to prove both pre-dirty exclusion and missing-baseline fail-closed behavior.
