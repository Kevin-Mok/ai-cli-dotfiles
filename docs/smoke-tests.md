# Smoke Tests

Shared manual smoke checklist for `/home/kevin/linux-config`.

Update this file whenever work reveals a concrete manual verification
step or an obvious gap in smoke coverage. Keep entries grouped by area,
write them as `Action` plus `Expected`, and update stale entries instead
of stacking duplicates.

## Skills And Docs

- Action: Add or change a repo-tracked skill under `dot_agents/skills/`.
  Expected: The skill definition, `dot_agents/skills/README.md`, and the
  root `README.md` stay aligned with the new workflow the skill adds or
  changes.
- Action: Finish a task that introduced a reusable manual verification
  step or exposed a missing smoke check.
  Expected: This document gains or updates a grouped `Action` +
  `Expected` entry instead of leaving the check only in chat, plans, or
  final notes.

## Installed Skill Surface

- Action: Apply a tracked skill change to the live `~/.agents/skills/`
  install.
  Expected: The installed skill copy matches the repo-tracked source so
  future sessions see the same instructions and metadata.

## Repo Instructions

- Action: Add or change a standing workflow rule in `dot_codex/AGENTS.md`.
  Expected: The corresponding public docs and reusable verification
  guidance stay in sync with that rule in the same change.

## Keyboard And Input

- Action: Start a fresh X session on a desktop host that applies this repo's shell and `Xmodmap` config, open a terminal, type a short word, and press Backspace once.
  Expected: Exactly one character is deleted and opening a new bash shell does not rewrite the active keyboard remap.
- Action: Open Neovim with the tracked config, enter the command-line window with `q:`, wait long enough for `CursorHold`, then exit back to the file.
  Expected: Neovim does not raise `E11` for `checktime` while the command-line window is open.
- Action: Remap `Keychron Q11` `M2` to `Print`, start a fresh i3 session on a desktop host with the external keyboard config enabled, press `Print`, drag a screenshot region, and paste into an image-capable app.
  Expected: `scrot` captures the selected region, saves it under `~/Pictures/screenshots/desktop/unsorted/`, and the pasted clipboard contents match the captured image.
- Action: Start a fresh i3 session on a multi-monitor setup, press `Menu` on the monitor you are actively using, and grant microphone permission or install Dark Reader in the dedicated Speechnotes browser profile if needed. Press `Menu` again while the Speechnotes window is focused.
  Expected: i3 startup prewarms a hidden Speechnotes app window, the first `Menu` press recalls it nearly instantly on the current monitor in a centered `980x520` floating window instead of between displays, extensions remain installable in the dedicated profile, and a second `Menu` press while it is focused hides it back to scratchpad instead of opening another browser window.

## Fish Helpers

- Action: Run `fish -ic 'refresh-config'` after changing tracked repo configuration on a machine where `chezmoi` and the shell helper scripts are available.
  Expected: The live `~/.codex/config.toml` overwrites tracked `dot_codex/config.toml`, `chezmoi apply` runs, shortcuts regenerate, and fish reloads with the refreshed repo copy now matching the live Codex config.
- Action: Run `fish -c 'backup-phone-storage'` from a machine that can
  reach the phone over SSH on port `8022`.
  Expected: If Termux has `rsync` installed, `rsync` copies the shared
  storage tree from `$PHONE_IP:/data/data/com.termux/files/home/storage/`
  into `/mnt/linux-files-3/pixel-9`, following Termux storage symlinks
  such as `dcim -> /storage/emulated/0/DCIM`, while showing transfer
  progress, ETA, the current path, and rsync `xfr#/to-chk` counters;
  otherwise the helper exits early with an install hint instead of
  failing mid-transfer.

## Claude Code

- Action: Run `chezmoi apply` (or `refresh-config`) on a machine with this repo applied, then check `~/.claude/CLAUDE.md`.
  Expected: `~/.claude/CLAUDE.md` exists and contains a single `@/home/kevin/linux-config/dot_codex/AGENTS.md` import line, confirming Claude Code will load the shared instruction document globally.
- Action: After `chezmoi apply`, check `~/.claude/skills/` for skill symlinks.
  Expected: `~/.claude/skills/` exists and contains one `.md` symlink per skill directory found under `~/.agents/skills/` (e.g. `~/.claude/skills/commit-dirty.md -> ~/.agents/skills/commit-dirty/SKILL.md`). No symlinks are created for `README.md` or the `superpowers` entry because those have no top-level `SKILL.md`.
- Action: Launch Claude Code in any project directory and run `/commit-dirty` (or another tracked skill).
  Expected: Claude Code resolves the skill from `~/.claude/skills/commit-dirty.md` and follows the workflow defined in the shared `dot_agents/skills/commit-dirty/SKILL.md` source.
- Action: After applying this repo, launch Codex and verify `/commit-dirty` still works.
  Expected: `~/.agents/skills/commit-dirty/SKILL.md` is unchanged and Codex resolves the skill normally — the Claude skill wiring adds symlinks only and does not touch the Codex skill surface.

## Codex And Graphiti

- Action: Launch `codex` from a shell where `~/scripts` shadows the real Codex binary and Graphiti is installed at `/home/kevin/coding/graphiti/mcp_server`.
  Expected: The wrapper creates or reuses `${XDG_STATE_HOME:-$HOME/.local/state}/codex-launch/graphiti.pid`, appends Graphiti startup output to `graphiti.log`, and then hands off to the real Codex CLI with the original arguments intact.

## Vim

- Action: Open Vim in a terminal on a host using this repo's rendered `~/.vimrc`, then quit immediately with `:q`.
  Expected: Vim paints the normal editor screen right away and returns to the shell without stopping at a `Press ENTER` prompt for an unsupported option such as `mousescroll`.
- Action: Open Vim in a terminal with the rendered config, wait idle for at least one second on an empty buffer, enter insert mode, type a few characters, then quit with `:q!`.
  Expected: Vim remains responsive after idling, accepts normal keyboard input immediately, and exits without feeling stuck in a redraw or autosave loop.
- Action: Open Vim or Neovim in a terminal after running `wal -i <wallpaper>` and compare the editor background and accent colors against the active terminal palette.
  Expected: Vim loads the `wal` colorscheme by default so the editor palette tracks the current `pywal` theme, the main editing surface, line-number column, fold column, sign column, and end-of-buffer area stay opaque with the current `pywal` background color, and Python syntax looks intentionally color-separated instead of collapsing into a nearly monochrome editor.
- Action: Keep terminal Vim or Neovim open on a Python file, run `/home/kevin/scripts/apply-pywal-theme <wallpaper>` from another shell, then idle briefly in the editor or refocus the window.
  Expected: The running editor picks up the new `pywal` colors without reopening, including both the background surfaces and the stronger syntax colors.
- Action: Open Neovim in a Python project with a local `.venv` or `venv`, type `Path(` and `requests.`, and use the normal leader shortcuts on a Python symbol.
  Expected: Blink completion offers Python members and auto-import suggestions, `Up` and `Down` move between suggestions, signature help appears when typing a function call, and `<leader>do`, `<leader>g`, `<leader>rn`, and `<leader>fi` drive the Neovim LSP actions instead of the old YCM commands.
- Action: Open a Markdown file in Vim, press `<F8>`, and edit headings, lists, tables, and fenced code blocks while the preview is open.
  Expected: `markdown-preview.nvim` opens a live browser preview on a free localhost port with GitHub-like dark styling and updates as the file changes.
- Action: With the Markdown preview already open in Vim, press `<F9>`.
  Expected: The preview stops and restarts cleanly on the same file without falling back to the old `InstantMarkdownPreview` commands.

## Terminal

- Action: Launch the primary terminal from an i3 binding that uses this repo's rendered config, then trigger the Codex launcher shortcut.
  Expected: The normal terminal windows open in `kitty`, and the Codex shortcut also launches inside `kitty` instead of a separate terminal path with different UI chrome.
- Action: Keep one or more `kitty` windows open, run `/home/kevin/scripts/apply-pywal-theme <wallpaper>` or trigger one of the wallpaper-changing shortcuts, and then open one additional `kitty` window.
  Expected: The already-open `kitty` windows refresh to the new vivid `pywal` palette without a manual restart, the newly opened `kitty` window uses the same updated colors, and the terminal keeps the repo-configured light translucency without falling back to the earlier heavy wallpaper bleed-through.
- Action: Run `/home/kevin/scripts/apply-pywal-theme <wallpaper>` with a bright or high-saturation wallpaper, then inspect the i3 workspace bar and focused window chrome.
  Expected: The bar and focused workspace/client colors still feel vivid, but text and icons remain clearly readable against the workspace backgrounds instead of landing on low-contrast combinations such as pale icons over bright yellow backgrounds.
- Action: Open a terminal, run `./scripts/executable_setup-st.sh --skip-install`, and inspect both `~/.config/st/config.def.h` and your `st` source checkout `config.def.h`.
  Expected: The script renders the tracked template into both config locations, preserving the repo's pywal, font, copy/paste, and scrollback settings while printing the exact `sudo make -C <st-source-dir> install` command for the final compile step.
- Action: Open `st`, run enough output to exceed one screen, then scroll upward with the mouse wheel and `Shift+PageUp`.
  Expected: `st` keeps a deep local scrollback buffer so you can continue moving upward through old output instead of stopping after one screen.
- Action: While still scrolled up in `st`, drag-select older output, press `Ctrl+Shift+C`, then paste it elsewhere with `Ctrl+Shift+V`.
  Expected: The copied text comes from the scrolled-back output, and the copy/paste shortcuts match the normal terminal habit without forcing tmux copy mode for basic selection.

## Remote Access

- Action: Run `sudo ./scripts/executable_setup-mosh.sh` on a Linux host
  meant to accept remote `mosh` sessions.
  Expected: The script installs `mosh` when missing, opens
  `60000:61000/udp` in `ufw` or `firewalld` when one is active, and
  prints whether SSH server bootstrap still needs attention before
  remote clients can connect.
- Action: Run `sudo ./scripts/executable_update-chrome.sh` on a Debian or Ubuntu host with the Google Chrome apt repo configured.
  Expected: The script prints the installed and candidate Chrome versions, refreshes apt metadata, upgrades `google-chrome-stable` when needed, and ends with matching installed and candidate versions.
