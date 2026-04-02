# Fix Vim CursorHold Responsiveness Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Prevent interactive Vim from becoming unresponsive due to `CursorHold`-driven autosave and file checks running with `updatetime=0`.

**Architecture:** Keep the fix in `dot_vimrc.tmpl`, where `updatetime`, the `CursorHold` `checktime` autocmd, and `vim-auto-save` configuration already live. Add a shell regression test that enforces a nonzero `updatetime` while `CursorHold` remains part of the config.

**Tech Stack:** Vimscript, shell verification, chezmoi template rendering

---

### Task 1: Remove The Pathological CursorHold Timing

**Files:**
- Modify: `dot_vimrc.tmpl`
- Create: `tests/test_vim_cursorhold_updatetime.sh`
- Modify: `docs/smoke-tests.md`
- Create: `plans/fix-vim-cursorhold-responsiveness.md`

- [x] **Step 1: Identify the risky interaction**

Evidence: `dot_vimrc.tmpl` sets `updatetime=0` while also defining `autocmd CursorHold * ... checktime` and configuring `vim-auto-save` to run on `CursorHold`. That combination creates continuous idle-triggered work instead of a bounded delay.

- [x] **Step 2: Add a reproducible regression check**

Run: `bash tests/test_vim_cursorhold_updatetime.sh`
Expected before fix: the test fails because the template combines `CursorHold` with `set updatetime=0`.

- [x] **Step 3: Switch to a nonzero default**

Set `updatetime` to a bounded nonzero value so idle-triggered checks and autosaves still happen, but no longer fire in a tight loop.

- [x] **Step 4: Add smoke coverage for responsiveness**

Record a manual Vim responsiveness check so future edits verify that a plain idle Vim session still accepts input and exits immediately.

- [ ] **Step 5: Verify rendered and live config**

Run:
- `bash tests/test_vim_cursorhold_updatetime.sh`
- `chezmoi execute-template < dot_vimrc.tmpl | rg -n "set updatetime|CursorHold|auto_save_events"`
- `sed -n '34,50p' ~/.vimrc`

Expected after fix:
- the regression test passes,
- the rendered config shows a nonzero `updatetime`,
- the live `~/.vimrc` carries the same nonzero value.

### Review

- Assumption: keeping autosave and file-change checking on idle is still desired, but only at a sane polling interval.
- Risk: increasing `updatetime` slightly delays CursorHold-driven autosaves and external file refreshes. That is preferable to an editor that appears stuck.
- Verification:
  - `bash tests/test_vim_cursorhold_updatetime.sh`
  - `chezmoi execute-template < dot_vimrc.tmpl | rg -n "set updatetime|CursorHold|auto_save_events"`
  - manual Vim open, brief idle, insert text, and `:q!`
