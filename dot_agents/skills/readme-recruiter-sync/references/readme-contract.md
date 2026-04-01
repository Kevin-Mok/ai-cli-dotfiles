# README Contract

Use this file to decide whether the root `README.md` is ready to ship
with the current repo state.

## Scope

- Check only the repository root `README.md`.
- Ground every requirement in tracked repo evidence.
- Treat the README as a public operator and recruiter surface, not as
  optional marketing copy.

## Hard Rules

- Default to recruiter-first ordering unless the user explicitly asks
  for a different README structure.
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

1. A substantive opening hook, usually at least two sentences or one
   short paragraph, that explains what the repo is, why it matters, and
   why it is worth reviewing.
2. Install or bootstrap from the checked-out source.
3. Day-to-day use of the repo.
4. Core command-line flags or options for README-documented entrypoints.
5. A repo-based "Tech Stack And Why Chosen" section.
6. Recruiter-facing value consolidated into the opening hook or opening
   section rather than scattered across the document.

## Top-Of-File Hierarchy

Before the first setup-heavy section, fenced code block, or command
block, the README should usually surface the repo's strongest proof:

- a longer hook, not a thin one-line summary
- recruiter-facing value consolidated into that opening hook or opening
  section, not split across multiple distant sections
- a repo-based `Tech Stack And Why Chosen` section

By default, `Quick Start`, `How to run`, and dense command reference
sections belong later in the document. Only keep them near the top when
the user explicitly requests an operator-first README or the repo's
audience is clearly operator-first.

Strict default:

- If a README contains top-level `Quick Start`, `Install`, `Setup`, `How
  to run`, or a major fenced command block before both:
  - the opening recruiter-facing hook or opening section, and
  - `Tech Stack And Why Chosen`,
  then the README fails the gate unless the user explicitly asked for
  that ordering.

Treat these as failures:

- `Quick Start`, install/setup, or the first major command block appears
  before both the opening recruiter-facing hook and stack rationale
- the hook is generic enough that it could describe many repos
- recruiter-facing value is repeated in multiple distant sections
  instead of being consolidated near the top
- the README hides stack rationale or impressiveness far below setup
- the README is technically accurate but still front-loads instructions
  over why the repo is notable
- a features/browse section is being treated as a substitute for a real
  opening recruiter hook

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
