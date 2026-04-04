# Prompt: Make Claude Share Global AGENTS And Skills With Codex

Use this prompt to update this repo so Claude uses
`dot_codex/AGENTS.md` as its global default instructions and can access
the repo-tracked skill library without breaking the existing Codex skill
surface.

## Context Files To Include

Paste these into the prompt context before asking for the change:

### Required

- `dot_codex/AGENTS.md`
- `AGENTS.md`
- `AGENTS.repo.md`
- `dot_claude/settings.json`
- `dot_agents/skills/README.md`
- a short file list for `dot_agents/skills/`
- `README.md`
- `docs/smoke-tests.md`

### Optional But Useful

- `plans/claude-global-agents-default.md` if it exists
- any existing tracked or live Claude files such as:
  - `dot_claude/CLAUDE.md`
  - `~/.claude/CLAUDE.md`
  - `~/.claude/skills/`
  - `~/.claude/agents/`
  - `~/.claude/rules/`
- one or two representative skill files from `dot_agents/skills/`
- any local docs or changelog notes that confirm Claude's current
  support for global `CLAUDE.md` imports and skill discovery

### Do Not Include Unless Needed

- the full repo tree
- unrelated shell, editor, window-manager, or terminal config
- large logs or broad home-directory dumps
- unrelated skills outside `dot_agents/skills/`

## Prompt

```md
You are an expert AI tooling engineer working in the repo
`/home/kevin/linux-config`.

Task:
Make Claude share this repo's canonical AGENTS instructions and
repo-tracked skills with Codex as much as possible, while preserving
tool-specific functionality and not regressing the existing Codex setup.

Primary goals:
1. Make Claude use `dot_codex/AGENTS.md` as the default global
   instructions across projects.
2. Expose the repo-tracked skills under `dot_agents/skills/` to Claude.
3. Preserve the existing Codex skill flow and functionality.
4. Avoid duplicate sources of truth for shared instructions or skills.

Constraints:
- Follow the repo's AGENTS rules and README-sync expectations.
- Use a small, reversible diff.
- Do not break production behavior.
- Do not remove or rewrite existing Codex behavior unless required.
- Prefer one shared tracked source of truth over copied duplicates.
- If a skill is Codex-biased, preserve it and document the compatibility
  risk instead of silently dropping it.

Required behavior:
- Add a tracked Claude global instructions file if needed, and wire it
  so Claude loads `dot_codex/AGENTS.md` globally across projects.
- Preserve a clean shared-source model: `dot_codex/AGENTS.md` remains
  the canonical instructions file, not a copied Claude-specific clone.
- Make Claude discover the shared skills from `dot_agents/skills/`
  without breaking Codex's current `~/.agents/skills` setup.
- Prefer symlinks or other shared-source wiring over duplicated copied
  skill directories unless Claude requires physical copies.
- If Claude needs a separate tracked install surface under `dot_claude/`
  or a related path, create it in a way that still points back to the
  repo-tracked skill sources.

Compatibility expectations:
- Do not assume every skill is fully Claude-native.
- Keep all repo-tracked skills available to Claude, but identify any
  that have Codex-specific assumptions such as tool names, superpowers,
  or platform-only workflow steps.
- Where a small compatibility note or wrapper is enough, use that.
- Do not do a large rewrite of every skill unless it is truly required
  to make discovery work.
- Preserve global/shared skill availability between Codex and Claude as
  much as the platforms allow.

Documentation requirements:
- Update `README.md` so it truthfully explains that:
  - `dot_codex/AGENTS.md` is also wired into Claude globally
  - the repo-tracked skills are intended to be shared across Codex and
    Claude where possible
  - any tool-specific compatibility layer is called out clearly
- Update `docs/smoke-tests.md` with reusable manual checks for:
  - Claude global instruction loading from the tracked AGENTS file
  - Claude visibility of the shared skill surface
  - no regression to the Codex skill surface

Implementation approach:
1. Inspect the current tracked Claude surface in `dot_claude/` and the
   live Claude config under `~/.claude/` if needed.
2. Inspect how the current repo-tracked skills are exposed to Codex.
3. Decide the minimal shared-source wiring that lets Claude load the
   instructions and discover the skills.
4. Implement the change.
5. Run the repo's refresh/sync step if the repo expects one.
6. Verify the rendered/live Claude files are present and point to the
   intended tracked sources.
7. Review the final diff for unnecessary churn.

Verification requirements:
- Show the exact commands used to verify the new Claude global
  instruction path.
- Show the exact commands used to verify the Claude skill surface.
- Show the exact commands used to confirm Codex's current skill surface
  was not broken.
- Do not claim success without fresh verification output.

Output requirements:
1. Summarize the final architecture for shared instructions and shared
   skills between Codex and Claude.
2. List the files created or changed.
3. Call out any skills that remain partially platform-specific.
4. Provide the exact verification commands that were run.
5. Note any assumptions or follow-up risks.
6. Suggest a concise Conventional Commit message.
```
