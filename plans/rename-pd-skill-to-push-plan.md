# ExecPlan: Rename `pd` Skill To `push-plan`

## Checklist

- [x] Inspect the existing `pd` skill and confirm the tracked source lives under `dot_agents/skills/`.
- [x] Rename the skill path and update the `SKILL.md` metadata/body to use `push-plan` as the canonical name.
- [x] Refresh internal repo docs that still spell out the old `pd` skill name.
- [x] Record the README naming preference in `tasks/lessons.md`.
- [x] Verify the final diff only contains the intended rename and doc updates.

## Assumptions

- `dot_agents/skills/pd/` is the canonical source directory for the local commit-planning skill.
- The requested rename should replace `pd` as the primary skill name rather than keep it as a documented alias.
- `README.md` can stay unchanged because it already describes the skill by functionality, which remains accurate after the rename.

## Review Notes

- Renamed the tracked commit-planning skill from `pd` to `push-plan` by moving `SKILL.md` to `dot_agents/skills/push-plan/` and updating its metadata and trigger text.
- Left `README.md` unchanged because the user asked not to surface the explicit skill name there and the existing commit-planning wording remains correct.
- Reworded the older curated-skills ExecPlan so it no longer leaves stale `pd` references or the removed `dot_agents/skills/pd/` path in repo docs.
- Added a lesson to preserve functionality-based README wording when the user does not want internal skill names called out explicitly.
- Verification completed with:
  - `find /home/kevin/linux-config/dot_agents/skills -maxdepth 2 -name SKILL.md | sort`
  - `rg -n 'push-plan|\\bpd\\b|dot_agents/skills/pd' /home/kevin/linux-config/dot_agents /home/kevin/linux-config/plans /home/kevin/linux-config/tasks/lessons.md`
  - `git -C /home/kevin/linux-config diff -- dot_agents/skills plans tasks/lessons.md`
