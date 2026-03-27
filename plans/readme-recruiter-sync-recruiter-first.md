# ExecPlan: Recruiter-First Readme Recruiter Sync

## Summary

Strengthen the repo-local `readme-recruiter-sync` skill so it validates
README information hierarchy, not just section coverage. The default
behavior should front-load hook, differentiators, and tech-stack
rationale, while moving setup and command-heavy sections later unless a
user explicitly asks for an operator-first order.

## Assumptions

1. The tracked skill source of truth is `dot_agents/skills/readme-recruiter-sync/`.
2. This task updates the skill package and its contract, not the
   downstream README generated from it.
3. Recruiter-first ordering is the default, but explicit user overrides
   still win.
4. The current `zoo-blog/README.md` is a valid pressure case because it
   is accurate yet still demonstrates the hierarchy failure that needs
   to be caught.

## Checklist

- [x] Re-read the current skill, contract, metadata, and the pressure
  case that exposed the gap.
- [x] Update the skill workflow so hierarchy and hook quality are part
  of the gate, not optional taste.
- [x] Update the contract and agent metadata so discovery and execution
  reflect the recruiter-first default.
- [x] Validate the skill package and pressure-test the new behavior.
- [x] Record the durable lesson from this correction.

## Review

- Added explicit hierarchy checks to the skill so README evaluation now
  rejects accurate-but-badly-ordered docs, not just missing sections.
- Tightened the contract with concrete top-of-file rules: a real opening
  hook, explicit recruiter-value and tech-stack sections before setup,
  early proof before code blocks, and late setup by default.
- Updated the agent metadata so discovery and default prompting match
  the new recruiter-first behavior.
- Validation:
  - `python3 /home/kevin/.codex/skills/.system/skill-creator/scripts/quick_validate.py dot_agents/skills/readme-recruiter-sync`
  - `git diff --check -- dot_agents/skills/readme-recruiter-sync/SKILL.md dot_agents/skills/readme-recruiter-sync/references/readme-contract.md dot_agents/skills/readme-recruiter-sync/agents/openai.yaml plans/readme-recruiter-sync-recruiter-first.md tasks/lessons.md`
  - Independent pressure check against `/home/kevin/coding/zoo-blog/README.md`, which now fails for hierarchy because it surfaces `Quick Start` before standout value and stack rationale.
