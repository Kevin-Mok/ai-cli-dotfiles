# ExecPlan: Add `smoke-test-capture` Skill

## Summary

Add a repo-tracked local skill that keeps a shared manual smoke-test
document current whenever work reveals a manual verification step or an
obvious gap in smoke coverage. The canonical checklist should live at
`docs/smoke-tests.md`, stay grouped by area, and be backed by a small
repo-instruction hook so the workflow is not optional.

## Checklist

- [x] Run a baseline pressure scenario that shows the current workflow
      does not explicitly maintain a shared smoke-test document.
- [x] Scaffold `dot_agents/skills/smoke-test-capture/` with agent
      metadata and replace the template with the actual workflow.
- [x] Add `docs/smoke-tests.md` with grouped starter sections and entry
      guidance.
- [x] Wire the standing workflow rule into `dot_codex/AGENTS.md`.
- [x] Refresh `README.md` and `dot_agents/skills/README.md` for the new
      skill and smoke-test doc surface.
- [x] Apply the managed skill files to the live `~/.agents/skills/`
      install.
- [x] Validate the new skill and review the final diff.

## Assumptions

- `docs/smoke-tests.md` is the single source of truth for manual smoke
  coverage.
- The skill should allow implicit invocation because the user wants this
  workflow to happen by default, not only on explicit requests.
- The skill can stay lean with only `SKILL.md` and `agents/openai.yaml`
  unless implementation reveals a concrete need for scripts or
  references.

## Review Notes

- Baseline pressure scenario confirmed the missing behavior: without the
  new skill, the suggested update surfaces were the skill files, README
  surfaces, and repo instructions, but not a shared smoke-test document.
- Scaffolded `dot_agents/skills/smoke-test-capture/` with the
  skill-creator helper, then replaced the template with a lean workflow
  that points at `docs/smoke-tests.md`, groups checks by area, dedupes
  entries, and rewrites stale expectations instead of stacking
  duplicates.
- Added `docs/smoke-tests.md` with starter sections for skills/docs, the
  installed skill surface, and repo instructions so future work has a
  canonical checklist to extend.
- Added a `### Smoke Tests` repo-local rule in `dot_codex/AGENTS.md` and
  refreshed both README surfaces so the new skill and checklist are part
  of the documented operating layer.
- The first targeted `chezmoi apply` failed because
  `~/.agents/skills/smoke-test-capture/agents/` did not exist yet. The
  fix was to create the directory explicitly and rerun the same targeted
  apply.
- Post-change pressure scenario passed: when pointed at the new skill,
  the agent updated the canonical checklist path and used the required
  `Action` + `Expected` entry format.
- Validation completed with:
  - `git diff --check -- plans/add-smoke-test-capture-skill.md dot_agents/skills/smoke-test-capture/SKILL.md dot_agents/skills/smoke-test-capture/agents/openai.yaml docs/smoke-tests.md dot_codex/AGENTS.md dot_agents/skills/README.md README.md`
  - `python3 /home/kevin/.codex/skills/.system/skill-creator/scripts/quick_validate.py /home/kevin/linux-config/dot_agents/skills/smoke-test-capture`
  - `test -f /home/kevin/.agents/skills/smoke-test-capture/SKILL.md && test -f /home/kevin/.agents/skills/smoke-test-capture/agents/openai.yaml`
  - `cmp -s /home/kevin/linux-config/dot_agents/skills/smoke-test-capture/SKILL.md /home/kevin/.agents/skills/smoke-test-capture/SKILL.md && cmp -s /home/kevin/linux-config/dot_agents/skills/smoke-test-capture/agents/openai.yaml /home/kevin/.agents/skills/smoke-test-capture/agents/openai.yaml`
  - `chezmoi diff ~/.agents/skills/README.md ~/.agents/skills/smoke-test-capture/SKILL.md ~/.agents/skills/smoke-test-capture/agents/openai.yaml`
- An additional independent review subagent was started but did not
  return findings before being interrupted, so the final review is based
  on the passing validation set and direct diff inspection above.
