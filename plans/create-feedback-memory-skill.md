# ExecPlan: Add `feedback-memory` Skill

## Checklist

- [x] Inspect the tracked local skill structure and decide whether the skill also needs an installed copy under `~/.agents/skills/`.
- [x] Add `dot_agents/skills/feedback-memory/` with `SKILL.md`, `feedback.log`, and `agents/openai.yaml`.
- [x] Update `dot_agents/skills/README.md` and `README.md` to reflect the new AI skill surface.
- [x] Install the skill into `~/.agents/skills/feedback-memory/` so it is available to future sessions immediately.
- [x] Validate the tracked skill folder and review the final diff.

## Assumptions

- The tracked source of truth is `dot_agents/skills/feedback-memory/`, and the canonical mutable log should stay in that chezmoi source tree instead of in the installed copy under `~/.agents/skills/`.
- The skill should stay lean and procedural, using a plain append-only `feedback.log` rather than JSON, schemas, or extra helper scripts.
- `README.md` and `dot_agents/skills/README.md` should be refreshed because `dot_agents/skills/` is part of the repo's documented AI operating surface.

## Review Notes

- Updated `feedback-memory` so it prefers `~/linux-config/dot_agents/skills/feedback-memory/feedback.log` as the canonical log path, falls back to a local skill-folder log only when the repo path is missing, and explicitly avoids maintaining two logs at once.
- Added `.agents/skills/feedback-memory/feedback.log` to `.chezmoiignore` so chezmoi keeps the installed skill metadata in `~/.agents/skills/` but leaves the mutable log in the tracked repo copy.
- Refreshed the tracked `agents/openai.yaml`, the root skill bullet in `README.md`, and the local skills catalog paragraph in `dot_agents/skills/README.md` to describe the repo-tracked log behavior.
- Applied the managed skill files to the live install with a targeted `chezmoi apply --no-tty -v ~/.agents/skills/README.md ~/.agents/skills/feedback-memory/SKILL.md ~/.agents/skills/feedback-memory/agents/openai.yaml`.
- Recorded the user correction about tracking durable preferences in `tasks/lessons.md`.
- Verification completed with:
  - `python3 /home/kevin/.codex/skills/.system/skill-creator/scripts/quick_validate.py /home/kevin/linux-config/dot_agents/skills/feedback-memory`
  - `chezmoi ignored | rg 'feedback-memory/feedback\.log'`
  - `chezmoi diff ~/.agents/skills/README.md ~/.agents/skills/feedback-memory/SKILL.md ~/.agents/skills/feedback-memory/agents/openai.yaml`
  - `test -f /home/kevin/linux-config/dot_agents/skills/feedback-memory/feedback.log`
  - `test ! -e /home/kevin/.agents/skills/feedback-memory/feedback.log`
