# Fix Vim Command-Line Window `checktime`

- [x] Add a focused regression check that captures the `CursorHold` guard around `checktime`.
- [x] Update the shared Vim config so `checktime` does not run inside the command-line window opened with `q:`.
- [x] Record the manual smoke check and run the relevant shell tests.

## Review

- Replaced the old `[Command Line]` buffer-name guard with `getcmdwintype() == ''`, which directly detects whether Vim is inside the command-line window opened by `q:`.
- Added a focused shell regression test for the `CursorHold` `checktime` guard and a matching smoke-test entry for manual verification.
- Verification:
  - `bash tests/test_vim_cmdwin_checktime.sh`
  - `bash tests/test_vim_cursorhold_updatetime.sh`
