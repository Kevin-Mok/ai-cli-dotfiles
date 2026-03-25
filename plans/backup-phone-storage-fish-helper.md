# ExecPlan: Backup Phone Storage Fish Helper

## Goal

Add a fish helper that rsyncs the Termux shared storage directory from
the configured phone host into `/mnt/linux-files-3/pixel-9`, and record
the reusable manual verification step in the shared smoke-test
checklist.

## Assumptions

1. The helper should be a new fish function instead of replacing the
   existing `backup-phone-pics` helper.
2. The shared `$PHONE_IP` variable is the canonical host identifier for
   phone SSH access in this repo.
3. Fish syntax validation plus a manual smoke step is the appropriate
   verification path for this shell helper change.

## Steps

- [completed] Create the new fish function with the requested rsync
  source and destination.
- [completed] Update `docs/smoke-tests.md` with the reusable manual
  check.
- [completed] Validate fish syntax and inspect the diff.

## Review

- Added `backup-phone-storage` as a focused fish helper that uses the
  shared `$PHONE_IP` host value and SSH port `8022`.
- Adjusted the helper to use `--rsync-path` because the Termux SSH
  session failed to resolve `rsync` from the remote shell `PATH`.
- Added a remote preflight check because the phone reported that the
  Termux `rsync` binary is not installed, which would otherwise fail
  during the rsync protocol handshake.
- Updated the helper to follow symlinks so Termux storage entries like
  `dcim` copy their underlying files instead of only transferring the
  symlink itself.
- Enabled rsync progress output so the helper shows transfer progress
  during long phone storage syncs and prints final summary stats.
- Refined the rsync output to show the current path plus stable
  `xfr#/to-chk` counters and ETA by disabling incremental recursion.
- Added a reusable smoke-test entry covering the manual rsync check for
  the new helper.
- Verified the helper parses with `fish -n
  dot_config/fish/functions/backup-phone-storage.fish`.
