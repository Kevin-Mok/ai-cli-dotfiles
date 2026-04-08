# Fix Vim Indent Scroll

## Goal

Make mouse wheel scrolling in Vim and Neovim jump to the next or previous
nonblank line whose indentation is the same as or lower than the current
structural line, instead of relying on blank-line paragraph boundaries.

## Plan

- [x] Add a regression test that reproduces the current failure on indented
      Python code.
- [x] Update the wheel-scroll helper functions in `dot_vimrc.tmpl` to use
      same-or-lower-indent navigation.
- [x] Run the targeted Vim regression tests and record the result.

## Review

- Added `tests/test_vim_indent_scroll.sh` to verify scroll-down from the
  assignment lands on the closing `)` line, scroll-up from the `if`
  statement returns to that same indentation boundary, and scroll-down
  from a colon-terminated block header enters the first indented line.
- Updated the wheel-scroll helpers in `dot_vimrc.tmpl` to scan for the next
  or previous nonblank line whose indentation is less than or equal to the
  current structural indent, while allowing `async def` or other block
  headers to scroll into their child block on downward motion.
- Updated `docs/smoke-tests.md` with a Vim or Neovim manual check for
  Python indentation-boundary wheel scrolling.
- Verified with `bash tests/test_vim_indent_scroll.sh` and
  `bash tests/test_vim_mousescroll_guard.sh`, then applied only
  `/home/kevin/.vimrc` and `/home/kevin/.config/nvim/init.vim` via
  `chezmoi` and confirmed live Neovim reports `header:2` and
  `assignment:5` on the regression sample.
