#!/usr/bin/env bash

set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
script_path="${repo_root}/dot_config/i3blocks/scripts/executable_spotify_mpris"

tmpdir="$(mktemp -d)"
trap 'rm -rf "$tmpdir"' EXIT

mockbin="${tmpdir}/mockbin"
log_file="${tmpdir}/commands.log"
colors_file="${tmpdir}/colors.sh"

mkdir -p "$mockbin"
: > "$log_file"

cat > "${mockbin}/gdbus" <<'MOCK'
#!/usr/bin/env bash
set -euo pipefail
printf 'gdbus %s\n' "$*" >> "$TEST_LOG"
printf "(<{'xesam:title': <'Dust'>, 'xesam:artist': <['Drake']>, 'xesam:album': <'ICEMAN'>}>,)\n"
MOCK

cat > "${mockbin}/dbus-send" <<'MOCK'
#!/usr/bin/env bash
set -euo pipefail
printf 'dbus-send %s\n' "$*" >> "$TEST_LOG"
MOCK

chmod +x "${mockbin}/gdbus" "${mockbin}/dbus-send"
cat > "$colors_file" <<'COLORS'
color7='#112233'
export FZF_DEFAULT_OPTS="
    $FZF_DEFAULT_OPTS
    --color fg:7,bg:0
"
export LS_COLORS="${LS_COLORS}:su=30;41:"
COLORS

run_script() {
  TEST_LOG="$log_file" \
  PATH="${mockbin}:${PATH}" \
  SPOTIFY_MPRIS_COLORS_FILE="$colors_file" \
  bash "$script_path"
}

run_script_with_i3blocks_label() {
  TEST_LOG="$log_file" \
  PATH="${mockbin}:${PATH}" \
  SPOTIFY_MPRIS_COLORS_FILE="$colors_file" \
  LABEL="" \
  bash "$script_path"
}

run_click() {
  local button="$1"
  TEST_LOG="$log_file" \
  PATH="${mockbin}:${PATH}" \
  SPOTIFY_MPRIS_COLORS_FILE="$colors_file" \
  BLOCK_BUTTON="$button" \
  bash "$script_path" >/dev/null
}

assert_contains() {
  local needle="$1"
  local path="$2"

  if ! rg -F -- "$needle" "$path" >/dev/null; then
    printf 'expected %s to contain: %s\n' "$path" "$needle" >&2
    exit 1
  fi
}

test -f "$script_path"
bash -n "$script_path"

mapfile -t output < <(run_script)

if [ "${output[0]:-}" != "Drake - Dust" ]; then
  printf 'unexpected full text: %s\n' "${output[0]:-}" >&2
  exit 1
fi

if [ "${output[1]:-}" != "Dust" ]; then
  printf 'unexpected short text: %s\n' "${output[1]:-}" >&2
  exit 1
fi

if [ "${output[2]:-}" != "#112233" ]; then
  printf 'unexpected color: %s\n' "${output[2]:-}" >&2
  exit 1
fi

mapfile -t labeled_output < <(run_script_with_i3blocks_label)

if [ "${labeled_output[0]:-}" != "Drake - Dust" ]; then
  printf 'unexpected labeled full text: %s\n' "${labeled_output[0]:-}" >&2
  exit 1
fi

assert_contains 'gdbus call --session --dest org.mpris.MediaPlayer2.spotify --object-path /org/mpris/MediaPlayer2 --method org.freedesktop.DBus.Properties.Get org.mpris.MediaPlayer2.Player Metadata' "$log_file"

: > "$log_file"
run_click 1
run_click 2
run_click 3

assert_contains 'dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.PlayPause' "$log_file"
assert_contains 'dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.Previous' "$log_file"
assert_contains 'dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.Next' "$log_file"
