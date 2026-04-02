#!/usr/bin/env bash

set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
script_path="${repo_root}/scripts/executable_apply-pywal-theme"
kitty_config_path="${repo_root}/dot_config/kitty/kitty.conf"
i3_colors_path="${repo_root}/dot_config/i3/config.tmpl"
i3_config_path="${repo_root}/dot_config/i3/config.tmpl"
xinit_path="${repo_root}/dot_xinitrc.tmpl"
ranger_path="${repo_root}/dot_config/ranger/rc.conf.tmpl"
alias_path="${repo_root}/aliases/key_aliases.tmpl"
chooser_path="${repo_root}/scripts/executable_bg-chooser"

assert_contains() {
  local needle="$1"
  local path="$2"
  if ! rg -F -- "$needle" "$path" >/dev/null; then
    printf 'expected %s to contain: %s\n' "$path" "$needle" >&2
    exit 1
  fi
}

assert_contains "allow_remote_control socket-only" "$kitty_config_path"
assert_contains "listen_on unix:/tmp/kitty" "$kitty_config_path"
assert_contains "background_opacity 0.85" "$kitty_config_path"
assert_contains '--saturate 0.8 -e' "$script_path"
assert_contains '"${HOME}/.cache/wal/colors-i3.Xresources"' "$script_path"
assert_contains '"${HOME}/.cache/wal/colors.Xresources"' "$script_path"
assert_contains 'xrdb -merge' "$script_path"
assert_contains 'i3-msg reload' "$script_path"
assert_contains 'generate_i3_colors_script="${HOME}/scripts/generate-i3-pywal-colors"' "$script_path"
assert_contains 'kitty @ --to "${kitty_socket}" load-config' "$script_path"
assert_contains 'kitty @ --to "${kitty_socket}" set-colors --all --configured "${kitty_colors_file}"' "$script_path"
assert_contains 'wal --saturate 0.8 -e "$@"' "$script_path"
assert_contains 'wal --saturate 0.8 -e -i "$@"' "$script_path"
assert_contains '# opacity-rule = []' "${repo_root}/dot_config/picom/picom.conf"
assert_contains 'set_from_resource $ui_text i3wm.ui.text' "$i3_colors_path"
assert_contains 'set_from_resource $ui_focus_bg i3wm.ui.focus_bg' "$i3_colors_path"
assert_contains 'set_from_resource $ui_focus_text i3wm.ui.focus_text' "$i3_colors_path"
assert_contains 'focused_workspace $inactive_ws_bg $ui_focus_bg $ui_focus_text' "$i3_colors_path"
assert_contains 'active_workspace $inactive_ws_bg $ui_active_bg $ui_active_text' "$i3_colors_path"
assert_contains 'inactive_workspace $inactive_ws_bg $ui_inactive_bg $ui_inactive_text' "$i3_colors_path"
assert_contains 'exec /home/kevin/scripts/apply-pywal-theme $(' "$i3_config_path"
assert_contains '&& $make_st_script' "$i3_config_path"
assert_contains '/home/kevin/scripts/apply-pywal-theme $(/home/kevin/scripts/shuffler "$HOME/Pictures/Backgrounds/dim/editing")' "$xinit_path"
assert_contains 'map w shell /home/kevin/scripts/apply-pywal-theme %f' "$ranger_path"
assert_contains 'wal "/home/kevin/scripts/apply-pywal-theme"' "$alias_path"
assert_contains 'apply-pywal-theme' "$chooser_path"
