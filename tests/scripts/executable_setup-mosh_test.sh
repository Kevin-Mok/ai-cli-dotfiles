#!/usr/bin/env bash

set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
script_path="${repo_root}/scripts/executable_setup-mosh.sh"

if ! output="$("$script_path" --help 2>&1)"; then
  printf 'expected help command to succeed for %s\n' "$script_path" >&2
  exit 1
fi

printf '%s\n' "$output" | grep -Fq "Usage:"
printf '%s\n' "$output" | grep -Fq "executable_setup-mosh.sh"
printf '%s\n' "$output" | grep -Fq -- "--udp-port"
printf '%s\n' "$output" | grep -Fq "Installs mosh if needed"
