# ExecPlan: Reframe README Around Four-Codex Productivity

## Checklist

- [x] Rewrite `README.md` so the primary story is a
  four-Codex workflow that improves agentic engineering
  productivity through tracked dotfiles.
- [x] Update the hero copy and early sections to center
  four parallel Codex sessions for exploration,
  implementation, review, and verification.
- [x] Reframe the instruction chain, Codex config, local
  skills, and `plans/` as the dotfile surfaces that make
  the workflow faster and more repeatable.
- [x] De-emphasize Claude and other non-Codex tooling so
  they no longer compete with the main README narrative.
- [x] Compress the broader desktop-dotfiles material into a
  short secondary section.
- [x] Restore the hero screenshot and table of contents so
  the README keeps strong visual navigation.
- [x] Re-expand the broader dotfiles coverage under
  `Rest Of Repo` so the non-AI surfaces stay visible.
- [x] Add stronger bold emphasis in the README copy without
  diluting the Codex-first framing.
- [x] Verify the README structure, key terminology, and
  changed-file scope.

## Assumptions

- "4 Codex's" means four concurrent Codex terminal sessions,
  not four different products or providers.
- The existing `ai-cli-workflow.png` image is still suitable;
  only the README framing around it needs to change.
- A Codex-first README is preferred even though this repo
  still tracks broader Linux and desktop dotfiles.

## Review Notes

- Replaced the mixed AI CLI framing with a four-Codex
  productivity narrative at the top of the README.
- Reworked the main sections around workflow, supporting
  dotfiles, productivity gains, sync/apply, and a shorter
  summary of the rest of the repo.
- Removed Claude from the primary story so the README reads
  as a Codex operating environment rather than a general AI
  tools overview.
- Kept the AGENTS chain, `dot_codex/config.toml`,
  `dot_agents/skills/`, and `plans/` as the core surfaces
  behind the workflow.
- Restored the screenshot, table of contents, and detailed
  `Rest Of Repo` subsections after user feedback so the
  README still documents the broader dotfiles surface.
- Tightened the prose with more visible emphasis via bolded
  lead phrases and key claims rather than flattening the
  README into plain paragraphs.
- Verification completed with:
  - `sed -n '1,260p' README.md`
  - `sed -n '261,360p' README.md`
  - `rg -n '^## |^### ' README.md`
  - `rg -n 'Table of Contents|ai-cli-workflow\\.png|Rest Of Repo|Shells And Shared Shortcuts|four-Codex|dot_codex|dot_agents|agentic engineering|chezmoi' README.md`
  - `git diff -- README.md plans/readme-four-codex-productivity.md`
  - `git status --short README.md plans/readme-four-codex-productivity.md`
