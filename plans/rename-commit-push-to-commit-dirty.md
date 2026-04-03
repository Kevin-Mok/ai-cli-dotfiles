# ExecPlan: Rename `commit-push` Skill To `commit dirty`

## Checklist

- [x] Inspect the existing `commit-push` skill files and the active discovery references.
- [x] Rename the skill folder and metadata from `commit-push` to `commit-dirty`.
- [x] Update the local skill index so discovery text uses `commit-dirty` / `commit dirty`.
- [x] Validate the renamed skill and review the final diff.

## Assumptions

- The requested visible rename is from the current explicit commit-and-push skill to a new canonical skill name of `commit dirty`.
- The on-disk slug should remain hyphenated as `commit-dirty` to match the repo's existing skill naming pattern.
- Historical plan documents can keep the old name because they describe prior work, not the current active skill surface.

## Review Notes

- Renamed the skill folder from `dot_agents/skills/commit-push/` to `dot_agents/skills/commit-dirty/`.
- Updated the skill frontmatter, title, and agent metadata so the canonical invocation is now `$commit-dirty`, with `commit dirty` called out explicitly in discovery text.
- Updated the live skill index in `dot_agents/skills/README.md` to point at `commit-dirty` and mention both `commit dirty` and `commit all dirty`.
- Verification completed with:
  - `git diff --find-renames -- dot_agents/skills/README.md dot_agents/skills/commit-push dot_agents/skills/commit-dirty plans/rename-commit-push-to-commit-dirty.md`
  - `git diff --check -- dot_agents/skills/README.md dot_agents/skills/commit-push dot_agents/skills/commit-dirty plans/rename-commit-push-to-commit-dirty.md`
  - `git status --short dot_agents/skills/README.md dot_agents/skills/commit-dirty dot_agents/skills/commit-push plans/rename-commit-push-to-commit-dirty.md`
- `python3 quick_validate.py ...` could not be used because `quick_validate.py` is not present in `/home/kevin/linux-config`.
