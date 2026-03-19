# ExecPlan: Install Frontend Design Skills

## Checklist

- [x] Inspect the current `dot_agents/skills/` structure and existing in-progress docs changes before editing.
- [x] Import the five frontend design skills under `dot_agents/skills/` using repo-native slugs.
- [x] Add `agents/openai.yaml` and explicit `SOURCE.md` provenance files to each imported skill directory.
- [x] Update `README.md` to reflect the expanded skill surface and explicit source attribution.
- [x] Update `tasks/lessons.md` for the ownership-versus-permission and on-disk provenance corrections.

## Assumptions

- The source repo `Leonxlnx/taste-skill` is external, but the content can be ingested into this repo with explicit permission.
- The canonical local skill slugs should follow the source `name:` frontmatter values instead of the source folder names.
- Explicit source attribution should live in tracked files next to the imported material, not only in plan notes or chat.

## Review Notes

- Imported five frontend-oriented skills from `Leonxlnx/taste-skill` into `dot_agents/skills/`: `design-taste-frontend`, `redesign-existing-projects`, `high-end-visual-design`, `full-output-enforcement`, and `minimalist-ui`.
- Preserved each upstream `SKILL.md` body, then added a repo-native `agents/openai.yaml` manifest and a sibling `SOURCE.md` provenance file that records the upstream repo, commit, original path, import date, and permission basis.
- Updated `README.md` skill descriptions to mention the new frontend design capability cluster and to point readers at the explicit `SOURCE.md` provenance notes for the imported skills.
- Added lessons clarifying that explicit permission is not the same thing as ownership and that imported external content should carry explicit on-disk provenance.
- Preserved the existing in-progress `README.md`, `LICENSE`, and `plans/add-attribution-license.md` changes while layering this import on top.
