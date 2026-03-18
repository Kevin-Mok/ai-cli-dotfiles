# ExecPlan: Add GitHub Source Links To README Paths

## Checklist

- [x] Inventory the README path mentions that describe tracked repo files and directories.
- [x] Choose a consistent GitHub URL scheme for file, section, and directory links.
- [x] Update `README.md` so described repo paths link to the relevant GitHub file, line, or tree view.
- [x] Verify the README formatting and confirm the remaining unlinked code spans are intentional.

## Assumptions

- The requested scope is the full README, not only the AI-layer sections.
- Absolute GitHub URLs are preferred over relative links because line anchors are part of the goal.
- Using `blob/master/... ?plain=1#L...` for file links and `tree/master/...` for directory links is acceptable.

## Review Notes

- Replaced described README path mentions with reference-style Markdown links so the prose stays readable while still pointing at GitHub blobs, trees, and section anchors.
- Used precise anchors for the AI operating layer: `AGENTS.md`, `AGENTS.repo.md`, `dot_codex/AGENTS.md`, `dot_codex/config.toml`, `dot_agents/skills/`, and `plans/`.
- Linked the broader dotfiles bullets as well, covering the shell, editor, window-manager, productivity, and scripts sections.
- Left non-repo tokens unlinked on purpose, including commands, environment paths, app names, and generic filenames like `SKILL.md`.
- Kept an unrelated in-progress Graphiti README section intact when it appeared in the working tree during the edit, and only layered the requested GitHub links around it.

## Verification

- `git diff -- README.md plans/readme-github-path-links.md`
- `rg -n '^\[[^]]+\]: https://github.com/Kevin-Mok/linux-config/(blob|tree)/master/' README.md`
- `/usr/bin/bash -c "while read -r path; do test -e \"$path\" || echo \"missing: $path\"; done < <(sed -n 's#^\\[[^]]\\+\\]: https://github.com/Kevin-Mok/linux-config/\\(blob\\|tree\\)/master/\\([^?]*\\).*#\\2#p' README.md)"`
