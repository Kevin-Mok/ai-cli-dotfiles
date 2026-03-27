---
name: readme-recruiter-sync
description: Use when handling commit or push requests, refreshing the root README, or changing repo behavior that can make the root README stale, especially when the README needs to sell the repo clearly to recruiters before setup details take over
---

# Readme Recruiter Sync

Keep the root `README.md` aligned with the repository before commit or
docs workflows ship changes. Focus on truthfulness, recruiter-first
information hierarchy, runnable onboarding, repo-based tech-stack
explanation, and explicit recruiter-facing value.

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
3. Audit the front-of-file hierarchy before checking coverage.
   - Default to a recruiter-first structure unless the user explicitly asks for a different order.
   - Require the README to open with a substantive hook, usually at least two sentences or one short paragraph, that says what the repo is, why it matters, and why another engineer or recruiter should care.
   - Surface proof early: recruiter-facing differentiators plus a repo-based `Tech Stack And Why Chosen` section should appear before setup-heavy sections unless the user explicitly asks for a different order.
   - Push `Quick Start`, `How to run`, command reference sections, and early fenced code blocks later by default, for readers who are already interested.
   - Apply this strict default unless explicitly overridden: if the README has a top-level `Quick Start`, `Install`, `Setup`, `How to run`, or an early fenced command block before a top-level recruiter-value section and before `Tech Stack And Why Chosen`, the README is stale.
   - Treat these as stale even if the facts are correct:
     - a generic one-line intro that does not sell the repo
     - `Quick Start`, install/setup, or the first major command block appearing before both recruiter value and stack rationale
     - tech stack or recruiter value buried deep in the README
     - a browse/features section being used as a substitute for why the repo is impressive
4. Check the required README sections from `references/readme-contract.md`.
   - install or bootstrap
   - day-to-day use
   - core command flags for README-documented entrypoints
   - repo-based tech stack and why chosen
   - explicit recruiter-facing value
5. Verify commands and flags before documenting them.
   - Use local `--help`, usage output, or script source.
   - If a command has no meaningful flags to explain, say that plainly.
6. Keep the tech stack section grounded in the repo.
   - Center it on `chezmoi`, Codex CLI/config, the AGENTS chain, local skills, Graphiti MCP with Neo4j, shell or terminal tooling, and Python or Bash automation.
   - Pair each layer with one concise "why chosen" rationale.
7. Decide the outcome.
   - `pass_no_change`: README already matches the repo.
   - `update_in_same_change`: README can be fixed now and must ship with the change.
   - `blocked`: README work is required but cannot be added safely inside the current commit scope.

## Default Order

Prefer this order unless the user explicitly wants something else or the
repo is operator-first by nature:

1. Title plus longer hook
2. Why this repo is worth attention or why it stands out
3. Tech stack and why chosen
4. Optional architecture or implementation snapshot
5. Install, bootstrap, day-to-day commands, and deeper operator docs

## Commit Flow Rules

- Treat this skill as a hard gate for commit and push workflows in this repo.
- Never waive the gate because the diff looks small.
- Never fabricate recruiter copy, installation steps, tech-stack claims, or CLI flags to get to green.
- Never treat section presence as enough when the information hierarchy still buries the repo's best proof below setup instructions.
- If `README.md` is already dirty for unrelated reasons and the current change needs README edits, stop and surface the conflict instead of guessing how to merge scopes.

## Output Contract

Report one of these states:

- `pass_no_change`
- `update_in_same_change`
- `blocked`

When the state is not `pass_no_change`, say exactly which README section
or claim is stale, whether the failure is coverage or hierarchy, and
which repo evidence triggered the mismatch.
