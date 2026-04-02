# ExecPlan: Add ChatGPT Dictation Runtime Logging

## Assumptions

1. The user wants visibility into what the Menu-key dictation helper is trying to click and which mode path it takes.
2. The current helper behavior should remain unchanged; this task is instrumentation, not a workflow redesign.
3. Runtime logging under `$XDG_RUNTIME_DIR/chatgpt-dictation/` is acceptable for this script-level debugging.

## Plan

- [x] Add a failing test that expects runtime log entries for click targets and mode transitions.
- [x] Instrument the dictation helper with concise runtime logging around window discovery, clicks, and mode changes.
- [x] Run the dictation tests to confirm the new logs and preserve existing behavior.

## Review

- Added runtime logging to the ChatGPT dictation helper at `$XDG_RUNTIME_DIR/chatgpt-dictation/debug.log`.
- The log now records initial mode/window state, resolved window IDs, click targets, and copy-mode results without changing the helper flow.
- Verification:
  - `bash tests/test_chatgpt_dictation.sh`
  - `bash tests/test_i3_chatgpt_dictation_binding.sh`
