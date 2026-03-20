# ExecPlan: README Recruiter Sync Skill

## Summary

Add a repo-local `readme-recruiter-sync` skill that hard-gates commit workflows on README truthfulness. The gate should keep the root `README.md` aligned with the repository and require explicit coverage for install/setup, day-to-day use, core command flags, repo-based tech stack rationale, and recruiter-facing value.

## Assumptions

1. The primary README surface is the repository root `README.md`.
2. "Command line flags" applies only to commands the README explicitly asks readers to run.
3. The tech stack section must be based on technologies clearly evidenced in this repository today.
4. Pre-existing dirty files outside this scope must remain untouched.

## Plan

- [x] Scaffold `dot_agents/skills/readme-recruiter-sync/` with `SKILL.md`, `agents/openai.yaml`, and `references/readme-contract.md`.
- [x] Update repo-local guidance in `AGENTS.repo.md` and `dot_codex/AGENTS.md` to require the new README gate for commit workflows.
- [x] Update `commit-push`, `commit-session`, and `commit-plan` so commit-oriented skills enforce or surface the README gate.
- [x] Refresh `README.md` and `dot_agents/skills/README.md` so the new skill and the required README sections are visible and truthful.
- [x] Record the durable workflow preference in `dot_agents/skills/feedback-memory/feedback.log`.
- [x] Validate the new skill and spot-check README claims against the repo.

## Review

- Added the new `readme-recruiter-sync` skill with agent metadata and a repo-based README contract reference.
- Wired the gate into repo-local AGENTS guidance plus the `commit-push`, `commit-session`, and `commit-plan` skills.
- Expanded the root `README.md` with install/bootstrap, day-to-day use, command reference, repo-based tech stack rationale, and recruiter-facing value sections.
- Recorded the durable commit-time README rule in `dot_agents/skills/feedback-memory/feedback.log` and the related correction in `tasks/lessons.md`.
- Validation:
  - `python3 /home/kevin/.codex/skills/.system/skill-creator/scripts/quick_validate.py dot_agents/skills/readme-recruiter-sync`
  - `git diff --check -- AGENTS.repo.md dot_codex/AGENTS.md README.md dot_agents/skills/README.md dot_agents/skills/commit-push/SKILL.md dot_agents/skills/commit-session/SKILL.md dot_agents/skills/commit-plan/SKILL.md dot_agents/skills/feedback-memory/feedback.log tasks/lessons.md`
  - Spot-checked `chezmoi --help`, `chezmoi apply --help`, `chezmoi diff --help`, `codex --help`, and `codex mcp list --help` before writing README command/flag coverage.
  - Verified `git remote -v` before correcting the public clone URL and GitHub link targets in `README.md`.
