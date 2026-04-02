# Fix Vim Pywal Background Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Make Vim and Neovim keep the active `pywal` background color visible even when the terminal window itself is transparent.

**Architecture:** Leave `wal.vim` as the selected colorscheme in `dot_vimrc.tmpl`, then add a small repo-owned override block for the background-related highlight groups that `wal.vim` leaves transparent. Verify the behavior with a targeted shell regression test that inspects the tracked template.

**Tech Stack:** Vimscript, shell regression test

---

### Task 1: Reproduce And Fix Transparent Wal Backgrounds

**Files:**
- Modify: `dot_vimrc.tmpl`
- Create: `tests/test_vim_pywal_background.sh`
- Create: `plans/fix-vim-pywal-background.md`
- Modify: `docs/smoke-tests.md`

- [x] **Step 1: Confirm the root cause**

Evidence: `wal.vim` sets `Normal` and other editor groups with `ctermbg=NONE`, which makes the editor inherit terminal transparency instead of the current `pywal` background color.

- [x] **Step 2: Add a failing regression test**

Create a targeted shell test that asserts the shared Vim template contains a repo-owned `wal` override block setting opaque background colors for the main editor groups.

- [x] **Step 3: Patch the Vim template**

Keep `colorscheme wal` as-is and add a minimal helper that reapplies the `wal` background groups with `ctermbg=0` after the colorscheme loads.

- [x] **Step 4: Update smoke coverage**

Extend the existing manual Vim smoke check so it explicitly verifies that the editor background stays opaque and matches the active `pywal` palette in transparent terminals.

- [ ] **Step 5: Re-run targeted verification**

Run the new regression test and inspect the rendered config block to confirm the override is present next to the `wal` colorscheme selection.

### Review

- Assumption: the reported mismatch is the transparent-background behavior visible in the screenshot rather than a missing `wal` plugin install.
- Risk: overriding too many highlight groups could fight a later colorscheme switch, so the helper should be scoped to `wal` only and limited to the groups needed for an opaque editing surface.
- Verification:
  - `bash tests/test_vim_pywal_background.sh`
  - `chezmoi execute-template < dot_vimrc.tmpl | sed -n '345,385p'`
