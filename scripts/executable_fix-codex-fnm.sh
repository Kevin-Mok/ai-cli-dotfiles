#!/usr/bin/env bash

set -euo pipefail

MIN_NODE_VERSION="22.22.0"
DEFAULT_NODE_VERSION="23.6.0"

print_step() {
  printf '\n== %s ==\n' "$1"
}

print_note() {
  printf '%s\n' "$1"
}

print_warn() {
  printf 'WARN: %s\n' "$1"
}

usage() {
  cat <<'EOF'
Usage: executable_fix-codex-fnm.sh [--node-version VERSION] [--dry-run]

Repairs a broken fnm-managed Node installation so Codex can run with a
js_repl-compatible runtime. The script:
1. Ensures the chosen Node version is installed with fnm
2. Restores missing npm/npx/corepack shims when fnm left only the node binary
3. Installs or updates @openai/codex in that Node prefix
4. Verifies the resulting codex binary directly from the fnm install path

Options:
  --node-version VERSION  Node version to repair/install. Default: 23.6.0
  --dry-run               Skip the npm install step and only repair/check shims
  --help                  Show this help text
EOF
}

version_at_least() {
  local version="$1"
  local minimum="$2"
  local lowest

  lowest="$(printf '%s\n%s\n' "$version" "$minimum" | sort -V | head -n 1)"
  [ "$lowest" = "$minimum" ]
}

ensure_symlink() {
  local link_path="$1"
  local target_path="$2"
  local description="$3"
  local link_dir
  local target_from_link_dir

  link_dir="$(dirname "$link_path")"
  target_from_link_dir="$link_dir/$target_path"

  if [ -L "$link_path" ] && [ ! -e "$link_path" ]; then
    rm -f "$link_path"
  fi

  if [ -e "$link_path" ] || [ -L "$link_path" ]; then
    return 0
  fi

  if [ ! -e "$target_from_link_dir" ]; then
    print_warn "Cannot restore $description because the target is missing: $target_from_link_dir"
    return 1
  fi

  if ln -s "$target_path" "$link_path"; then
    print_note "Restored $description -> $target_path"
    return 0
  fi

  print_warn "Failed to create $description at $link_path"
  return 1
}

node_version="$DEFAULT_NODE_VERSION"
dry_run=0

while [ "$#" -gt 0 ]; do
  case "$1" in
    --node-version)
      if [ "$#" -lt 2 ]; then
        print_note "--node-version requires a value"
        exit 1
      fi
      node_version="$2"
      shift 2
      ;;
    --dry-run)
      dry_run=1
      shift
      ;;
    --help|-h)
      usage
      exit 0
      ;;
    *)
      print_note "Unknown argument: $1"
      usage
      exit 1
      ;;
  esac
done

if ! version_at_least "$node_version" "$MIN_NODE_VERSION"; then
  print_note "Node $node_version is too old for Codex js_repl. Need >= $MIN_NODE_VERSION."
  exit 1
fi

if ! command -v fnm >/dev/null 2>&1; then
  print_note "fnm is not installed or not on PATH."
  exit 1
fi

install_root="$HOME/.local/share/fnm/node-versions/v${node_version}/installation"
bin_dir="$install_root/bin"
lib_dir="$install_root/lib/node_modules"
node_bin="$bin_dir/node"
npm_cli="$lib_dir/npm/bin/npm-cli.js"
codex_bin="$bin_dir/codex"

print_step "Preparing Node $node_version"
if [ ! -x "$node_bin" ]; then
  print_note "Installing Node $node_version with fnm"
  fnm install "$node_version"
fi

if [ ! -x "$node_bin" ]; then
  print_note "Node binary is still missing after fnm install: $node_bin"
  exit 1
fi

if [ ! -f "$npm_cli" ]; then
  print_note "npm CLI is missing from the fnm install: $npm_cli"
  exit 1
fi

print_step "Repairing Missing Shims"
mkdir -p "$bin_dir"
ensure_symlink "$bin_dir/npm" "../lib/node_modules/npm/bin/npm-cli.js" "npm shim" || true
ensure_symlink "$bin_dir/npx" "../lib/node_modules/npm/bin/npx-cli.js" "npx shim" || true
ensure_symlink "$bin_dir/corepack" "../lib/node_modules/corepack/dist/corepack.js" "corepack shim" || true

print_note "Node binary: $node_bin"
print_note "npm CLI: $npm_cli"

if [ "$dry_run" -eq 1 ]; then
  print_step "Dry Run"
  print_note "Skipping Codex install/update."
else
  print_step "Installing Codex"
  "$node_bin" "$npm_cli" install -g @openai/codex@latest
fi

print_step "Verification"
if [ ! -x "$codex_bin" ]; then
  print_note "Codex binary was not created at: $codex_bin"
  exit 1
fi

"$codex_bin" --version

print_step "Next Step"
print_note "The script already installed or updated Codex for Node $node_version."
print_note "Run this in your interactive shell:"
printf '  fnm use %s\n' "$node_version"
print_note "If you only ran fnm default, open a new shell or run fnm use in the current shell."
print_note "Then launch Codex:"
printf '  %s\n' "codex"
print_note "If you use fish, you do not need hash -r."
