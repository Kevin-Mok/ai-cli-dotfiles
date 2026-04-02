# ChatGPT Dictation Sequenced Keypress Design

## Goal

Make repeated presses of the Menu key advance a simple two-step ChatGPT text-capture workflow without relying on mic-button clicks.

## Current Behavior

- The i3 binding launches `/home/kevin/scripts/chatgpt-dictation`.
- The helper originally relied on stale click coordinates and an older voice-dictation flow.
- Refresh alone is not enough to clear stale draft text because ChatGPT can restore the composer after reload.

## Target Behavior

Use an explicit state machine with one action per keypress:

1. `idle` -> open or focus the floating ChatGPT window, refresh the page, clear the composer, and set state to `ready`
2. `ready` -> send `Ctrl+A`, wait briefly, send `Ctrl+X`, wait briefly, close the ChatGPT window, and set state back to `idle`

## State Model

States:

- `idle`: no active dictation session
- `ready`: ChatGPT window is open, refreshed, and the composer has been cleared

Rules:

- If the tracked window is missing, force the state back to `idle`.
- Each keypress advances exactly one step.
- On stale or unknown state, reset back to `ready` after ensuring the window exists.
- All transitions are logged to the runtime debug log.

## First Press Behavior

- Ensure the ChatGPT floating window exists and is focused.
- Send `Ctrl+R` to refresh the page.
- Send `Ctrl+A` and `BackSpace` to clear any restored draft text.
- Leave the window open in `ready`.

## Second Press Behavior

- Assume the user has already placed focus in the ChatGPT composer.
- Send `Ctrl+A`.
- Pause briefly so the selection is applied.
- Send `Ctrl+X`.
- Pause briefly so the cut operation completes.
- Close the ChatGPT window and reset to `idle`.

## Error Handling And Timing

- If the window cannot be found or launched, notify the user and remain in `idle`.
- Use small fixed delays between select, cut, and window close so the editor processes the keystrokes before the window is killed.
- Keep debug logging for state transitions and timing markers to support future calibration.

## Verification

Automated tests should cover:

- `idle` press opens/focuses the window, refreshes, clears the composer, and transitions to `ready`
- `ready` press selects, cuts, closes the window, and transitions to `idle`
- missing-window recovery resets stale state back to `idle`

Manual verification should confirm the two-press sequence works end-to-end with the actual ChatGPT UI.
