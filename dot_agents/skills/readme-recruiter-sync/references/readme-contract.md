# README Contract

Use this file to decide whether the root `README.md` is ready to ship with
the current repo state.

## Scope

- Check only the repository root `README.md`.
- Ground every requirement in tracked repo evidence.
- Treat the README as a public operator and recruiter-facing surface.

## Hard Rules

- Default to recruiter-first ordering unless the user explicitly asks
  for a different structure.
- Never invent commands, flags, prerequisites, setup steps, or capabilities
  that the repo does not support.
- Verify command flags from local `--help`, usage output, or relevant script
  source before documenting them.
- Document only commands the README explicitly tells readers to run.
- If a documented command has no meaningful flags to explain, say that plainly.
- If the README cannot be aligned safely in the same change, return `blocked`.

## Required Coverage

The root `README.md` must explicitly cover all of the following:

1. A substantive opening hook (usually two short paragraphs or a paragraph of ~35+ words)
   explaining:
   - what the repo is,
   - who should care,
   - and why it is worth reading/reviewing.
2. Install or bootstrap from checked-out source.
3. Day-to-day use of the repo.
4. Core command-line flags or options for README-documented entrypoints.
5. A repo-based "Tech Stack And Why Chosen" section.
6. Recruiter-facing value consolidated into the opening hook rather than
   scattered.

## Top-of-File Hierarchy (Hard)

Before setup-heavy sections or the first major command block, the README
should normally surface proof that this repo is worth attention:

- opening hook with problem/impact framing,
- explicit recruiter-facing value consolidated near the top,
- `Tech Stack And Why Chosen`.

Default behavior (unless operator-first is explicitly requested):

- If a README has top-level `Quick Start`, `Install`, `Setup`, `How to run`,
  or a major fenced command block before both:
  - a substantive opening hook, and
  - `Tech Stack And Why Chosen`,
  it fails the gate.
- If the opening hook is generic and could describe any project, it fails.
- If the strongest proof is buried in a feature list without a clear opening
  value section, it fails.
- If setup or command-heavy sections precede evidence and positioning, it fails.

Treat these as hard failures:

- command-heavy content before the opening hook and stack rationale,
- recruiter-facing value repeated in multiple distant sections instead of being
  consolidated up-front,
- repo stack rationale hidden below setup and bootstrap,
- a browse/features section pretending to be a hook.

## Tech Stack Section Rules

Derive the stack section from the repository, not generic assumptions.
For each major layer present in this repo, include concrete evidence + one
concise rationale:

- `chezmoi`
- Codex CLI and tracked Codex config
- the AGENTS instruction chain
- local skills
- Graphiti MCP with Neo4j
- shell and terminal tooling
- Python and Bash automation

Focus rationale around reproducibility, leverage, verification, and ergonomics.

## Outcome States

- `pass_no_change`: README already satisfies the contract.
- `update_in_same_change`: README can be fixed in current change.
- `blocked`: README changes cannot be safely added in this scope.
