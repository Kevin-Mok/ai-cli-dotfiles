#!/usr/bin/env bash

set -euo pipefail

script_name="./scripts/executable_setup-neovim-python-completion.sh"
default_neovim_version="0.11.5"
neovim_version="$default_neovim_version"
skip_lsp=0
skip_plugins=0

print_section() {
  printf '\n== %s ==\n' "$1"
}

print_note() {
  printf '%s\n' "$1"
}

print_fail() {
  printf 'FAIL: %s\n' "$1" >&2
}

usage() {
  cat <<EOF
Usage:
  ${script_name} [--neovim-version VERSION] [--skip-lsp] [--skip-plugins]

What this does:
  - Downloads and installs the official Neovim ${default_neovim_version} release under /opt
  - Symlinks /usr/local/bin/nvim to the installed release
  - Installs vim-plug for Neovim when missing
  - Runs PlugInstall for the repo-tracked Neovim config
  - Installs the basedpyright language server with: uv tool install --upgrade basedpyright

Options:
  --neovim-version VERSION  Override the Neovim release version. Defaults to ${default_neovim_version}.
  --skip-lsp                Skip the basedpyright install step.
  --skip-plugins            Skip vim-plug bootstrap and PlugInstall.
  -h, --help                Show this help text.

Run this from the repo root so the tracked config is the one Neovim loads.
The script will prompt for sudo only for the /opt and /usr/local/bin install steps.
EOF
}

need_command() {
  local name="$1"
  if ! command -v "$name" >/dev/null 2>&1; then
    print_fail "Required command is not available: $name"
    exit 1
  fi
}

sudo_run() {
  if [ "${EUID:-$(id -u)}" -eq 0 ]; then
    "$@"
    return
  fi

  if ! command -v sudo >/dev/null 2>&1; then
    print_fail "sudo is required for system install steps."
    exit 1
  fi

  sudo "$@"
}

run_as_user() {
  local user_name="$1"
  shift

  if [ -z "${user_name}" ] || [ "${user_name}" = "root" ]; then
    "$@"
    return
  fi

  if [ "${EUID:-$(id -u)}" -eq 0 ]; then
    sudo -u "${user_name}" "$@"
    return
  fi

  "$@"
}

resolve_user_command() {
  local user_home="$1"
  local name="$2"
  local candidate=""

  candidate="$(command -v "$name" 2>/dev/null || true)"
  if [ -n "${candidate}" ]; then
    printf '%s\n' "${candidate}"
    return 0
  fi

  for candidate in \
    "${user_home}/.local/bin/${name}" \
    "${user_home}/bin/${name}"
  do
    if [ -x "${candidate}" ]; then
      printf '%s\n' "${candidate}"
      return 0
    fi
  done

  return 1
}

detect_arch() {
  case "$(uname -m)" in
    x86_64)
      printf 'x86_64\n'
      ;;
    aarch64|arm64)
      printf 'arm64\n'
      ;;
    *)
      print_fail "Unsupported architecture: $(uname -m)"
      exit 1
      ;;
  esac
}

detect_user_home() {
  if [ -n "${SUDO_USER:-}" ] && [ "${SUDO_USER}" != "root" ]; then
    getent passwd "${SUDO_USER}" | cut -d: -f6
    return
  fi

  printf '%s\n' "${HOME}"
}

detect_user_name() {
  if [ -n "${SUDO_USER:-}" ] && [ "${SUDO_USER}" != "root" ]; then
    printf '%s\n' "${SUDO_USER}"
    return
  fi

  id -un
}

install_neovim() {
  local arch="$1"
  local install_root="/opt/nvim-${neovim_version}"
  local archive_name="nvim-linux-${arch}.tar.gz"
  local download_url="https://github.com/neovim/neovim-releases/releases/download/v${neovim_version}/${archive_name}"
  local tmpdir
  tmpdir="$(mktemp -d)"
  trap 'rm -rf "$tmpdir"' RETURN

  print_section "Installing Neovim ${neovim_version}"
  print_note "Download: ${download_url}"

  curl -fL "${download_url}" -o "${tmpdir}/${archive_name}"
  tar -xzf "${tmpdir}/${archive_name}" -C "${tmpdir}"

  sudo_run rm -rf "${install_root}"
  sudo_run mkdir -p /opt
  sudo_run mv "${tmpdir}/nvim-linux-${arch}" "${install_root}"
  sudo_run ln -sfn "${install_root}/bin/nvim" /usr/local/bin/nvim

  print_note "Installed Neovim to ${install_root}"
  print_note "Linked /usr/local/bin/nvim"
}

repair_user_ownership() {
  local user_name="$1"
  local user_home="$2"
  local path=""

  if [ -z "${user_name}" ] || [ "${user_name}" = "root" ]; then
    return
  fi

  print_section "Repairing plugin ownership"
  for path in \
    "${user_home}/.vim/plugged" \
    "${user_home}/.local/share/nvim" \
    "${user_home}/.local/state/nvim" \
    "${user_home}/.cache/nvim"
  do
    if [ -e "${path}" ]; then
      sudo_run chown -R "${user_name}:${user_name}" "${path}"
    fi
  done
}

install_plug_for_user() {
  local user_name="$1"
  local user_home="$2"
  local nvim_plug_path="${user_home}/.local/share/nvim/site/autoload/plug.vim"
  local vim_plug_path="${user_home}/.vim/autoload/plug.vim"

  print_section "Installing vim-plug"
  if [ ! -f "${nvim_plug_path}" ]; then
    run_as_user "${user_name}" mkdir -p "$(dirname "${nvim_plug_path}")"
    run_as_user "${user_name}" curl -fLo "${nvim_plug_path}" --create-dirs \
      https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  else
    print_note "vim-plug already present at ${nvim_plug_path}"
  fi

  if [ ! -f "${vim_plug_path}" ]; then
    run_as_user "${user_name}" mkdir -p "$(dirname "${vim_plug_path}")"
    run_as_user "${user_name}" install -m 0644 "${nvim_plug_path}" "${vim_plug_path}"
  else
    print_note "vim-plug already present at ${vim_plug_path}"
  fi
}

install_plugins() {
  local user_name="$1"
  local user_home="$2"
  local nvim_bin
  nvim_bin="$(command -v nvim)"

  print_section "Installing Neovim plugins"
  run_as_user "${user_name}" env \
    XDG_CONFIG_HOME="${user_home}/.config" \
    XDG_DATA_HOME="${user_home}/.local/share" \
    XDG_STATE_HOME="${user_home}/.local/state" \
    XDG_CACHE_HOME="${user_home}/.cache" \
    HOME="${user_home}" \
    "${nvim_bin}" --headless '+PlugInstall --sync' +qa
}

install_basedpyright() {
  local user_name="$1"
  local user_home="$2"
  local uv_bin="$3"

  print_section "Installing Python LSP"
  run_as_user "${user_name}" env \
    HOME="${user_home}" \
    "${uv_bin}" tool install --upgrade basedpyright
}

while [ $# -gt 0 ]; do
  case "$1" in
    --neovim-version)
      shift
      neovim_version="${1:-}"
      ;;
    --skip-lsp)
      skip_lsp=1
      ;;
    --skip-plugins)
      skip_plugins=1
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      print_fail "Unknown argument: $1"
      usage
      exit 1
      ;;
  esac
  shift
done

if [ -z "${neovim_version}" ]; then
  print_fail "Neovim version cannot be empty."
  exit 1
fi

need_command curl
need_command tar
need_command install

user_home="$(detect_user_home)"
user_name="$(detect_user_name)"
arch="$(detect_arch)"
uv_bin=""

if [ "${skip_lsp}" -eq 0 ]; then
  uv_bin="$(resolve_user_command "${user_home}" uv || true)"
  if [ -z "${uv_bin}" ]; then
    print_fail "Required command is not available for the invoking user: uv"
    print_note "Install uv for ${SUDO_USER:-$USER}, or rerun with --skip-lsp if you only want the Neovim upgrade."
    exit 1
  fi
fi

print_section "Environment"
print_note "User name: ${user_name}"
print_note "User home: ${user_home}"
print_note "Architecture: ${arch}"
print_note "Target Neovim version: ${neovim_version}"
if [ "${skip_lsp}" -eq 0 ]; then
  print_note "Using uv from: ${uv_bin}"
fi

install_neovim "${arch}"

if [ "${skip_plugins}" -eq 0 ]; then
  repair_user_ownership "${user_name}" "${user_home}"
  install_plug_for_user "${user_name}" "${user_home}"
  install_plugins "${user_name}" "${user_home}"
fi

if [ "${skip_lsp}" -eq 0 ]; then
  install_basedpyright "${user_name}" "${user_home}" "${uv_bin}"
fi

print_section "Verification"
print_note "nvim version: $(nvim --version | head -n 1)"
if [ "${skip_lsp}" -eq 0 ]; then
  print_note "basedpyright path: $(HOME="${user_home}" sh -lc 'command -v basedpyright-langserver || true')"
fi

print_section "Next Steps"
print_note "Open a Python project in nvim and confirm member completion, auto-imports, hover docs, and signature help."
