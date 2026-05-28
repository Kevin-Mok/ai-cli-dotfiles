#!/usr/bin/env bash

set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
layout_script="${repo_root}/scripts/executable_apply-desktop-display-layout"
xinit_path="${repo_root}/dot_xinitrc.tmpl"
aliases_path="${repo_root}/aliases/key_aliases.tmpl"
i3_path="${repo_root}/dot_config/i3/config.tmpl"
i3blocks_4k_path="${repo_root}/dot_config/i3blocks/i3blocks-4k.conf.tmpl"

assert_contains() {
  local expected="$1"
  local path="$2"

  if ! rg -F -- "$expected" "$path" >/dev/null; then
    printf 'expected %s to contain: %s\n' "$path" "$expected" >&2
    exit 1
  fi
}

assert_contains '--output DVI-D-0 --mode 2048x1152 --pos 0x0 --rotate normal' "$layout_script"
assert_contains '--output DP-2 --mode 3840x2160 --pos 2048x0 --rotate normal' "$layout_script"
assert_contains '--output HDMI-0 --mode 1920x1080 --pos 5888x0 --rotate normal' "$layout_script"

assert_contains '/home/kevin/scripts/apply-desktop-display-layout' "$xinit_path"
assert_contains 'xrs "/home/kevin/scripts/apply-desktop-display-layout"' "$aliases_path"

assert_contains 'set $secondary "DVI-D-0"' "$i3_path"
assert_contains 'set $main "HDMI-0"' "$i3_path"
assert_contains 'output $main' "$i3_path"
assert_contains 'output $secondary' "$i3_path"
assert_contains 'output DP-2' "$i3_path"
assert_contains 'status_command i3blocks -c ~/.config/i3blocks/i3blocks-4k.conf' "$i3_path"
assert_contains 'bindsym $mod+minus move workspace to output left' "$i3_path"
assert_contains 'bindsym $mod+plus move workspace to output right' "$i3_path"
assert_contains '[spotify]' "$i3blocks_4k_path"
assert_contains 'command=~/.config/i3blocks/scripts/spotify_mpris' "$i3blocks_4k_path"
assert_contains 'label=' "$i3blocks_4k_path"

assert_contains '[volume]' "$i3blocks_4k_path"
assert_contains '[calendar]' "$i3blocks_4k_path"
