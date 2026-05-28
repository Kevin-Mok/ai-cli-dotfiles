# Add Spotify MPRIS To 4K I3blocks Plan

> **For agentic workers:** Use `superpowers:executing-plans` to implement this plan task-by-task. Keep this plan in the same change as the related implementation and docs.

**Goal:** Replace the fragile `spotify-now` path used by the middle 4K i3blocks bar with a new MPRIS-based Spotify script that reads live Spotify metadata from `org.mpris.MediaPlayer2.spotify` through `gdbus`.

**Architecture:** Add a dedicated `dot_config/i3blocks/scripts/executable_spotify_mpris` script and point only the active 4K `[spotify]` block in `dot_config/i3blocks/i3blocks-4k.conf.tmpl` at `~/.config/i3blocks/scripts/spotify_mpris`. Leave the older `executable_spotify` script and inactive/commented Spotify examples alone.

**Tech Stack:** i3blocks config templates, Bash, `gdbus`, existing `dbus-send` MPRIS click controls, pywal colors, shell regression tests, smoke-test Markdown.

## Assumptions

1. The fix targets the middle 4K bar only.
2. The rendered bar full text includes the configured icon plus artist and title, e.g. ` Drake - Dust`; the script itself emits metadata text so i3blocks can prepend `label=` exactly once.
3. `playerctl` should not be introduced.
4. If pywal colors are unavailable, the script should still emit a safe color fallback.

## Task 1: Regression Coverage

**Files:**
- Modify: `tests/test_desktop_display_layout.sh`
- Add: `tests/test_i3blocks_spotify_mpris.sh`

- [x] Tighten the 4K layout regression test so `[spotify]` must explicitly use `command=~/.config/i3blocks/scripts/spotify_mpris` and `label=`.
- [x] Add a shell test with fake `gdbus` and `dbus-send` commands.
- [x] Verify metadata parsing produces full text `Drake - Dust`, short text `Dust`, and the pywal `color7` value; i3blocks prepends `label=` for the rendered bar.
- [x] Verify left, middle, and right clicks route to `PlayPause`, `Previous`, and `Next` on `org.mpris.MediaPlayer2.spotify`.
- [x] Run the new tests before implementation and confirm they fail for the expected missing script/config reasons.

## Task 2: MPRIS Script And 4K Block

**Files:**
- Add: `dot_config/i3blocks/scripts/executable_spotify_mpris`
- Modify: `dot_config/i3blocks/i3blocks-4k.conf.tmpl`

- [x] Add the executable Bash script that calls `gdbus` for `org.freedesktop.DBus.Properties.Get org.mpris.MediaPlayer2.Player Metadata`.
- [x] Parse `xesam:title` and `xesam:artist` from the MPRIS metadata for display; album is intentionally omitted from the long text.
- [x] Emit i3blocks three-line output: metadata full text, short text, color; leave the icon to the i3blocks label to avoid duplicate icons.
- [x] Preserve the existing `dbus-send` click controls: left click play/pause, middle click previous, right click next.
- [x] Source pywal `color7` when available and fall back safely when it is missing.
- [x] Point the active 4K `[spotify]` block at `~/.config/i3blocks/scripts/spotify_mpris` with `label=` and `interval=5`.

## Task 3: Docs And Verification

**Files:**
- Modify: `docs/smoke-tests.md`
- Modify: `plans/add-spotify-4k-i3blocks.md`

- [x] Update the smoke checklist so the middle 4K bar expectation includes the Spotify block.
- [x] Add a reusable manual smoke check for live Spotify MPRIS metadata and click controls.
- [x] Run `bash tests/test_desktop_display_layout.sh`.
- [x] Run `bash tests/test_i3blocks_spotify_mpris.sh`.
- [x] Run `bash -n dot_config/i3blocks/scripts/executable_spotify_mpris`.
- [x] Run `fish -ic refresh-config`.

## Review Notes

- The old `dot_config/i3blocks/scripts/executable_spotify` path remains unchanged for now.
- Commented Spotify examples in the other i3blocks configs remain untouched.

## Verification Log

- Red checks: `bash tests/test_i3blocks_spotify_mpris.sh` failed while the new script was missing; `bash tests/test_desktop_display_layout.sh` failed until the 4K block pointed at `spotify_mpris`.
- Green checks: `bash tests/test_desktop_display_layout.sh`, `bash tests/test_i3blocks_spotify_mpris.sh`, and `bash -n dot_config/i3blocks/scripts/executable_spotify_mpris` passed after implementation.
- Live regression: `/home/kevin/.config/i3blocks/scripts/spotify_mpris` originally failed because pywal `colors.sh` referenced unset shell variables under `set -u`; the script now parses only `color7` and the live i3blocks stream shows a single `` label.
- Apply check: `fish -ic refresh-config` completed successfully and reported that chezmoi applied the tracked config.
