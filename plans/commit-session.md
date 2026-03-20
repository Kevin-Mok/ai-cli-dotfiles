# ExecPlan: Relax `commit-session` Scoping

## Checklist

- [x] Reproduce the over-conservative classification with an executable synthetic session.
- [x] Update the helper to treat files dirtied after the session baseline as committable by default.
- [x] Preserve the pre-existing dirty boundary and add ownership provenance to the helper output.
- [x] Update the skill docs, README surface, and agent metadata to match the new scoping model.
- [x] Validate the helper with regression tests and a rerun of the synthetic scenario.

## Assumptions

- The user wants `commit-session` to keep excluding files that were already dirty at the pre-write baseline.
- Files that were clean at baseline and are dirty now should be considered session-owned by default, even without direct per-file write attribution.
- The helper should still fail closed when it cannot find a pre-write `git status --short` baseline.

## Review Notes

- Updated `dot_agents/skills/commit-session/scripts/session_scope.py` so any file that was clean at the session baseline and is dirty now becomes `commitable`, with `ownership_reason` distinguishing `observed_touch` from `newly_dirty_since_baseline`.
- Replaced the narrow write-command detector with a read-only command allowlist, so successful in-repo commands that might have dirtied files count as plausible write events instead of forcing `unsafe`.
- Preserved the pre-existing dirty boundary, including prefix matching for untracked baseline directories that later expand into individual files.
- Added `dot_agents/skills/commit-session/tests/test_session_scope.py` with synthetic repo and session-log coverage for direct edits, indirect dirties, generated companions, pre-existing dirty files, untracked-dir prefixes, and missing baselines.
- Updated the `commit-session` skill docs, skill catalog, root README, and agent metadata to describe baseline-delta scoping instead of direct-attribution-only scoping.
- Validation completed with `python3 -m unittest discover -s dot_agents/skills/commit-session/tests -p 'test_*.py'`.
- Validation completed with a synthetic temp-repo repro of the original bug to confirm that the same scenario now classifies a newly dirty tracked file as `commitable`.
