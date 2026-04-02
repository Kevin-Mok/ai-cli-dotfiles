# Fix Vim Startup Mousescroll Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Restore interactive Vim startup by preventing unsupported builds from setting `mousescroll`, which currently triggers an error prompt and leaves the terminal on a blank screen until input is provided.

**Architecture:** Keep the fix inside `dot_vimrc.tmpl` where the option is defined. Add a shell reproducer that checks the rendered template and validates that the `mousescroll` setting is feature-gated instead of unconditional.

**Tech Stack:** Vimscript, shell verification, chezmoi template rendering

---

### Task 1: Reproduce And Fix The Startup Error

**Files:**
- Modify: `dot_vimrc.tmpl`
- Create: `tests/test_vim_mousescroll_guard.sh`
- Modify: `docs/smoke-tests.md`
- Create: `plans/fix-vim-startup-mousescroll.md`

- [x] **Step 1: Identify the root cause in the live startup trace**

Evidence: `vim -V20/tmp/vim-startup.log -Nu ~/.vimrc -n -c 'qa!'` reports `E518: Unknown option: mousescroll=ver:5,hor:1` at line 21 of `~/.vimrc`, then waits for `Press ENTER`, which matches the blank-screen terminal freeze.

- [x] **Step 2: Add a reproducible regression check**

Run: `bash tests/test_vim_mousescroll_guard.sh`
Expected before fix: the test fails because the rendered template still contains an unconditional `set mousescroll=ver:5,hor:1`.

- [x] **Step 3: Guard the option in the Vim template**

Wrap the `mousescroll` setting in `if exists('+mousescroll')` so Neovim and newer Vim builds keep the option while unsupported Vim builds skip it cleanly.

- [x] **Step 4: Add manual smoke coverage**

Record an interactive startup check in `docs/smoke-tests.md` so future config changes verify that Vim opens normally instead of stopping at an option error prompt.

- [x] **Step 5: Re-run targeted verification**

Run:
- `bash tests/test_vim_mousescroll_guard.sh`
- `timeout 5s vim -Nu ~/.vimrc -n -es +qall; printf 'exit=%s\n' $?`
- `timeout 8s vim -V20/tmp/vim-startup.log -Nu ~/.vimrc -n -c 'qa!' >/tmp/vim-stdout.log 2>/tmp/vim-stderr.log; sed -n '1,40p' /tmp/vim-stderr.log`

Expected after fix:
- the rendered-template test passes,
- headless Vim exits `0`,
- the verbose startup trace no longer reports `E518` for `mousescroll`.

### Review

- Assumption: the user wants one config that works across both Neovim and distro-packaged Vim without dropping scrolling support where available.
- Risk: if another interactive-only startup issue exists, this fix will expose it after removing the blocking option error. The current evidence shows `mousescroll` is the first startup blocker.
- Verification:
  - `bash tests/test_vim_mousescroll_guard.sh`
  - `timeout 8s vim -i NONE -V20/tmp/vim-startup-live.log -Nu ~/.vimrc -n -c 'qa!' >/tmp/vim-live-stdout.log 2>/tmp/vim-live-stderr.log`
  - manual Vim open in a terminal from a session using the updated config
