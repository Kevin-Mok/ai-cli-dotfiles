# ExecPlan: Add Skills Catalog README

## Checklist

- [x] Confirm which entries under `dot_agents/skills/` are actual skills with a `SKILL.md`.
- [x] Gather the current purpose and usage notes from each skill definition.
- [x] Add `dot_agents/skills/README.md` with a short intro and one paragraph per skill.
- [x] Keep the new catalog scoped to the skills directory and avoid editing the already-dirty repo root `README.md`.
- [x] Verify the section count, ordering, and diff scope for the new files.

## Assumptions

- The requested README is a human-readable catalog, not a full restatement of each skill's internal rules.
- Only directories that currently expose `SKILL.md` should be documented as live skills.
- The empty legacy `push-dirty/` directory should stay undocumented until it becomes a real skill again.

## Review Notes

- Confirmed that `dot_agents/skills/` currently contains 15 live skills with `SKILL.md` files plus one empty legacy `push-dirty/` directory.
- Added a new local catalog at `dot_agents/skills/README.md` with category headings, skill subheadings, and a single prose paragraph for each live skill.
- Reorganized the catalog into category headings with skill subheadings after the user asked for a less flat structure.
- Added direct links from each skill subheading to its local `SKILL.md` file after the user asked for source links.
- Grounded each paragraph in the skill front matter and opening workflow/overview text so the README explains usage without copying the full prompt body.
- Kept the change isolated to the new skills README and this ExecPlan, leaving the already-dirty root `README.md` untouched.
- Verification completed with:
  - `find dot_agents/skills -mindepth 2 -maxdepth 2 -name SKILL.md | wc -l` -> `15`
  - `rg -n '^(##|###) ' dot_agents/skills/README.md` -> 5 category headings plus 15 skill subheadings
  - `rg -o '\\]\\([^)]+/SKILL\\.md\\)' dot_agents/skills/README.md | wc -l` -> `15`
  - `sed -n '1,260p' dot_agents/skills/README.md` -> confirmed one paragraph per skill section
  - `git status --short -- README.md dot_agents/skills/README.md plans/skills-readme-catalog.md plans/readme-license-link.md` plus `git diff --no-index -- /dev/null ...` -> confirmed only the two new files were added for this task
