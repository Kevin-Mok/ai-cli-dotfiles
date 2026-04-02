#!/usr/bin/env bash

set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
config_path="${repo_root}/dot_vimrc.tmpl"

if ! rg -U "if exists\\('\\+mousescroll'\\)\\n  set mousescroll=ver:5,hor:1\\nendif" "$config_path" >/dev/null; then
  printf "expected %s to guard mousescroll behind exists('+mousescroll')\n" "$config_path" >&2
  exit 1
fi

if rg -n "^set mousescroll=ver:5,hor:1$" "$config_path" >/dev/null; then
  printf 'expected no unconditional mousescroll setting in %s\n' "$config_path" >&2
  exit 1
fi
