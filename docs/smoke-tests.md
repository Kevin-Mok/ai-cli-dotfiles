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

## Fish Helpers

- Action: Run `fish -ic 'refresh-config'` after changing tracked repo configuration on a machine where `chezmoi` and the shell helper scripts are available.
  Expected: The tracked `dot_codex/config.toml` overwrites `~/.codex/config.toml`, `chezmoi apply` runs, shortcuts regenerate, and fish reloads without leaving the live Codex config as the source of truth.
- Action: Run `fish -c 'backup-phone-storage'` from a machine that can
  reach the phone over SSH on port `8022`.
  Expected: If Termux has `rsync` installed, `rsync` copies the shared
  storage tree from `$PHONE_IP:/data/data/com.termux/files/home/storage/`
  into `/mnt/linux-files-3/pixel-9`, following Termux storage symlinks
  such as `dcim -> /storage/emulated/0/DCIM`, while showing transfer
  progress, ETA, the current path, and rsync `xfr#/to-chk` counters;
  otherwise the helper exits early with an install hint instead of
  failing mid-transfer.

## Codex And Graphiti

- Action: Launch `codex` from a shell where `~/scripts` shadows the real Codex binary and Graphiti is installed at `/home/kevin/coding/graphiti/mcp_server`.
  Expected: The wrapper creates or reuses `${XDG_STATE_HOME:-$HOME/.local/state}/codex-launch/graphiti.pid`, appends Graphiti startup output to `graphiti.log`, and then hands off to the real Codex CLI with the original arguments intact.

## Vim

- Action: Open a Markdown file in Vim, press `<F8>`, and edit headings, lists, tables, and fenced code blocks while the preview is open.
  Expected: `markdown-preview.nvim` opens a live browser preview on a free localhost port with GitHub-like dark styling and updates as the file changes.
- Action: With the Markdown preview already open in Vim, press `<F9>`.
  Expected: The preview stops and restarts cleanly on the same file without falling back to the old `InstantMarkdownPreview` commands.

## Remote Access

- Action: Run `sudo ./scripts/executable_setup-mosh.sh` on a Linux host
  meant to accept remote `mosh` sessions.
  Expected: The script installs `mosh` when missing, opens
  `60000:61000/udp` in `ufw` or `firewalld` when one is active, and
  prints whether SSH server bootstrap still needs attention before
  remote clients can connect.
