# ExecPlan: Rebrand `push-dirty` Skill To `Push Plan`

## Checklist

- [x] Confirm the current `push-dirty` skill scope and locate explicit repo references to the old name.
- [x] Rename the skill path from `dot_agents/skills/push-dirty/` to `dot_agents/skills/push-plan/`.
- [x] Update the skill metadata, heading, and trigger text to use `push-plan` / `Push Plan`.
- [x] Refresh repo docs and historical ExecPlans that still mention the old skill name or path.
- [x] Verify searches and targeted diff output show the intended rebrand changes, and note unrelated worktree edits if present.

## Assumptions

- The user wants the canonical skill slug/path changed to `push-plan`.
- The human-facing skill title should become `Push Plan`.
- The workflow remains read-only commit planning; no behavioral expansion is required.

## Review Notes

- Renamed the live commit-planning skill from `push-dirty` to `push-plan` by moving `SKILL.md` under `dot_agents/skills/push-plan/` and updating the front matter, title, and trigger text to say `Push Plan`.
- Clarified the planning-only guardrails in the renamed skill so it now explicitly forbids `git push` alongside other write actions.
- Updated `dot_agents/skills/commit-push/SKILL.md` to point users at `push-plan` when they only want a read-only commit plan.
- Refreshed historical ExecPlans that still referenced the old `push-dirty` slug or path so repo-local documentation now matches the current canonical skill name.
- Left the unrelated `dot_codex/config.toml` edit untouched after `git diff` showed it only adds `service_tier = "fast"`.
- Verification completed with:
  - `rg -n "push-dirty|push dirty|dot_agents/skills/push-dirty" .`
  - `rg -n "push-plan|Push Plan" dot_agents plans`
  - `find dot_agents/skills -maxdepth 2 -name SKILL.md | sort`
  - `git status --short`
  - `git diff --stat`
