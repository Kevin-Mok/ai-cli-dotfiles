#!/usr/bin/env bash

set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
template_path="${repo_root}/dot_config/st/config.def.h.tmpl"
source_dir="${HOME}/coding/st"
skip_install=0
clone_if_missing=0
upstream_url="https://git.suckless.org/st"

usage() {
  cat <<'EOF'
Usage: ./scripts/executable_setup-st.sh [--source-dir DIR] [--skip-install] [--clone-if-missing]

Renders the tracked st config into ~/.config/st/config.def.h, copies it
into an st source checkout, and installs the compiled binary.

Options:
  --source-dir DIR  Override the st source checkout path. Default: ~/coding/st
  --skip-install    Render and sync config files without running make install
  --clone-if-missing Clone the official st source from https://git.suckless.org/st when the checkout is missing
  --help            Show this help text
EOF
}

while [ "$#" -gt 0 ]; do
  case "$1" in
    --source-dir)
      if [ "$#" -lt 2 ]; then
        printf 'missing value for --source-dir\n' >&2
        exit 1
      fi
      source_dir="$2"
      shift 2
      ;;
    --skip-install)
      skip_install=1
      shift
      ;;
    --clone-if-missing)
      clone_if_missing=1
      shift
      ;;
    --help)
      usage
      exit 0
      ;;
    *)
      printf 'unknown argument: %s\n' "$1" >&2
      usage >&2
      exit 1
      ;;
  esac
done

if ! command -v chezmoi >/dev/null 2>&1; then
  printf 'chezmoi is required to render %s\n' "$template_path" >&2
  exit 1
fi

tmp_config="$(mktemp)"
trap 'rm -f "$tmp_config"' EXIT

chezmoi execute-template < "$template_path" > "$tmp_config"

live_config_path="${HOME}/.config/st/config.def.h"
install -Dm644 "$tmp_config" "$live_config_path"
printf 'Updated live st config: %s\n' "$live_config_path"

source_dir="${source_dir/#\~/$HOME}"
source_config_path="${source_dir}/config.def.h"

if [ ! -f "${source_dir}/Makefile" ]; then
  if [ "$clone_if_missing" -eq 1 ]; then
    if ! command -v git >/dev/null 2>&1; then
      printf 'git is required to clone st from %s\n' "$upstream_url" >&2
      exit 1
    fi
    mkdir -p "$(dirname "$source_dir")"
    git clone "$upstream_url" "$source_dir"
  fi
fi

if [ ! -f "${source_dir}/Makefile" ]; then
  if [ "$skip_install" -eq 1 ]; then
    printf 'st source checkout not found at %s\n' "$source_dir" >&2
    printf 'Config-only refresh completed. Clone %s or point --source-dir at your st checkout before compiling.\n' "$upstream_url" >&2
    exit 0
  fi
  printf 'st source checkout not found at %s\n' "$source_dir" >&2
  printf 'Clone %s or point --source-dir at your st checkout, then rerun this script.\n' "$upstream_url" >&2
  exit 1
fi

install -Dm644 "$tmp_config" "$source_config_path"
rm -f "${source_dir}/config.h"
printf 'Updated source config: %s\n' "$source_config_path"

if [ "$skip_install" -eq 1 ]; then
  printf 'Skipping install. Run: sudo make -C %s install\n' "$source_dir"
  exit 0
fi

sudo make -C "$source_dir" install
