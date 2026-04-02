# Fix Vim Pywal Colorscheme Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Make Vim use the `pywal`-generated theme instead of a hardcoded colorscheme so the editor matches the terminal palette.

**Architecture:** Keep the change inside `dot_vimrc.tmpl`, where the colorscheme is currently selected. Verify behavior by rendering the template and asserting that the rendered config selects `wal` rather than a fixed fallback theme.

**Tech Stack:** Vimscript, chezmoi template rendering, shell verification

---

### Task 1: Reproduce And Fix The Colorscheme Selection

**Files:**
- Modify: `dot_vimrc.tmpl`
- Create: `plans/fix-vim-pywal-colorscheme.md`

- [x] **Step 1: Identify the root cause in the Vim template**

Evidence: `dot_vimrc.tmpl` installs `dylanaraps/wal.vim` but later selects `nightfly` for GUI Vim and `gotham256` otherwise, which overrides the `wal` theme.

- [x] **Step 2: Add a reproducible check against the rendered template**

Run: `chezmoi execute-template < dot_vimrc.tmpl | sed -n '355,365p'`
Expected before fix: the rendered output contains `colorscheme nightfly` or `colorscheme gotham256`, proving the template does not currently follow `pywal`.

- [x] **Step 3: Update the template to select the `wal` colorscheme**

Set the active colorscheme in `dot_vimrc.tmpl` to `wal` for the rendered Vim config, removing the hardcoded mismatch.

- [x] **Step 4: Re-run the rendered-template check**

Run: `chezmoi execute-template < dot_vimrc.tmpl | sed -n '355,365p'`
Expected after fix: the rendered output contains `colorscheme wal` and no active hardcoded fallback colorscheme in that block.

- [x] **Step 5: Run a targeted diff review**

Run: `git diff -- dot_vimrc.tmpl plans/fix-vim-pywal-colorscheme.md`
Expected: only the plan and the colorscheme-selection lines change.

### Review

- Assumption: the desired behavior is to make both Vim and Neovim follow the `pywal` palette by default.
- Risk: if `wal.vim` is missing on a target machine, Vim will fail to apply the theme until plugins are installed. That risk already exists because the plugin is declared in the config.
- Verification:
  - `chezmoi execute-template < dot_vimrc.tmpl | sed -n '355,365p'`
  - `git diff -- dot_vimrc.tmpl docs/smoke-tests.md plans/fix-vim-pywal-colorscheme.md`
