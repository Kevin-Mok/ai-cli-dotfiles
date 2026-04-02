#!/usr/bin/env bash

set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
wrapper_path="${repo_root}/scripts/executable_st-terminal"
st_path="${repo_root}/dot_config/st/config.def.h.tmpl"
i3_path="${repo_root}/dot_config/i3/config.tmpl"
smoke_path="${repo_root}/docs/smoke-tests.md"
readme_path="${repo_root}/README.md"

test -f "$wrapper_path"

assert_contains() {
  local needle="$1"
  local path="$2"
  if ! rg -F "$needle" "$path" >/dev/null; then
    printf 'expected %s to contain: %s\n' "$path" "$needle" >&2
    exit 1
  fi
}

assert_not_contains() {
  local needle="$1"
  local path="$2"
  if rg -F "$needle" "$path" >/dev/null; then
    printf 'expected %s to not contain: %s\n' "$path" "$needle" >&2
    exit 1
  fi
}

assert_contains 'Hack Nerd Font Mono' "$st_path"
assert_contains '{ TERMMOD,              XK_C,           clipcopy' "$st_path"
assert_contains '{ TERMMOD,              XK_V,           clippaste' "$st_path"
assert_contains '{ Button4,              XK_NO_MOD,      kscrollup' "$st_path"
assert_contains '{ Button5,              XK_NO_MOD,      kscrolldown' "$st_path"
assert_contains '{ ShiftMask,            XK_Page_Up,     kscrollup' "$st_path"
assert_contains '{ ShiftMask,            XK_Page_Down,   kscrolldown' "$st_path"
assert_contains 'static double minlatency = 8;' "$st_path"
assert_contains 'static double maxlatency = 33;' "$st_path"

assert_contains 'set $term kitty' "$i3_path"
assert_contains 'bindsym Control+Shift+Return exec $term -A1' "$i3_path"
assert_contains 'bindsym Mod4+c exec "$term -e sh -lc' "$i3_path"
assert_not_contains 'set $term /home/kevin/scripts/st-terminal' "$i3_path"

assert_contains 'Launch the primary terminal from an i3 binding' "$smoke_path"
assert_contains '`kitty`' "$smoke_path"
assert_contains 'Open `st`, run enough output to exceed one screen' "$smoke_path"

assert_contains 'default terminal' "$readme_path"
assert_contains '`kitty` as the default terminal' "$readme_path"
assert_contains '`st` template' "$readme_path"
