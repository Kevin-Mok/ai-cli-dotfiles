#!/usr/bin/env bash

set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
script_path="${repo_root}/scripts/executable_ubuntu-start"
picom_config_path="${repo_root}/dot_config/picom/picom.conf"
xmodmap_path="${repo_root}/dot_Xmodmap"

line_number() {
  local needle="$1"
  local path="$2"

  if ! awk -v needle="$needle" 'index($0, needle) { print NR; found = 1; exit } END { if (!found) exit 1 }' "$path"; then
    printf 'expected %s to contain: %s\n' "$path" "$needle" >&2
    exit 1
  fi
}

assert_contains() {
  local needle="$1"
  local path="$2"

  if ! rg -F -- "$needle" "$path" >/dev/null; then
    printf 'expected %s to contain: %s\n' "$path" "$needle" >&2
    exit 1
  fi
}

assert_not_contains() {
  local needle="$1"
  local path="$2"

  if rg -F -- "$needle" "$path" >/dev/null; then
    printf 'expected %s not to contain: %s\n' "$path" "$needle" >&2
    exit 1
  fi
}

assert_not_matches() {
  local pattern="$1"
  local path="$2"

  if rg --line-regexp -- "$pattern" "$path" >/dev/null; then
    printf 'expected %s not to match line: %s\n' "$path" "$pattern" >&2
    exit 1
  fi
}

mount_line="$(line_number 'GRAPHITI_VOLUME_DEVICE="/dev/sdc1"' "$script_path")"
wal_line="$(line_number 'wallpaper="$(/home/kevin/scripts/shuffler "$HOME/Pictures/Backgrounds/dim/editing" 2>/dev/null)"' "$script_path")"
compose_line="$(line_number 'docker compose -f docker/docker-compose-neo4j.yml up -d neo4j' "$script_path")"

if [ "$mount_line" -ge "$wal_line" ]; then
  printf 'expected /dev/sdc1 mount setup before wal startup\n' >&2
  exit 1
fi

assert_contains 'sudo mount "${GRAPHITI_VOLUME_DEVICE}" "${GRAPHITI_VOLUME_MOUNT}"' "$script_path"
assert_not_contains 'sudo -n true' "$script_path"
assert_not_contains 'Skipping Graphiti mount: sudo password required' "$script_path"
assert_contains 'docker compose -f docker/docker-compose-neo4j.yml up -d neo4j' "$script_path"
assert_not_matches '    docker compose -f docker/docker-compose-neo4j.yml up -d' "$script_path"
assert_contains 'command -v picom >/dev/null 2>&1' "$script_path"
assert_contains 'pgrep -x picom >/dev/null 2>&1' "$script_path"
assert_contains 'command -v imwheel >/dev/null 2>&1' "$script_path"
assert_contains 'command -v dunst >/dev/null 2>&1' "$script_path"
assert_contains 'pgrep -x dunst >/dev/null 2>&1' "$script_path"
assert_contains 'dunst &' "$script_path"
assert_contains 'start_command notification-daemon notification-daemon &' "$script_path"
assert_contains 'start_command numlockx numlockx on &' "$script_path"
assert_contains 'redshift -m randr -O 3000' "$script_path"
assert_contains '/home/kevin/scripts/apply-pywal-theme "${wallpaper}" &' "$script_path"
assert_not_contains '/usr/lib/notification-daemon-1.0/notification-daemon &' "$script_path"
assert_not_contains 'wal -i $(' "$script_path"
assert_not_matches 'refresh-rate = .*' "$picom_config_path"
assert_contains 'pointer = 1 2 3 6 7 4 5 10 11 12 8 9 13 14 15 16 17 18 19 20' "$xmodmap_path"

if [ "$compose_line" -le "$wal_line" ]; then
  printf 'expected Graphiti Neo4j startup after wal startup\n' >&2
  exit 1
fi

picom_starts="$(awk '$0 == "picom &" { count++ } END { print count + 0 }' "$script_path")"
if [ "$picom_starts" -ne 0 ]; then
  printf 'expected picom startup to be guarded instead of bare `picom &`\n' >&2
  exit 1
fi
