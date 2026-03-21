# ExecPlan: Allow Commit-Session Fallback For Direct Touches Without Baseline

## Goal

Allow `commit-session` to ship a safe subset when the original Codex
session directly touched the shippable files but failed to capture a
successful pre-write `git status --short` baseline.

## Checklist

- [x] Add a failing regression for a missing-baseline session with
      directly touched files plus unrelated untouched dirties.
- [x] Update the scope helper to treat directly observed touched files as
      committable when no baseline exists, while leaving all other dirty
      files skipped.
- [x] Keep baseline-required behavior for indirect/generated files that
      lack direct attribution.
- [x] Refresh `commit-session` docs plus the skill catalog and root
      README so the fallback behavior is explicit.
- [x] Re-run targeted tests and the real `auction-bot` session repro.

## Assumptions

- Direct per-file attribution from `apply_patch` and known helper writes
  is strong enough to stage those files even without a baseline.
- Missing-baseline sessions should still skip untouched dirty files
  rather than failing the whole workflow when a safe observed-touch-only
  commit is possible.

## Verification

- `python3 -m unittest dot_agents.skills.commit-session.tests.test_session_scope -v`
- `python3 dot_agents/skills/commit-session/scripts/session_scope.py --repo-root /home/kevin/coding/auction-bot --session-id 019d1151-50c4-75f2-8a49-a068b36d40cf`
- `git diff --check -- dot_agents/skills/commit-session/scripts/session_scope.py dot_agents/skills/commit-session/tests/test_session_scope.py dot_agents/skills/commit-session/SKILL.md dot_agents/skills/README.md README.md tasks/lessons.md plans/commit-session-missing-baseline-direct-touches.md`

## Review Notes

- Missing-baseline sessions now return `ready` when the current dirty
  set contains directly observed touched files, while leaving every
  unattributed dirty file under `skipped_unknown` with
  `missing_baseline_unattributed`.
- The original `auction-bot` session
  `019d1151-50c4-75f2-8a49-a068b36d40cf` now classifies the intended
  feature files as `commitable` and leaves `tasks/lessons.md`,
  `cmds.md`, and `img-placeholder.jpg` out of scope.
