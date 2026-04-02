# ExecPlan: Split ChatGPT Dictation Script

## Assumptions

1. The user wants the existing `chatgpt-dictation` helper preserved instead of being repurposed for the newer two-press workflow.
2. The newer Menu-key ready/cut flow should move to a separate sibling script and the i3 binding should target that new script.
3. The original and new helpers should keep independent runtime state so either script can evolve without corrupting the other one's mode files.

## Plan

- [x] Restore the original `scripts/executable_chatgpt-dictation` behavior and add regression coverage for it.
- [x] Add a new sequenced helper script for the two-press ready/cut flow and point the Menu binding plus its tests at the new path.
- [x] Update the relevant docs/logs for the correction and run the targeted shell tests.

## Review

- Restored `chatgpt-dictation` to the original click and copy workflow.
- Added `chatgpt-dictation-sequenced` for the newer two-press ready/cut flow and moved the Menu binding to that script.
- Added regression coverage for both helpers and recorded the user correction in lessons and feedback memory.
