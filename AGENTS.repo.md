# AGENTS.repo.md

Repository-specific Codex guidance for this repo.

After reading the shared baseline in `AGENTS.md`, read and follow `dot_codex/AGENTS.md` as the authoritative Codex instruction document for this repository.

`dot_codex/AGENTS.md` is the source of truth for Codex behavior here. If overlapping guidance appears in `AGENTS.md`, this file, or older generated material, prefer `dot_codex/AGENTS.md` unless a higher-precedence active-session instruction says otherwise.

## README Sync For AI Surface Changes

When you update the repo's AI operating surface, update `README.md`
in the same change so the visible documentation keeps pace with the
actual workflow.

Treat these paths as the core AI operating surface for README sync:

- `AGENTS.md`
- `AGENTS.repo.md`
- `dot_codex/`
- `dot_agents/`
- `plans/`

When those files or directories gain meaningful new instructions,
skills, config, or planning workflow, refresh the README to call out
the addition and explain why it matters.
