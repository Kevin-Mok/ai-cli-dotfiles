# ExecPlan: Create `open-pr` Skill

## Summary

Create a repo-tracked `open-pr` skill that inspects the current branch against
a requested base branch, drafts a GitHub-ready PR title/body from evidence,
keeps repo PR docs in sync when applicable, and encodes Kevin's LessonOps
DD/Cindy handoff conventions without making the skill LessonOps-only.

## Assumptions

1. The requested install path is `dot_agents/skills/open-pr`.
2. The prompt file is the approved design for this task.
3. LessonOps style can be encoded from the prompt's PR summaries and durable
   feedback log even though live GitHub PR pages are not available through the
   search surface.
4. The root README should mention the new skill only where it strengthens the
   existing local-skills overview.

## Checklist

- [x] Read the prompt, skill-creation guidance, local skill examples,
      feedback log, README, and smoke-test docs.
- [x] Scaffold `dot_agents/skills/open-pr/` with the local skill-creator
      helper.
- [x] Write a lean procedural `SKILL.md` plus reference files for external
      PR-writing guidance and LessonOps-specific style.
- [x] Refresh local skill catalog, smoke-test docs, and README surface.
- [x] Validate the skill and required prompt invariants.
- [x] Review the final diff and record validation results.

## Review

- Created `dot_agents/skills/open-pr/` with a lean procedural `SKILL.md`,
  `agents/openai.yaml`, and two references for general PR-writing guidance and
  LessonOps-specific DD/Cindy handoff style.
- Encoded the required branch-vs-base inspection workflow with `git status`,
  current branch, `git merge-base`, merge-base `git log`, merge-base
  `git diff --stat`, and changed-file inspection before drafting.
- Added guardrails against invented tests, screenshots, smoke results, live
  links, issue references, CI status, or reviewer approval.
- Updated the local skill catalog, root README Git Workflow highlights, and
  `docs/smoke-tests.md` so the new skill surface and reusable smoke check are
  documented together.
- Validation completed with:
  - `python3 /home/kevin/.codex/skills/.system/skill-creator/scripts/quick_validate.py dot_agents/skills/open-pr`
  - `git diff --check -- dot_agents/skills/open-pr/SKILL.md dot_agents/skills/open-pr/agents/openai.yaml dot_agents/skills/open-pr/references/pr-writing-guidance.md dot_agents/skills/open-pr/references/lessonops-style.md dot_agents/skills/README.md docs/smoke-tests.md README.md plans/create-open-pr-skill.md`
  - prompt-invariant Python check covering `name: open-pr`, `git merge-base`,
    merge-base `git log`, merge-base `git diff --stat`, `docs/pr/`, DD/Cindy,
    backend-required notes, smoke-test guidance, known-test-gap guidance,
    no-invented-evidence guidance, six external source links, and `$open-pr`
    metadata.
  - `rg "TODO|\[TODO" dot_agents/skills/open-pr plans/create-open-pr-skill.md`
    returned no matches.
  - `./scripts/executable_readme-recruiter-sync` returned `pass_no_change`.
