#!/usr/bin/env bash

set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
config_path="${repo_root}/dot_vimrc.tmpl"

if ! rg -n '^set updatetime=500$' "$config_path" >/dev/null; then
  printf 'expected %s to set updatetime=500\n' "$config_path" >&2
  exit 1
fi

if rg -n '^set updatetime=0$' "$config_path" >/dev/null; then
  printf 'expected %s to avoid updatetime=0 when CursorHold hooks are enabled\n' "$config_path" >&2
  exit 1
fi

if ! rg -n 'CursorHold' "$config_path" >/dev/null; then
  printf 'expected %s to still use CursorHold-based hooks for this regression check\n' "$config_path" >&2
  exit 1
fi
