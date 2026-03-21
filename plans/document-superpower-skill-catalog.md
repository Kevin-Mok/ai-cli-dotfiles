# ExecPlan: Document Superpower Skill In Catalog

## Goal

Update `dot_agents/skills/README.md` so it documents the installed
upstream `obra/superpowers` skills in their own dedicated section, while
still making it clear that the bundle is externally managed rather than
repo-tracked under `dot_agents/skills/`.

## Assumptions

- The user wants the local skills catalog to describe each installed
  upstream superpower, not just the `using-superpowers` entry-point
  skill.
- The local skill catalog should stay primarily focused on repo-tracked
  `dot_agents/skills/*/SKILL.md` entries, with one dedicated external
  section for the mounted upstream bundle.
- A GitHub link to each upstream `SKILL.md` is a better README target
  than machine-local absolute paths that would not work in the repo UI.

## Checklist

- [x] Inspect the current catalog language around the externally mounted
      superpowers bundle.
- [x] Confirm the installed upstream skill inventory and read the
      current skill metadata.
- [x] Update `dot_agents/skills/README.md` with a truthful external
      section that describes each installed superpower.
- [x] Verify the resulting diff and section structure.

## Review Notes

- The previous catalog only mentioned the external bundle in passing and
  documented `using-superpowers` alone, which did not satisfy a request
  to explain what each superpower does.
- The revised README now has a dedicated external superpowers section
  that enumerates all 14 installed upstream skills with concise
  descriptions grounded in their front matter and overview text.
- After a follow-up request, the top-level skill sections were reordered
  from most frontend or full-stack web engineering relevant to least, so
  readers hit UI and web-delivery skills before broader workflow or
  media-oriented sections.
- The intro still distinguishes repo-tracked local skills from the
  chezmoi-managed `~/.codex/superpowers` checkout so the catalog does
  not blur ownership or maintenance boundaries.
- Root `README.md` remained accurate after this docs-only catalog tweak,
  so no root README edit was required for this task.
