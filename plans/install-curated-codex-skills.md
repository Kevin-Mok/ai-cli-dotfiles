# ExecPlan: Install Curated Codex Skills Into `dot_agents`

## Checklist

- [x] Add the selected curated skill directories under `dot_agents/skills/`.
- [x] Preserve each skill's bundled `SKILL.md`, scripts, assets, references, agent manifests, and license files.
- [x] Update `README.md` where it currently describes `dot_agents/skills/` as only containing the commit-planning skill.
- [x] Verify the copied skill tree and review the final `git diff` for the new skills and docs.

## Assumptions

- `dot_agents/skills/` is the correct chezmoi-tracked source for local skills that should materialize under `~/.agents/skills/`.
- `cp.md` is a shortlist note, not a standalone skill artifact to install as-is.
- The intended install set is the eight explicit curated skills at the top of `cp.md`: `playwright`, `screenshot`, `imagegen`, `gh-fix-ci`, `openai-docs`, `pdf`, `playwright-interactive`, and `transcribe`.

## Review Notes

- Added the eight curated skills under `dot_agents/skills/`: `playwright`, `screenshot`, `imagegen`, `gh-fix-ci`, `openai-docs`, `pdf`, `playwright-interactive`, and `transcribe`.
- Preserved the upstream skill structure for each installed skill, including the bundled `SKILL.md` plus supporting license files, scripts, assets, references, and agent manifests.
- Reworked `README.md` so it no longer frames `dot_agents` as a single commit-planning skill folder and instead documents the broader local skill library.
- Added a new `Why This Improves Agentic Engineering` section to explain how the AGENTS chain, Codex config, Claude permissions, and tracked skill library make the terminal agents more autonomous and repeatable.
- Verification completed with:
  - `rg -n 'Why This Improves Agentic Engineering|dot_agents/skills/push-plan/SKILL.md|playwright|gh-fix-ci|openai-docs|transcribe|agentic engineering' /home/kevin/linux-config/README.md`
  - `sed -n '1,230p' /home/kevin/linux-config/README.md`
  - `find /home/kevin/linux-config/dot_agents/skills -maxdepth 2 -type f | sort`
  - `git -C /home/kevin/linux-config diff -- README.md plans/install-curated-codex-skills.md dot_agents/skills`
