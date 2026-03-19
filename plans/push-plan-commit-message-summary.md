# ExecPlan: Add Bottom Commit Message Summary To `push-plan`

## Checklist

- [x] Inspect the tracked `push-plan` skill and confirm the output contract is the right place to define the new summary.
- [x] Update the skill instructions so the final response ends with a compact summary of suggested commit message subjects.
- [x] Confirm whether a README change is required for the documented AI skill surface.
- [x] Verify the final diff only changes the intended skill/docs files.

## Assumptions

- The tracked source of truth is `dot_agents/skills/push-plan/`, even though installed copies also exist under `~/.agents/skills/`.
- The requested summary should be a bottom section that lists concise commit message subject lines only, in proposed commit order.
- No code or executable verification is required because this is a skill-instruction change rather than runtime logic.

## Review Notes

- Added a new `push-plan` output-contract section that requires a bottom-of-response summary of the suggested commit message subjects.
- Updated the skill agent prompt so explicit `$push-plan` invocations also ask for the compact commit-subject summary.
- Confirmed no additional `README.md` edit was needed because the current tracked README text already matched the broader skill-surface wording.
- Verified the shipped wording with:
  - `sed -n '1,220p' dot_agents/skills/push-plan/SKILL.md`
  - `sed -n '40,230p' README.md`
  - `git diff -- dot_agents/skills/push-plan/SKILL.md dot_agents/skills/push-plan/agents/openai.yaml plans/push-plan-commit-message-summary.md`
