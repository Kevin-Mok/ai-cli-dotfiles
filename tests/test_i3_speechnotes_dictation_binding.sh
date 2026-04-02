#!/usr/bin/env bash

set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
config_path="${repo_root}/dot_config/i3/config.tmpl"

if ! rg -F 'bindsym Menu exec --no-startup-id /home/kevin/scripts/speechnotes-dictation' "$config_path" >/dev/null; then
  printf 'expected Speechnotes dictation binding to use Menu in %s\n' "$config_path" >&2
  exit 1
fi

if ! rg -F 'exec --no-startup-id /home/kevin/scripts/speechnotes-dictation --prewarm' "$config_path" >/dev/null; then
  printf 'expected i3 startup to prewarm Speechnotes in %s\n' "$config_path" >&2
  exit 1
fi
