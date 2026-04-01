#!/usr/bin/env bash

set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
script_path="${repo_root}/scripts/executable_codex"

tmpdir="$(mktemp -d)"
cleanup() {
  if [ -f "${tmpdir}/wrapper-state/graphiti.pid" ]; then
    pid="$(cat "${tmpdir}/wrapper-state/graphiti.pid" 2>/dev/null || true)"
    if [ -n "${pid:-}" ] && kill -0 "$pid" 2>/dev/null; then
      kill "$pid" 2>/dev/null || true
      wait "$pid" 2>/dev/null || true
    fi
  fi
  rm -rf "$tmpdir"
}
trap cleanup EXIT

mkdir -p "${tmpdir}/bin" "${tmpdir}/graphiti" "${tmpdir}/home"

cat > "${tmpdir}/bin/codex" <<'EOF'
#!/usr/bin/env bash
set -euo pipefail
printf 'cwd=%s\n' "$PWD" >> "${WRAPPER_TEST_CODEX_LOG}"
printf 'args=%s\n' "$*" >> "${WRAPPER_TEST_CODEX_LOG}"
EOF
chmod +x "${tmpdir}/bin/codex"

cat > "${tmpdir}/bin/uv" <<'EOF'
#!/usr/bin/env bash
set -euo pipefail
printf 'cwd=%s\n' "$PWD" >> "${WRAPPER_TEST_UV_LOG}"
printf 'args=%s\n' "$*" >> "${WRAPPER_TEST_UV_LOG}"
sleep 30
EOF
chmod +x "${tmpdir}/bin/uv"

export PATH="${tmpdir}/bin:${PATH}"
export HOME="${tmpdir}/home"
export XDG_STATE_HOME="${tmpdir}/xdg-state"
export WRAPPER_TEST_CODEX_LOG="${tmpdir}/codex.log"
export WRAPPER_TEST_UV_LOG="${tmpdir}/uv.log"
export CODEX_WRAPPER_GRAPHITI_CWD="${tmpdir}/graphiti"
export CODEX_WRAPPER_STATE_DIR="${tmpdir}/wrapper-state"

"$script_path" --search
"$script_path" resume -a never

if [ ! -f "${tmpdir}/wrapper-state/graphiti.pid" ]; then
  printf 'expected graphiti pidfile to be created\n' >&2
  exit 1
fi

if [ "$(grep -c '^args=' "${tmpdir}/uv.log")" -ne 1 ]; then
  printf 'expected Graphiti background command to launch once\n' >&2
  cat "${tmpdir}/uv.log" >&2
  exit 1
fi

grep -Fq "cwd=${tmpdir}/graphiti" "${tmpdir}/uv.log"
grep -Fq "args=run main.py --transport stdio --database-provider neo4j --model qwen3:14b" "${tmpdir}/uv.log"
grep -Fq "args=--search" "${tmpdir}/codex.log"
grep -Fq "args=resume -a never" "${tmpdir}/codex.log"
