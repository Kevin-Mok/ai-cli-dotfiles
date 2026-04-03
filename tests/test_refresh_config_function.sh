#!/usr/bin/env bash

set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
function_path="${repo_root}/dot_config/fish/functions/refresh-config.fish"

tmpdir="$(mktemp -d)"
cleanup() {
  rm -rf "$tmpdir"
}
trap cleanup EXIT

mkdir -p "${tmpdir}/bin" "${tmpdir}/repo/dot_codex" "${tmpdir}/home/.codex" "${tmpdir}/home/.config/fish"
log_path="${tmpdir}/calls.log"

cat > "${tmpdir}/bin/cp" <<'EOF'
#!/usr/bin/env bash
set -euo pipefail
printf 'cp:%s->%s\n' "$1" "$2" >> "$TEST_LOG"
/bin/cp "$1" "$2"
EOF
chmod +x "${tmpdir}/bin/cp"

cat > "${tmpdir}/bin/chezmoi" <<'EOF'
#!/usr/bin/env bash
set -euo pipefail
if [ "$1" = "source-path" ]; then
  printf 'chezmoi:%s\n' "$*" >> "$TEST_LOG"
  printf '%s\n' "$TEST_CODEX_SOURCE_PATH"
  exit 0
fi
printf 'chezmoi:%s\n' "$*" >> "$TEST_LOG"
EOF
chmod +x "${tmpdir}/bin/chezmoi"

cat > "${tmpdir}/bin/sync-shortcuts" <<'EOF'
#!/usr/bin/env bash
set -euo pipefail
printf 'sync-shortcuts\n' >> "$TEST_LOG"
EOF
chmod +x "${tmpdir}/bin/sync-shortcuts"

cat > "${tmpdir}/home/.codex/config.toml" <<'EOF'
model = "local"
EOF

cat > "${tmpdir}/home/.config/fish/key_abbr.fish" <<'EOF'
# test stub
EOF

cat > "${tmpdir}/repo/dot_codex/config.toml" <<'EOF'
model = "repo"
EOF

TEST_LOG="$log_path" \
TEST_CODEX_SOURCE_PATH="${tmpdir}/repo/dot_codex/config.toml" \
PATH="${tmpdir}/bin:${PATH}" \
HOME="${tmpdir}/home" \
fish -c "source '$function_path'; refresh-config"

if ! grep -Fq "cp:${tmpdir}/home/.codex/config.toml->${tmpdir}/repo/dot_codex/config.toml" "$log_path"; then
  printf 'expected refresh-config to copy local Codex config into repo source\n' >&2
  cat "$log_path" >&2
  exit 1
fi

if ! grep -Fq 'chezmoi:apply' "$log_path"; then
  printf 'expected refresh-config to run chezmoi apply\n' >&2
  cat "$log_path" >&2
  exit 1
fi

if ! grep -Fq "chezmoi:source-path ${tmpdir}/home/.codex/config.toml" "$log_path"; then
  printf 'expected refresh-config to resolve the tracked Codex source path through chezmoi\n' >&2
  cat "$log_path" >&2
  exit 1
fi

if ! grep -Fq 'model = "local"' "${tmpdir}/repo/dot_codex/config.toml"; then
  printf 'expected repo config to be overwritten by local config contents\n' >&2
  cat "${tmpdir}/repo/dot_codex/config.toml" >&2
  exit 1
fi
