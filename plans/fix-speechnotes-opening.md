# ExecPlan: Fix Speechnotes Opening

## Assumptions

1. The Speechnotes launcher should not fail if a best-effort window placement command is unsupported by the current i3 setup.
2. Keeping the existing scratchpad toggle behavior is the priority; changing monitor-routing behavior is out of scope for this fix.
3. Focused shell-test coverage is sufficient for this bug because the failure is in a shell script command sequence.

## Plan

- [x] Add a failing regression that models the i3 command failure seen in the live environment.
- [x] Patch the launcher so the window still opens and focuses when that command path would otherwise abort.
- [x] Re-run the focused tests and validate one live launcher invocation.

## Review

- Root cause was an invalid `i3-msg` command in `normalize_window()`: `move window to output current` returned `ERROR: No output matched` in the live environment and aborted the launcher under `set -e`.
- The fix removes that non-essential placement step while preserving resize, centering, and focus behavior.
- Verification included the focused Speechnotes shell tests, the i3 binding test, a `chezmoi apply` of the managed launcher, and a traced live invocation of `/home/kevin/scripts/speechnotes-dictation`.
- Follow-up root cause for split-screen placement: i3 `move position center` centered the floating window against the full X root (`3968px` wide), which put the Speechnotes window across the monitor seam.
- The centering logic now reads the focused workspace output and computes an explicit `move position <x> px <y> px` inside that output, with fallback to i3's center behavior if output metadata is unavailable.
- Updated regression coverage models a dual-monitor layout and asserts placement at the focused output center.
