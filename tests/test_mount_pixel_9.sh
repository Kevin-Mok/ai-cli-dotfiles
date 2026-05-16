#!/usr/bin/env bash

set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
script_path="${repo_root}/scripts/executable_mount-pixel-9"
smoke_path="${repo_root}/docs/smoke-tests.md"

tmpdir="$(mktemp -d)"
trap 'rm -rf "$tmpdir"' EXIT

mockbin="${tmpdir}/mockbin"
mount_dir="${tmpdir}/pixel-9"
log_file="${tmpdir}/commands.log"
mount_state_file="${tmpdir}/mount-state.txt"
mount_owner_file="${tmpdir}/mount-owner.txt"
mount_access_file="${tmpdir}/mount-access.txt"

mkdir -p "$mockbin"
: > "$log_file"
printf 'none\n' > "$mount_state_file"
printf 'root:root\n' > "$mount_owner_file"
printf '1\n' > "$mount_access_file"

cat > "${mockbin}/id" <<'EOF'
#!/usr/bin/env bash
set -euo pipefail
case "${1:-}" in
  -u) printf '1000\n' ;;
  -un) printf 'kevin\n' ;;
  -gn) printf 'kevin\n' ;;
  *) exit 1 ;;
esac
EOF

cat > "${mockbin}/sudo" <<'EOF'
#!/usr/bin/env bash
set -euo pipefail
printf 'sudo %s\n' "$*" >> "$TEST_LOG"
TEST_UNDER_SUDO=1 "$@"
EOF

cat > "${mockbin}/mkdir" <<'EOF'
#!/usr/bin/env bash
set -euo pipefail
printf 'mkdir %s\n' "$*" >> "$TEST_LOG"
if [ "${TEST_MKDIR_NEEDS_SUDO:-0}" = "1" ] && [ "${TEST_UNDER_SUDO:-0}" != "1" ]; then
  exit 1
fi
/usr/bin/mkdir "$@"
EOF

cat > "${mockbin}/chown" <<'EOF'
#!/usr/bin/env bash
set -euo pipefail
printf 'chown %s\n' "$*" >> "$TEST_LOG"
printf '%s\n' "$1" > "$TEST_MOUNT_OWNER"
EOF

cat > "${mockbin}/stat" <<'EOF'
#!/usr/bin/env bash
set -euo pipefail
printf 'stat %s\n' "$*" >> "$TEST_LOG"
cat "$TEST_MOUNT_OWNER"
EOF

cat > "${mockbin}/mountpoint" <<'EOF'
#!/usr/bin/env bash
set -euo pipefail
printf 'mountpoint %s\n' "$*" >> "$TEST_LOG"
exit 1
EOF

cat > "${mockbin}/findmnt" <<'EOF'
#!/usr/bin/env bash
set -euo pipefail
printf 'findmnt %s\n' "$*" >> "$TEST_LOG"
if [ "$(cat "$TEST_MOUNT_STATE")" = "mounted" ]; then
  printf '%s fuse.jmtpfs\n' "$TEST_MOUNT_DIR"
  exit 0
fi
exit 1
EOF

cat > "${mockbin}/timeout" <<'EOF'
#!/usr/bin/env bash
set -euo pipefail
printf 'timeout %s\n' "$*" >> "$TEST_LOG"
access_state="$(cat "$TEST_MOUNT_ACCESS")"
if [ "$access_state" = "1" ]; then
  exit 0
fi
if [ "$access_state" = "stale_once" ]; then
  printf '1\n' > "$TEST_MOUNT_ACCESS"
  exit 124
fi
exit 124
EOF

cat > "${mockbin}/fusermount" <<'EOF'
#!/usr/bin/env bash
set -euo pipefail
printf 'fusermount %s\n' "$*" >> "$TEST_LOG"
printf 'none\n' > "$TEST_MOUNT_STATE"
EOF

cat > "${mockbin}/jmtpfs" <<'EOF'
#!/usr/bin/env bash
set -euo pipefail
printf 'jmtpfs %s\n' "$*" >> "$TEST_LOG"
EOF

chmod +x "${mockbin}/id" "${mockbin}/sudo" "${mockbin}/mkdir" \
  "${mockbin}/chown" "${mockbin}/stat" "${mockbin}/mountpoint" "${mockbin}/findmnt" \
  "${mockbin}/timeout" "${mockbin}/fusermount" "${mockbin}/jmtpfs"

run_script() {
  TEST_LOG="$log_file" \
  TEST_MOUNT_DIR="$mount_dir" \
  TEST_MOUNT_STATE="$mount_state_file" \
  TEST_MOUNT_OWNER="$mount_owner_file" \
  TEST_MOUNT_ACCESS="$mount_access_file" \
  PATH="${mockbin}:${PATH}" \
  MOUNT_PIXEL_9_DIR="$mount_dir" \
  MOUNT_PIXEL_9_ID="${mockbin}/id" \
  MOUNT_PIXEL_9_SUDO="${mockbin}/sudo" \
  MOUNT_PIXEL_9_MKDIR="${mockbin}/mkdir" \
  MOUNT_PIXEL_9_CHOWN="${mockbin}/chown" \
  MOUNT_PIXEL_9_STAT="${mockbin}/stat" \
  MOUNT_PIXEL_9_MOUNTPOINT="${mockbin}/mountpoint" \
  MOUNT_PIXEL_9_FINDMNT="${mockbin}/findmnt" \
  MOUNT_PIXEL_9_TIMEOUT="${mockbin}/timeout" \
  MOUNT_PIXEL_9_FUSERMOUNT="${mockbin}/fusermount" \
  MOUNT_PIXEL_9_JMTPFS="${mockbin}/jmtpfs" \
  bash "$script_path" "$@"
}

assert_contains() {
  local needle="$1"
  local haystack_file="$2"
  if ! rg -F -- "$needle" "$haystack_file" >/dev/null; then
    printf 'expected to find %s in %s\n' "$needle" "$haystack_file" >&2
    exit 1
  fi
}

assert_not_contains() {
  local needle="$1"
  local haystack_file="$2"
  if rg -F -- "$needle" "$haystack_file" >/dev/null; then
    printf 'expected not to find %s in %s\n' "$needle" "$haystack_file" >&2
    exit 1
  fi
}

test -f "$script_path"
bash -n "$script_path"
assert_contains '/home/kevin/scripts/mount-pixel-9' "$smoke_path"

help_output="$(run_script --help)"
printf '%s\n' "$help_output" | grep -Fq 'Usage:'
printf '%s\n' "$help_output" | grep -Fq '/mnt/pixel-9'

export TEST_MKDIR_NEEDS_SUDO=1
run_output="$(run_script)"
unset TEST_MKDIR_NEEDS_SUDO
printf '%s\n' "$run_output" | grep -Fq "Mounted Pixel 9 at $mount_dir"

assert_contains "sudo ${mockbin}/mkdir -p $mount_dir" "$log_file"
assert_contains "sudo ${mockbin}/chown kevin:kevin $mount_dir" "$log_file"
assert_contains "jmtpfs $mount_dir" "$log_file"

: > "$log_file"
printf 'mounted\n' > "$mount_state_file"
printf 'stale_once\n' > "$mount_access_file"
run_output="$(run_script)"
printf '%s\n' "$run_output" | grep -Fq "Remounting stale Pixel 9 MTP mount at $mount_dir"
printf '%s\n' "$run_output" | grep -Fq "Mounted Pixel 9 at $mount_dir"

assert_contains "findmnt --mountpoint $mount_dir --noheadings --output FSTYPE" "$log_file"
assert_contains "timeout 3 ls $mount_dir" "$log_file"
assert_contains "fusermount -u $mount_dir" "$log_file"
assert_contains "jmtpfs $mount_dir" "$log_file"

: > "$log_file"
printf 'none\n' > "$mount_state_file"
printf 'kevin:kevin\n' > "$mount_owner_file"
printf '1\n' > "$mount_access_file"
run_output="$(run_script)"
printf '%s\n' "$run_output" | grep -Fq "Mounted Pixel 9 at $mount_dir"

assert_contains "stat -c %U:%G $mount_dir" "$log_file"
assert_not_contains "sudo ${mockbin}/mkdir -p $mount_dir" "$log_file"
assert_not_contains "sudo ${mockbin}/chown kevin:kevin $mount_dir" "$log_file"
assert_contains "jmtpfs $mount_dir" "$log_file"

: > "$log_file"
printf 'none\n' > "$mount_state_file"
printf 'kevin:kevin\n' > "$mount_owner_file"
printf '0\n' > "$mount_access_file"
if run_output="$(run_script 2>&1)"; then
  printf 'expected inaccessible post-mount check to fail, got: %s\n' "$run_output" >&2
  exit 1
fi
printf '%s\n' "$run_output" | grep -Fq 'mounted but the phone storage is still inaccessible'

assert_contains "timeout 3 ls $mount_dir" "$log_file"
assert_contains "fusermount -u $mount_dir" "$log_file"
