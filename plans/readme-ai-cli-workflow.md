# ExecPlan: Reframe README Around AI CLI Workflow

## Checklist

- [x] Copy the provided multi-agent screenshot into the repo for README use.
- [x] Rewrite `README.md` so the primary story is the AI CLI workflow around `dot_agents`, `dot_claude`, `dot_codex`, `AGENTS.md`, and `AGENTS.repo.md`.
- [x] Keep a concise secondary section acknowledging the rest of the chezmoi/Linux dotfiles in the repo.
- [x] Verify the new image path, referenced files, and rendered README structure.

## Assumptions

- The screenshot attached as Image #1 should become the README hero image.
- The focus requested from Image #2 should be reflected in README content by emphasizing `dot_agents/`, `dot_claude/`, `dot_codex/`, `AGENTS.md`, and `AGENTS.repo.md`, not by adding a second image asset.
- A shorter, AI-first README is acceptable even though the repository still includes broader Linux desktop dotfiles.

## Review Notes

- Added `ai-cli-workflow.png` at the repo root using the provided screenshot asset.
- Replaced the old desktop-first README with an AI CLI workflow README centered on the AGENTS chain and the `dot_agents`, `dot_claude`, and `dot_codex` surfaces.
- Expanded the final `Rest Of Repo` section into detailed mini-subsections for shells, editor and terminal setup, window manager and UI, productivity tools, and machine-specific automation.
- Added the new `Rest Of Repo` mini-subsections to the README table of contents so the longer desktop/dotfiles section stays navigable.
- Corrected the README sync section to reference the actual tracked Claude path `~/.claude/settings.json`.
- Verification completed with:
  - `identify ai-cli-workflow.png`
  - `sed -n '1,240p' README.md`
  - `git status --short README.md tasks/lessons.md plans/readme-ai-cli-workflow.md ai-cli-workflow.png`
  - `rg -n '^## Rest Of Repo|^### ' README.md`
