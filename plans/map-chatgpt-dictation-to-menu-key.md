# ExecPlan: Map ChatGPT Dictation To Menu Key

## Assumptions

1. The user wants the existing i3 ChatGPT dictation shortcut on the Menu/right app key instead of the current `F13` binding.
2. The `xev` output showing `keysym 0xff67, Menu` is the correct stable identifier for this key in i3.
3. The existing dictation script behavior should remain unchanged; only the trigger key and its regression coverage need updates.

## Plan

- [x] Add a regression test that asserts the i3 config binds ChatGPT dictation to `Menu`.
- [x] Update the i3 config template to use `Menu` and refresh the nearby comment.
- [x] Run the relevant tests to verify the binding and existing dictation behavior.

## Review

- Updated the i3 ChatGPT dictation binding from `F13` to `Menu` and refreshed the inline comment to match the new physical key target.
- Added a targeted regression test for the i3 binding and kept the existing dictation script test green.
- Verification:
  - `bash tests/test_i3_chatgpt_dictation_binding.sh`
  - `bash tests/test_chatgpt_dictation.sh`
