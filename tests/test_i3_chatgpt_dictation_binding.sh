#!/usr/bin/env bash

set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
config_path="${repo_root}/dot_config/i3/config.tmpl"

if ! rg -F 'bindsym Menu exec --no-startup-id /home/kevin/scripts/chatgpt-dictation' "$config_path" >/dev/null; then
  printf 'expected ChatGPT dictation binding to use Menu in %s\n' "$config_path" >&2
  exit 1
fi
