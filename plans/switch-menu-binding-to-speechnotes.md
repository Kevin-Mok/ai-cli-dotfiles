# ExecPlan: Switch Menu Binding To Speechnotes

## Assumptions

1. The Menu/right-app key should open a Speechnotes dictation helper instead of any ChatGPT helper.
2. The existing ChatGPT scripts should remain available and unchanged as separate entrypoints.
3. A small floating-window launcher for `https://speechnotes.co/dictate/` is sufficient for the Menu workflow unless the user later asks for extra automation on top of it.

## Plan

- [x] Add regression coverage for the Menu binding and the new Speechnotes helper path.
- [x] Create a Speechnotes helper script and repoint the i3 Menu binding plus smoke-test wording.
- [x] Run targeted shell tests and review the resulting diff.

## Review

- Added a new `speechnotes-dictation` helper that opens or reuses a floating Speechnotes browser window.
- Repointed the Menu binding to the new Speechnotes helper without touching the ChatGPT helpers.
- Updated the Menu binding regression coverage and manual smoke text to match the new target.
