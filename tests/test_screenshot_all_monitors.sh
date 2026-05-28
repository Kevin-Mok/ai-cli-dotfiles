#!/usr/bin/env bash

set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
script_path="${repo_root}/scripts/executable_screenshot-all-monitors"

tmp_dir="$(mktemp -d)"
trap 'rm -rf "$tmp_dir"' EXIT

fake_bin="${tmp_dir}/bin"
output_dir="${tmp_dir}/screenshots"
scrot_arg_file="${tmp_dir}/scrot-arg"
mkdir -p "$fake_bin"

cat > "${fake_bin}/date" <<'EOF'
#!/usr/bin/env bash
set -euo pipefail

if [ "$#" -eq 1 ] && [ "$1" = "+%F_%T" ]; then
  printf '2026-05-28_09:02:20\n'
  exit 0
fi

printf 'unexpected date arguments: %s\n' "$*" >&2
exit 2
EOF

cat > "${fake_bin}/scrot" <<'EOF'
#!/usr/bin/env bash
set -euo pipefail

if [ "$#" -ne 1 ]; then
  printf 'expected one output path, got %s args\n' "$#" >&2
  exit 2
fi

printf '%s\n' "$1" > "$SCROT_ARG_FILE"
: > "$1"
EOF

chmod +x "${fake_bin}/date" "${fake_bin}/scrot"

expected="${output_dir}/screenshot-2026-05-28_09:02:20.png"
actual="$(
  PATH="${fake_bin}:${PATH}" \
  SCROT_ARG_FILE="$scrot_arg_file" \
  SCREENSHOT_ALL_MONITORS_DIR="$output_dir" \
  "$script_path"
)"

if [ "$actual" != "$expected" ]; then
  printf 'expected output path %s, got %s\n' "$expected" "$actual" >&2
  exit 1
fi

if [ ! -f "$expected" ]; then
  printf 'expected screenshot file to be created at %s\n' "$expected" >&2
  exit 1
fi

scrot_arg="$(< "$scrot_arg_file")"
if [ "$scrot_arg" != "$expected" ]; then
  printf 'expected scrot to receive %s, got %s\n' "$expected" "$scrot_arg" >&2
  exit 1
fi
