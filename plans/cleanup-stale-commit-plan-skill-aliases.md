# ExecPlan: Clean Up Stale Installed Commit-Planning Skill Aliases

## Checklist

- [x] Inspect the tracked `dot_agents/skills/` tree and confirm `commit-plan` is the only canonical commit-planning skill in the repo.
- [x] Inspect the installed `~/.agents/skills/` tree and confirm the stale alias copies that still exist there.
- [x] Remove the stale installed `pd` and `push-plan` aliases while keeping `commit-plan` intact.
- [x] Verify the installed skill surface now exposes only the canonical `commit-plan` variant for commit planning.

## Assumptions

- `dot_agents/skills/commit-plan/` is the only source-of-truth commit-planning skill in this repo.
- The extra `~/.agents/skills/pd/` and `~/.agents/skills/push-plan/` directories are stale installed copies rather than intentionally maintained aliases.
- Cleaning the installed copies is sufficient; no tracked repo docs need changes because they already point at `commit-plan`.

## Review Notes

- Confirmed the tracked repo skill surface only contains `dot_agents/skills/commit-plan/SKILL.md`.
- Confirmed the installed skill surface still contains stale `~/.agents/skills/pd/SKILL.md` and `~/.agents/skills/push-plan/SKILL.md` copies in addition to `~/.agents/skills/commit-plan/SKILL.md`.
- Verified the rename history in `plans/rename-pd-skill-to-push-plan.md` and `plans/rename-push-plan-to-commit-plan.md`, which explains why those installed aliases still exist.
- Removed the stale installed directories `~/.agents/skills/pd/` and `~/.agents/skills/push-plan/` and left `~/.agents/skills/commit-plan/` intact.
- Verification completed with:
  - `find /home/kevin/.agents/skills -maxdepth 2 -type f | sort | rg 'commit-plan|push-plan|/pd/'`
  - `test -e /home/kevin/.agents/skills/pd && echo exists || echo missing; test -e /home/kevin/.agents/skills/push-plan && echo exists || echo missing; test -e /home/kevin/.agents/skills/commit-plan && echo exists || echo missing`
