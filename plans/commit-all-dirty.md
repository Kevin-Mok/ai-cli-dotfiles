# ExecPlan: Commit All Dirty Skill Alias

## Summary

Make `commit all dirty` an explicit trigger for the existing `commit-push`
skill instead of introducing a separate overlapping git skill. Keep the
current verification, README gate, and push-by-default behavior unchanged.

## Checklist

- [x] Confirm the current git skill split and existing trigger surface.
- [x] Verify the baseline gap: `commit-push` did not explicitly mention
  `commit all dirty`.
- [x] Update `commit-push` to document `commit all dirty` as an all-dirty
  execution trigger.
- [x] Update the skills README so the three git skills remain clearly
  differentiated.
- [x] Replace the stale historical `commit-all-dirty` plan content with the
  current implementation plan.

## Implementation Changes

### Skill behavior

- Extend `dot_agents/skills/commit-push/SKILL.md` trigger language to include
  `commit all dirty`.
- Clarify that `commit all dirty` means "commit the full intended dirty
  worktree now" and does not relax the mixed-diff safety guardrail.

### Repo documentation

- Update `dot_agents/skills/README.md` so the Git Workflow section makes the
  split explicit:
  - `commit-plan` for planning all dirty changes
  - `commit-push` for committing the intended dirty worktree now
  - `commit-session` for current-session-only shipping

### Plan artifact

- Keep this plan file aligned with the current skill model so future readers do
  not mistake it for a pending standalone `commit-all-dirty` implementation.

## Verification

- Baseline evidence:
  - `commit-push` lacked an explicit `commit all dirty` trigger.
  - The skills README did not name that phrase as the all-dirty execution path.
- Post-change checks:
  - Search for `commit all dirty` and confirm it appears in
    `dot_agents/skills/commit-push/SKILL.md`.
  - Read `commit-push`, `commit-session`, and the Git Workflow section of
    `dot_agents/skills/README.md` to confirm the boundary between all-dirty and
    session-only behavior is still unambiguous.

## Assumptions

- `commit all dirty` should remain an alias on `commit-push`, not a new skill.
- Successful execution of this workflow still pushes by default unless the user
  explicitly says not to.
