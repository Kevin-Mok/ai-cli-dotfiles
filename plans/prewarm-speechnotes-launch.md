# ExecPlan: Prewarm Speechnotes Launch

## Assumptions

1. The Speechnotes helper should optimize for the fastest possible recall time after login, not the lightest idle footprint.
2. A dedicated lightweight Chrome profile for Speechnotes is acceptable, including a one-time microphone permission prompt in that profile.
3. i3 scratchpad is the preferred parking mechanism so the window stays hidden off-workspace until recalled.

## Plan

- [x] Add failing coverage for prewarm startup, dedicated profile flags, and scratchpad show or hide behavior.
- [x] Refactor the Speechnotes helper into a `--prewarm` startup mode plus a default scratchpad toggle mode.
- [x] Add the i3 startup hook, update the Menu binding verification, and refresh the manual smoke text.

## Review

- The Speechnotes helper now supports a dedicated profile, startup prewarm, and scratchpad-based show or hide behavior.
- i3 startup prewarms the hidden Speechnotes app window so Menu can recall it quickly.
- Regression coverage now checks the startup hook, Chrome launch flags, and scratchpad toggle flow.
