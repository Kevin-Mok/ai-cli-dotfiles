# README Contract

Use this file to decide whether the root `README.md` is ready to ship
with the current repo state.

## Scope

- Check only the repository root `README.md`.
- Ground every requirement in tracked repo evidence.
- Treat the README as a public operator and recruiter surface, not as
  optional marketing copy.

## Hard Rules

- Never invent commands, flags, prerequisites, setup steps, or
  capabilities that the repo does not support.
- Verify command flags from local `--help`, usage output, or the relevant
  script source before documenting them.
- Document only the commands the README explicitly tells readers to run.
- If a documented command has no meaningful flags to explain, say so
  plainly instead of fabricating options.
- If the README cannot be aligned safely in the same change, fail the
  gate and stop the commit workflow.

## Required Coverage

The root `README.md` must explicitly cover all of the following:

1. Install or bootstrap from the checked-out source.
2. Day-to-day use of the repo.
3. Core command-line flags or options for README-documented entrypoints.
4. A repo-based "Tech Stack And Why Chosen" section.
5. An explicit recruiter-facing explanation of why the repo stands out.

## Tech Stack Section Rules

Derive the stack section from the repository, not from generic dotfiles
or AI-tool assumptions. Center it on the layers clearly evidenced here:

- `chezmoi`
- Codex CLI and tracked Codex config
- the AGENTS instruction chain
- local skills
- Graphiti MCP with Neo4j
- shell and terminal tooling
- Python and Bash automation

For each major layer:

- point to concrete repo evidence
- give one concise "why chosen" rationale
- keep the focus on reproducibility, leverage, verification, memory, or
  terminal ergonomics

## Outcome States

- `pass_no_change`: The README already satisfies the contract.
- `update_in_same_change`: The README can be brought into alignment in
  the current change and must be included before commit.
- `blocked`: The README needs work that cannot be added safely in the
  current commit scope.
