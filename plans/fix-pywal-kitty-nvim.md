# Fix Pywal Kitty Nvim Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Make `pywal` theme changes reliably reach running `kitty` windows, keep `kitty` slightly translucent without compositor double-opacity, make terminal Vim/Neovim follow a more vivid `pywal` palette, and keep repo-owned i3 chrome readable with contrast-safe derived colors.

**Architecture:** Extend the repo-owned `pywal` wrapper so it runs `wal --saturate 0.8 -e`, generates repo-owned derived i3 UI colors from `~/.cache/wal/colors.json`, then reloads Xresources, `kitty`, and i3 in one controlled sequence. Keep `wal.vim` selected in `dot_vimrc.tmpl`, retain the repo-owned opaque background override, and rely on the stronger global ANSI palette rather than a separate editor theme. Keep `kitty` at `0.90` opacity in its own config while leaving the compositor opacity rule disabled so there is only one opacity source.

**Tech Stack:** Bash, Python, kitty config, i3 config, Vimscript, shell regression tests, Python unit tests

---

### Task 1: Reproduce And Fix Kitty Runtime Refresh, Vivid Pywal, And Contrast-Safe i3 Chrome

**Files:**
- Create: `scripts/executable_apply-pywal-theme`
- Create: `scripts/executable_generate-i3-pywal-colors`
- Create: `tests/test_apply_pywal_theme.sh`
- Create: `tests/scripts/test_executable_generate_i3_pywal_colors.py`
- Modify: `dot_config/kitty/kitty.conf`
- Modify: `dot_config/picom/picom.conf`
- Modify: `dot_config/i3/config.tmpl`
- Modify: `dot_xinitrc.tmpl`
- Modify: `scripts/executable_bg-chooser`
- Modify: `dot_config/ranger/rc.conf.tmpl`
- Modify: `aliases/key_aliases.tmpl`
- Modify: `dot_vimrc.tmpl`
- Modify: `tests/test_vim_pywal_background.sh`
- Modify: `docs/smoke-tests.md`
- Create: `plans/fix-pywal-kitty-nvim.md`

- [x] **Step 1: Add failing regression checks**

Create a shell regression for the shared `pywal` wrapper plus i3 resource wiring, and add a deterministic Python unit test for the derived i3 color generator.

- [x] **Step 2: Implement the vivid shared pywal wrapper**

Update the wrapper so it runs `wal --saturate 0.8 -e`, generates derived i3 colors, reloads Xresources, refreshes running `kitty` windows, and reloads i3 while remaining harmless when individual runtime hooks are unavailable.

- [x] **Step 3: Keep tracked theme entry points on the wrapper**

Replace the tracked raw `wal -i ...` invocations in the main startup and wallpaper-changing paths with the shared helper so the runtime refresh happens consistently.

- [x] **Step 4: Finalize kitty opacity and refresh behavior**

Keep the tracked kitty remote-control socket settings, set `background_opacity` to `0.90`, and keep the picom kitty opacity rule disabled so kitty translucency comes from one config only.

- [x] **Step 5: Preserve wal-driven Vim background coverage**

Keep `colorscheme wal`, preserve the current repo-owned opaque background override, and rely on the stronger global `pywal` ANSI palette instead of adding a separate Neovim syntax-remap layer.

- [x] **Step 6: Add contrast-safe i3 resource wiring and smoke coverage**

Replace the current raw/fallback i3 color path with derived `i3wm.ui.*` resources, then refresh smoke coverage so it checks vivid terminal theming plus readable i3 workspace chrome.

- [x] **Step 7: Re-run targeted verification**

Run the new wrapper regression, the new Python contrast test, the existing Vim regression, and rendered-config checks to confirm the repo wiring matches the intended behavior.

### Review

- Assumption: a stronger global `pywal` palette is enough for terminal Neovim, so the editor should stay on stock `wal.vim` semantics plus the existing opaque background helper.
- Risk: i3 bar colors currently rely on a broken `i3wm.color*` path, so the new derived-resource file must be loaded consistently by the wrapper before i3 reloads.
- Default: `kitty` should end at `0.90` opacity so the terminal keeps a light translucent feel without obscuring the editor content.
- Outcome: the repo-owned wrapper now runs `wal --saturate 0.8 -e`, generates `~/.cache/wal/colors-i3.Xresources`, reloads Xresources, refreshes running kitty windows, and reloads i3.
- Outcome: i3 now consumes derived `i3wm.ui.*` colors for focused, active, and inactive workspace states so bright palettes do not produce unreadable toolbar text or icons.
- Verification:
  - `bash tests/test_apply_pywal_theme.sh`
  - `python3 -m unittest tests/scripts/test_executable_generate_i3_pywal_colors.py`
  - `bash tests/test_vim_pywal_background.sh`
  - `bash -n scripts/executable_apply-pywal-theme`
  - `chezmoi execute-template < dot_config/i3/config.tmpl | sed -n '235,255p;593,646p'`
  - `chezmoi execute-template < dot_vimrc.tmpl | sed -n '345,390p'`
  - `sed -n '1,40p' dot_config/kitty/kitty.conf`
