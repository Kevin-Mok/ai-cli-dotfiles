#!/usr/bin/env bash

set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
script_path="${repo_root}/scripts/executable_st-terminal"

test -f "$script_path"

tmpdir="$(mktemp -d)"
trap 'rm -rf "$tmpdir"' EXIT
mockbin="${tmpdir}/bin"
mkdir -p "$mockbin"

run_case() {
  local name="$1"
  local expected="$2"
  local extra_setup="$3"
  local exit_expected="${4:-0}"

  rm -f "${tmpdir}/log"
  rm -f "${mockbin}/st" "${mockbin}/stterm" "${mockbin}/kitty" "${mockbin}/urxvt" "${mockbin}/notify-send"

  cat > "${mockbin}/notify-send" <<'EOF'
#!/usr/bin/env bash
printf 'notify %s\n' "$*" >> "${TMPDIR_LOG}"
EOF
  chmod +x "${mockbin}/notify-send"

  TMPDIR_LOG="${tmpdir}/log"
  export TMPDIR_LOG
  eval "$extra_setup"

  set +e
  ST_TERMINAL_SEARCH_PATH="${mockbin}" ST_TERMINAL_DISABLE_ABSOLUTE_FALLBACK=1 PATH="${mockbin}:${PATH}" bash "$script_path" --flag value >"${tmpdir}/stdout" 2>"${tmpdir}/stderr"
  status=$?
  set -e

  if [ "$status" -ne "$exit_expected" ]; then
    printf '%s: expected exit %s, got %s\n' "$name" "$exit_expected" "$status" >&2
    exit 1
  fi

  if ! rg -F "$expected" "${tmpdir}/log" >/dev/null; then
    printf '%s: expected log to contain %s\n' "$name" "$expected" >&2
    exit 1
  fi
}

run_case \
  "prefers st" \
  "st --flag value" \
  "cat > '${mockbin}/st' <<'EOF'
#!/usr/bin/env bash
printf 'st %s\n' \"\$*\" >> \"${tmpdir}/log\"
EOF
chmod +x '${mockbin}/st'"

run_case \
  "falls back to stterm" \
  "stterm --flag value" \
  "cat > '${mockbin}/stterm' <<'EOF'
#!/usr/bin/env bash
printf 'stterm %s\n' \"\$*\" >> \"${tmpdir}/log\"
EOF
chmod +x '${mockbin}/stterm'"

run_case \
  "falls back to kitty" \
  "kitty --flag value" \
  "cat > '${mockbin}/kitty' <<'EOF'
#!/usr/bin/env bash
printf 'kitty %s\n' \"\$*\" >> \"${tmpdir}/log\"
EOF
chmod +x '${mockbin}/kitty'"

run_case \
  "warns when no terminal exists" \
  "notify st terminal launcher could not find" \
  "" \
  1

if ! rg -F "Install st, stterm, kitty, or urxvt" "${tmpdir}/stderr" >/dev/null; then
  printf 'expected missing-binary stderr hint\n' >&2
  exit 1
fi
