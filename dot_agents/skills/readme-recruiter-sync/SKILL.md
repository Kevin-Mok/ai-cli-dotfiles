---
name: readme-recruiter-sync
description: Keep the repository root `README.md` truthful, runnable, and recruiter-ready. Use when handling commit or push requests, refreshing the root README, or changing repo behavior that can make the README stale, especially for `AGENTS.md`, `AGENTS.repo.md`, `dot_codex/`, `dot_agents/`, `plans/`, setup flows, documented commands, or the repo's positioning and tech-stack explanation.
---

# Readme Recruiter Sync

Keep the root `README.md` aligned with the repository before commit or
docs workflows ship changes. Focus on truthfulness, runnable onboarding,
repo-based tech-stack explanation, and explicit recruiter-facing value.

## Quick Start

1. Read `references/readme-contract.md`.
2. Inspect the root `README.md` and the files the current change touches.
3. Verify whether the README still matches the repository.
4. Update the README in the same change when the contract fails.
5. Stop the commit flow if the README cannot be aligned safely.

## Workflow

1. Determine whether the gate applies.
   - Always apply it before commit or push workflows finalize work.
   - Apply it when the user asks for README work directly.
   - Assume it applies when changes touch `AGENTS.md`, `AGENTS.repo.md`, `dot_codex/`, `dot_agents/`, `plans/`, setup flows, documented commands, or repo positioning.
2. Ground every README claim in repo evidence.
   - Read the relevant config, skills, scripts, docs, and existing README sections.
   - Prefer tracked files over memory.
3. Check the required README sections from `references/readme-contract.md`.
   - install or bootstrap
   - day-to-day use
   - core command flags for README-documented entrypoints
   - repo-based tech stack and why chosen
   - explicit recruiter-facing value
4. Verify commands and flags before documenting them.
   - Use local `--help`, usage output, or script source.
   - If a command has no meaningful flags to explain, say that plainly.
5. Keep the tech stack section grounded in the repo.
   - Center it on `chezmoi`, Codex CLI/config, the AGENTS chain, local skills, Graphiti MCP with Neo4j, shell or terminal tooling, and Python or Bash automation.
   - Pair each layer with one concise "why chosen" rationale.
6. Decide the outcome.
   - `pass_no_change`: README already matches the repo.
   - `update_in_same_change`: README can be fixed now and must ship with the change.
   - `blocked`: README work is required but cannot be added safely inside the current commit scope.

## Commit Flow Rules

- Treat this skill as a hard gate for commit and push workflows in this repo.
- Never waive the gate because the diff looks small.
- Never fabricate recruiter copy, installation steps, tech-stack claims, or CLI flags to get to green.
- If `README.md` is already dirty for unrelated reasons and the current change needs README edits, stop and surface the conflict instead of guessing how to merge scopes.

## Output Contract

Report one of these states:

- `pass_no_change`
- `update_in_same_change`
- `blocked`

When the state is not `pass_no_change`, say exactly which README section
or claim is stale and which repo evidence triggered the mismatch.
