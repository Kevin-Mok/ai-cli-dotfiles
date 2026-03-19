# ExecPlan: Add `commit-push` Skill

## Checklist

- [x] Inspect the existing local commit workflow skill and confirm the new skill should remain separate from `commit-plan`.
- [x] Scaffold `dot_agents/skills/commit-push/` with agent metadata.
- [x] Replace the scaffolded content with explicit instructions for verified commit-and-push requests.
- [x] Update `README.md` to document the new local skill surface.
- [x] Validate the new skill folder and review the resulting diff.

## Assumptions

- The user wants an explicit `commit-push` skill instead of expanding the existing read-only `commit-plan` planning skill.
- The new skill should keep safety rails: inspect scope, verify changes, and avoid bundling unrelated dirty work into a push.
- `README.md` should be refreshed because `dot_agents/skills/` is part of the repo's documented AI operating surface.

## Review Notes

- Kept the new skill separate from `commit-plan` so the existing skill remains a read-only commit-planning workflow while `commit-push` handles explicit write requests.
- Scaffolded `dot_agents/skills/commit-push/` with the skill-creator `init_skill.py` helper, then replaced the template body with a workflow focused on inspect, verify, stage, commit, and push.
- Added `policy.allow_implicit_invocation: false` to the generated `agents/openai.yaml` so the skill stays explicit-only because it performs write actions.
- Updated `README.md` to mention direct verified git shipping as part of the documented local skill surface without surfacing the internal skill name in the prose.
- Recorded the user naming correction in `tasks/lessons.md`.
- Validation completed with:
  - `python3 quick_validate.py /home/kevin/linux-config/dot_agents/skills/commit-push`
  - `git diff -- dot_agents/skills/commit-push README.md plans/immediate-commit-push-skill.md tasks/lessons.md`
  - `git status --short dot_agents/skills/commit-push README.md plans/immediate-commit-push-skill.md tasks/lessons.md`
