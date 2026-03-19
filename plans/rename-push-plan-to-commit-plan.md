# ExecPlan: Rename `push-plan` Skill To `commit-plan`

## Checklist

- [x] Inspect the existing `push-plan` skill and identify the live repo references tied to its canonical slug.
- [x] Rename the tracked skill path and metadata from `push-plan` to `commit-plan`.
- [x] Update repo docs and dependent skill text that point to the canonical planning skill.
- [x] Verify the live skill surface now uses `commit-plan` and note any intentionally historical `push-plan` references that remain.

## Assumptions

- The user wants `commit-plan` to replace `push-plan` as the canonical skill slug and directory name.
- The skill remains read-only commit planning; no behavior change beyond the rename is required.
- Historical ExecPlans may keep `push-plan` only when they describe prior rename work rather than the current live skill surface.

## Review Notes

- Renamed the tracked skill directory from `dot_agents/skills/push-plan/` to `dot_agents/skills/commit-plan/`.
- Updated the skill metadata, trigger text, and explicit agent prompt so the canonical invocation is now `commit-plan`.
- Refreshed the repo skill catalogs in `README.md` and `dot_agents/skills/README.md` to link to `commit-plan`.
- Updated the `commit-push` guardrail text and related ExecPlans that referred to the current planning skill by its old canonical name.
- Renamed `plans/push-plan-commit-message-summary.md` to `plans/commit-plan-commit-message-summary.md` so the plan filename and contents match the current skill slug.
- Verification completed with:
  - `rg -n --hidden --glob '!**/.git/**' "dot_agents/skills/push-plan|\\bpush-plan\\b|push plan" README.md dot_agents plans`
  - `find dot_agents/skills -maxdepth 2 -name SKILL.md | sort`
  - `git diff -- README.md dot_agents/skills/README.md dot_agents/skills/commit-push/SKILL.md dot_agents/skills/commit-plan/SKILL.md dot_agents/skills/commit-plan/agents/openai.yaml plans/commit-plan-commit-message-summary.md plans/immediate-commit-push-skill.md plans/install-curated-codex-skills.md plans/rename-push-plan-to-commit-plan.md`
- Intentional historical `push-plan` references remain in:
  - `plans/rebrand-push-dirty-to-push-plan.md`
  - `plans/rename-pd-skill-to-push-plan.md`
