# ExecPlan: Resize Speechnotes Window

## Assumptions

1. The Speechnotes helper should size itself relative to the focused output rather than use a fixed pixel size.
2. The existing centered floating placement should remain unchanged.
3. Target dimensions should be rounded down to whole pixels for deterministic i3 commands.

## Plan

- [x] Update Speechnotes helper test coverage to expect proportional width and height on the focused output.
- [x] Change the Speechnotes helper to compute window size and centered position from the focused output dimensions.
- [x] Run the targeted Speechnotes regression test and review the diff.

## Review

- Replaced the original `1180x820` geometry with a fixed `980x520` centered floating window that matches the requested screenshot size.
- Kept the existing focused-output centering behavior so the fixed size still opens on the active monitor.
- Verified the behavior with `bash tests/test_speechnotes_dictation.sh`.
- Updated `docs/smoke-tests.md` so the shared manual check calls out the new fixed window size.
