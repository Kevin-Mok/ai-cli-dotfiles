#!/usr/bin/env bash

set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
script_path="${repo_root}/scripts/executable_setup-st.sh"
readme_path="${repo_root}/README.md"
smoke_path="${repo_root}/docs/smoke-tests.md"

assert_contains() {
  local needle="$1"
  local path="$2"
  if ! rg -F -- "$needle" "$path" >/dev/null; then
    printf 'expected %s to contain: %s\n' "$path" "$needle" >&2
    exit 1
  fi
}

test -f "$script_path"
bash -n "$script_path"

assert_contains 'chezmoi execute-template < "$template_path" > "$tmp_config"' "$script_path"
assert_contains 'install -Dm644 "$tmp_config" "$live_config_path"' "$script_path"
assert_contains 'install -Dm644 "$tmp_config" "$source_config_path"' "$script_path"
assert_contains 'sudo make -C "$source_dir" install' "$script_path"
assert_contains '--skip-install' "$script_path"
assert_contains '--source-dir' "$script_path"
assert_contains '--clone-if-missing' "$script_path"
assert_contains 'source_dir="${HOME}/coding/st"' "$script_path"
assert_contains 'Config-only refresh completed.' "$script_path"
assert_contains 'upstream_url="https://git.suckless.org/st"' "$script_path"
assert_contains 'git clone "$upstream_url" "$source_dir"' "$script_path"

assert_contains 'executable_setup-st.sh' "$readme_path"
assert_contains 'Open a terminal, run `./scripts/executable_setup-st.sh --skip-install`' "$smoke_path"
