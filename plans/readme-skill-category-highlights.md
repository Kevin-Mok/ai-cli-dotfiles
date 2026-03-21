# ExecPlan: README Skill Category Highlights

## Goal

Update the repo-local README guidance and the root `README.md` so the
README summarizes representative highlights from each local skill
category instead of enumerating the full live skill inventory.

## Assumptions

- The user's request targets the root `README.md`, not
  `dot_agents/skills/README.md`, because the latter is the detailed
  catalog and the former is the recruiter-facing summary surface.
- "Each category" refers to the category groupings already documented in
  `dot_agents/skills/README.md`.
- The root README should still explain why the skills matter, but it
  should link to the skills catalog for the exhaustive inventory.

## Checklist

- [x] Audit the current root `README.md` and identify the sections that
      enumerate individual skills instead of category-level highlights.
- [x] Update `AGENTS.repo.md` so the README sync rule explicitly prefers
      category highlights over full skill inventories in the root README.
- [x] Rewrite the root `README.md` skill-heavy sections to highlight
      representative skills from each category and link to the detailed
      catalog for the complete list.
- [x] Verify the updated docs with targeted reads, grep checks, and a
      diff review.

## Verification

- `sed -n '1,220p' AGENTS.repo.md`
- `sed -n '132,190p' README.md`
- `sed -n '292,360p' README.md`
- `sed -n '134,151p' dot_agents/skills/README.md`
- `rg -n 'category|highlights|full inventory|Git workflow|Frontend direction and generators|UX, quality, and system alignment|Targeted design passes|Docs, knowledge, and output control|Browser and desktop automation|Documents and media' AGENTS.repo.md README.md plans/readme-skill-category-highlights.md`
- `git diff -- AGENTS.repo.md README.md plans/readme-skill-category-highlights.md`

## Review Notes

- The root README previously drifted into a partial skill-by-skill
  catalog, which duplicated `dot_agents/skills/README.md` and made the
  recruiter-facing doc noisy.
- The updated guidance keeps the root README focused on category-level
  evidence while leaving the exhaustive skill list in the dedicated
  catalog.
- Verification now includes a direct read of the smallest skill
  categories so "representative highlights" does not accidentally become
  "every skill in the category."
