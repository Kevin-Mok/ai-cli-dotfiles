# ExecPlan: Relax Commit-Session Baseline Guard For Observed Touches

## Goal

Allow `commit-session` to include files that were dirty at the initial
session baseline when the current Codex session later touched those
files directly.

## Checklist

- [x] Add a failing regression for a baseline-dirty tracked file that is
      directly touched later in the same session.
- [x] Keep coverage for untouched baseline-dirty files remaining
      skipped.
- [x] Update the session scope classifier so direct session touches win
      over the initial baseline classification.
- [x] Refresh `commit-session` docs plus the skill catalog and root
      README so the behavior description matches the implementation.
- [x] Run targeted tests and a manual session-log regression check.

## Verification

- `python3 -m unittest dot_agents.skills.commit-session.tests.test_session_scope`
- `python3 - <<'PY' ... analyze_session(..., '019d10f2-c382-7fd0-b809-f0275cc8bda7') ... PY`
- `git diff --check`

## Assumptions

- Direct file attribution from the session log is strong enough to
  treat a baseline-dirty file as current-session-owned.
- Generic repo writes without file attribution should remain
  insufficient to reclaim a baseline-dirty file.
