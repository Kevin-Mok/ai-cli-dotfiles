# AGENTS.repo.md

Repository-specific Codex guidance for this repo.

After reading the shared baseline in `AGENTS.md`, read and follow `dot_codex/AGENTS.md` as the authoritative Codex instruction document for this repository.

`dot_codex/AGENTS.md` is the source of truth for Codex behavior here. If overlapping guidance appears in `AGENTS.md`, this file, or older generated material, prefer `dot_codex/AGENTS.md` unless a higher-precedence active-session instruction says otherwise.

## README Sync And Commit Gate

When you update the repo's AI operating surface or any repo behavior
that the root `README.md` claims, update `README.md` in the same change
so the visible documentation keeps pace with the actual workflow.

Treat these paths as the core AI operating surface for README sync:

- `AGENTS.md`
- `AGENTS.repo.md`
- `dot_codex/`
- `dot_agents/`
- `plans/`

When those files or directories gain meaningful new instructions,
skills, config, or planning workflow, refresh the README to call out
the addition and explain why it matters.

When the root `README.md` covers `dot_agents/skills/`, summarize
highlights from each skill category instead of trying to inventory every
individual skill. Keep the exhaustive catalog in
`dot_agents/skills/README.md` and use the root README for representative
examples plus why the categories matter.

Before any commit or push workflow finalizes work in this repo, run the
`readme-recruiter-sync` skill against the root `README.md`.

Treat the gate as failed until the root `README.md` is both aligned with
the repository and explicitly covers:

- how to install or bootstrap this repo from the checked-out source
- how to use it day to day
- core command-line flags or options for the commands the README tells readers to run
- a repo-based "Tech Stack And Why Chosen" section centered on `chezmoi`, Codex CLI/config, the AGENTS instruction chain, local skills, Graphiti MCP with Neo4j, shell or terminal tooling, and Python or Bash automation
- why the repo is impressive to recruiters

Never invent commands, flags, setup steps, or stack claims to satisfy
the gate. If the README cannot be updated safely in the same change,
stop the commit workflow instead of hand-waving past the mismatch.
