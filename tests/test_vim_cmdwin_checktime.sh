#!/usr/bin/env bash

set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
config_path="${repo_root}/dot_vimrc.tmpl"

assert_contains() {
  local needle="$1"
  if ! rg -F "$needle" "$config_path" >/dev/null; then
    printf 'expected %s to contain: %s\n' "$config_path" "$needle" >&2
    exit 1
  fi
}

assert_not_contains() {
  local needle="$1"
  if rg -F "$needle" "$config_path" >/dev/null; then
    printf 'expected %s to not contain: %s\n' "$config_path" "$needle" >&2
    exit 1
  fi
}

assert_contains "autocmd CursorHold * if getcmdwintype() == '' | checktime | endif"
assert_not_contains 'autocmd CursorHold * if !bufexists("[Command Line]") | checktime | endif'
