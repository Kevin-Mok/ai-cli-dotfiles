#!/usr/bin/env bash

set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
bashrc_path="${repo_root}/dot_bashrc"

if rg -n 'xmodmap -e "(clear Lock|keycode 22 = Caps_Lock|keycode 66 = BackSpace)"' "$bashrc_path" >/dev/null; then
  printf 'expected keyboard remaps to live in X startup files, not %s\n' "$bashrc_path" >&2
  exit 1
fi
