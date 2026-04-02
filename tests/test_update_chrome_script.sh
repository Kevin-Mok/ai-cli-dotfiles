#!/usr/bin/env bash

set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
script_path="${repo_root}/scripts/executable_update-chrome.sh"

tmpdir="$(mktemp -d)"
trap 'rm -rf "$tmpdir"' EXIT

mockbin="${tmpdir}/mockbin"
state_file="${tmpdir}/state.txt"
log_file="${tmpdir}/commands.log"

mkdir -p "$mockbin"
printf '144.0.7559.96-1\n' > "$state_file"
: > "$log_file"

cat > "${mockbin}/dpkg-query" <<'EOF'
#!/usr/bin/env bash
set -euo pipefail
cat "$TEST_STATE"
EOF

cat > "${mockbin}/apt-cache" <<'EOF'
#!/usr/bin/env bash
set -euo pipefail
cat <<POLICY
google-chrome-stable:
  Installed: $(cat "$TEST_STATE")
  Candidate: 146.0.7680.177-1
  Version table:
     146.0.7680.177-1 500
POLICY
EOF

cat > "${mockbin}/apt-get" <<'EOF'
#!/usr/bin/env bash
set -euo pipefail
printf 'apt-get %s\n' "$*" >> "$TEST_LOG"
if [ "${1:-}" = "install" ]; then
  printf '146.0.7680.177-1\n' > "$TEST_STATE"
fi
EOF

chmod +x "${mockbin}/dpkg-query" "${mockbin}/apt-cache" "${mockbin}/apt-get"

run_script() {
  TEST_STATE="$state_file" \
  TEST_LOG="$log_file" \
  UPDATE_CHROME_ASSUME_ROOT=1 \
  UPDATE_CHROME_DPKG_QUERY="${mockbin}/dpkg-query" \
  UPDATE_CHROME_APT_CACHE="${mockbin}/apt-cache" \
  UPDATE_CHROME_APT_GET="${mockbin}/apt-get" \
  bash "$script_path" "$@"
}

assert_contains() {
  local needle="$1"
  local haystack_file="$2"
  if ! rg -F "$needle" "$haystack_file" >/dev/null; then
    printf 'expected to find %s in %s\n' "$needle" "$haystack_file" >&2
    return 1
  fi
}

if ! help_output="$(run_script --help 2>&1)"; then
  printf 'expected help command to succeed for %s\n' "$script_path" >&2
  exit 1
fi

printf '%s\n' "$help_output" | grep -Fq "Usage:"
printf '%s\n' "$help_output" | grep -Fq "executable_update-chrome.sh"
printf '%s\n' "$help_output" | grep -Fq -- "--check"

check_output="$(run_script --check)"
printf '%s\n' "$check_output" | grep -Fq "Installed: 144.0.7559.96-1"
printf '%s\n' "$check_output" | grep -Fq "Candidate: 146.0.7680.177-1"

run_script
assert_contains "apt-get update" "$log_file"
assert_contains "apt-get install -y --only-upgrade google-chrome-stable" "$log_file"

printf '146.0.7680.177-1\n' > "$state_file"
: > "$log_file"
up_to_date_output="$(run_script)"
printf '%s\n' "$up_to_date_output" | grep -Fq "Google Chrome is already up to date."
