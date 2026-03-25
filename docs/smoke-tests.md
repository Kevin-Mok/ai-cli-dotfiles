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

## Fish Helpers

- Action: Run `fish -c 'backup-phone-storage'` from a machine that can
  reach the phone over SSH on port `8022`.
  Expected: If Termux has `rsync` installed, `rsync` copies the shared
  storage tree from `$PHONE_IP:/data/data/com.termux/files/home/storage/`
  into `/mnt/linux-files-3/pixel-9`, following Termux storage symlinks
  such as `dcim -> /storage/emulated/0/DCIM`, while showing transfer
  progress, ETA, the current path, and rsync `xfr#/to-chk` counters;
  otherwise the helper exits early with an install hint instead of
  failing mid-transfer.
