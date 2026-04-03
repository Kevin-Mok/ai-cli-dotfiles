# Fix Vim Autocomplete Arrow Navigation

- [x] Inspect the existing Blink completion keymaps and the tracked Neovim completion regression test.
- [x] Add regression expectations for `Up` and `Down` moving through completion suggestions.
- [x] Update the Blink keymap so arrow keys move the selection within the suggestion menu.
- [x] Verify with the targeted shell regression test and review the resulting diff for minimal scope.
