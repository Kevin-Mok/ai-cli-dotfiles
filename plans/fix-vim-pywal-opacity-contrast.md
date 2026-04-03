# Fix Vim Pywal Opacity Contrast Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Keep Vim and Neovim `pywal` syntax accents vibrant while preventing low-contrast colors from washing out against Kitty's translucent background.

**Architecture:** Extend the repo-owned `wal` highlight override block in `dot_vimrc.tmpl` with opacity-aware accent selection helpers. Compute readability against the effective terminal background, re-rank the existing `wal` accents, and keep three distinct highlight lanes for function-like, keyword-like, and special/preproc groups. Lock the behavior with targeted Vim regression tests.

**Tech Stack:** Vimscript, shell regression tests, headless Neovim verification

---

### Task 1: Add Opacity-Aware Wal Accent Selection

**Files:**
- Modify: `dot_vimrc.tmpl`
- Modify: `tests/test_vim_pywal_background.sh`
- Modify: `tests/test_vim_wal_live_refresh.sh`
- Modify: `tests/test_apply_pywal_theme.sh`
- Create: `plans/fix-vim-pywal-opacity-contrast.md`

- [x] **Step 1: Tighten regression coverage before implementation**

Update the Vim wal tests so they expect repo-owned helper functions for contrast scoring, effective background blending, and accent lane selection. Reproduce the current failure by asserting that a weak accent should be replaced under a translucent background.

- [x] **Step 2: Implement readable accent helpers in the Vim wal path**

Add minimal Vimscript helpers to parse hex colors, compute luminance/contrast, blend the effective background using the tracked Kitty opacity, rank `wal` accents, and choose three distinct highlight lanes.

- [x] **Step 3: Rewire wal highlight groups to the selected accent lanes**

Keep existing background overrides and fallback behavior, but route function/identifier, keyword/operator/statement, and special/preproc groups through the new readable accent mapping.

- [x] **Step 4: Reconcile adjacent regression expectations**

Align any stale test assumptions that conflict with the tracked terminal opacity so verification reflects the current repo configuration.

- [x] **Step 5: Run targeted verification and review the diff**

### Results

- Added an opacity-aware accent ranking path in `dot_vimrc.tmpl` that blends the wal background toward white using the tracked Kitty opacity, then ranks distinct wal accents by contrast and color spread.
- Kept three highlight lanes for function-like, keyword-like, and special/preproc groups, while leaving the rest of the wal fallback path unchanged.
- Updated the Vim regression tests to assert the helper block exists and that a weak blue accent gets replaced by stronger readable accents during live refresh.
- Reconciled the stale `background_opacity` assertion in `tests/test_apply_pywal_theme.sh` with the tracked Kitty config.

Run the focused shell tests for Vim wal behavior and the pywal wrapper assertions, then inspect the diff to confirm the change stays scoped to the planned files.

### Review

- Assumption: the reported readability problem is the `wal`-driven editor highlight mapping visible in the screenshot, not Fish shell syntax colors.
- Risk: aggressive accent re-ranking could collapse too many groups onto the same hue, so the selector should preserve three distinct lanes whenever the palette offers enough readable candidates.
- Verification:
  - `bash tests/test_vim_pywal_background.sh`
  - `bash tests/test_vim_wal_live_refresh.sh`
  - `bash tests/test_apply_pywal_theme.sh`
  - `git diff -- dot_vimrc.tmpl tests/test_vim_pywal_background.sh tests/test_vim_wal_live_refresh.sh tests/test_apply_pywal_theme.sh plans/fix-vim-pywal-opacity-contrast.md`
