# Fix Ubuntu Start Graphiti Mount Plan

## Goal

Ensure `ubuntu-start` mounts `/dev/sdc1` at `/mnt/linux-files-3` before any
`wal` wallpaper/theme startup, and starts the Graphiti dependency that Codex
actually needs without tripping over the `graphiti-mcp` container's host port
`8000` bind. Keep the same startup path quiet and resilient when optional
desktop helpers are missing or already running.

## Assumptions

- `/mnt/linux-files-3` may be needed by wallpaper or Graphiti startup paths.
- Codex uses the local Graphiti stdio command, so the Docker compose startup
  only needs Neo4j reachable on `localhost:7687`.
- The upstream compose file's `graphiti-mcp` service should not start from
  `ubuntu-start` because it binds host port `8000`.
- `notification-daemon`, `numlockx`, and other desktop helpers are optional
  on this host; missing ones should not print shell errors during startup.
- `dunst` is the notification daemon configured by this repo and installed on
  this host, so `ubuntu-start` should prefer it over the old
  `notification-daemon` path.
- The repo-owned `apply-pywal-theme` wrapper is the correct wallpaper
  entrypoint because it also refreshes kitty and i3 color resources.
- It is acceptable for `ubuntu-start` to prompt for `sudo` when `/dev/sdc1`
  needs to be mounted.
- The active mouse map has 20 pointer buttons, so the Xmodmap pointer mapping
  should preserve buttons 13-20 to avoid a partial-map startup warning.

## Plan

- [x] Add a focused regression test for startup ordering and Neo4j-only compose.
- [x] Move the existing mount block before `wal`.
- [x] Change the compose startup to `up -d neo4j`.
- [x] Update manual smoke coverage for a fresh Ubuntu/i3 startup.
- [x] Run focused shell checks and record results.
- [x] Guard optional desktop helpers and avoid starting duplicate `picom`.
- [x] Route wallpaper startup through `apply-pywal-theme` with a validated
  shuffler result.
- [x] Remove the deprecated `picom` `refresh-rate` option.
- [x] Allow the Graphiti volume mount to prompt for `sudo` instead of
  silently skipping when the sudo credential is not already cached.
- [x] Prefer `dunst` for startup notifications when it is available.
- [x] Extend the X pointer mapping to include passthrough buttons 13-20.
- [x] Add a sudo-friendly helper installer for the missing optional
  `numlockx` package.

## Review

- `scripts/executable_ubuntu-start` now mounts `/dev/sdc1` at
  `/mnt/linux-files-3` before running `wal`.
- Graphiti startup now uses `docker compose -f docker/docker-compose-neo4j.yml
  up -d neo4j`, avoiding the `graphiti-mcp` service's host port `8000` bind.
- Startup now checks optional helper commands before running them, skips
  duplicate `picom` and `dunst` startup, tells `redshift` to use `randr`,
  and applies wallpapers through `/home/kevin/scripts/apply-pywal-theme` only
  when the shuffler returns an existing file.
- The Graphiti volume mount now runs `sudo mount` directly when `/dev/sdc1`
  exists and `/mnt/linux-files-3` is not already mounted, so the operator can
  enter a password during startup.
- `dot_Xmodmap` now maps all 20 pointer buttons, preserving the existing
  first-12 remap while removing the partial-button warning.
- `scripts/executable_install-ubuntu-start-helpers.sh` gives the operator a
  single `sudo` entrypoint for installing `numlockx` when Num Lock startup
  behavior is desired.
- `dot_config/picom/picom.conf` no longer sets the deprecated
  `refresh-rate` option.
- Verification passed:
  - `bash tests/test_ubuntu_start.sh`
  - `bash -n scripts/executable_ubuntu-start tests/test_ubuntu_start.sh`
