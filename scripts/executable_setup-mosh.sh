#!/usr/bin/env bash

set -euo pipefail

print_section() {
  printf '\n== %s ==\n' "$1"
}

print_note() {
  printf '%s\n' "$1"
}

print_warn() {
  printf 'WARN: %s\n' "$1"
}

print_fail() {
  printf 'FAIL: %s\n' "$1" >&2
}

require_root() {
  if [ "${EUID:-$(id -u)}" -eq 0 ]; then
    return 0
  fi

  if ! command -v sudo >/dev/null 2>&1; then
    print_fail "This script must run as root and sudo is not available"
    exit 1
  fi

  exec sudo "$0" "$@"
}

usage() {
  cat <<'EOF'
Usage:
  ./scripts/executable_setup-mosh.sh [--udp-port PORT|START:END]

What this does:
  - Installs mosh if needed
  - Opens the chosen UDP port or port range in ufw or firewalld when one is active
  - Verifies that mosh-server is installed
  - Checks whether an SSH server appears available for mosh login bootstrap

Options:
  --udp-port VALUE   UDP port or inclusive range for firewall rules. Defaults to 60000:61000.
  -h, --help         Show this help text.

This script re-execs itself with sudo when you are not already root.
EOF
}

is_valid_udp_value() {
  local value="$1"

  if [[ "$value" =~ ^[0-9]+$ ]]; then
    [ "$value" -ge 1 ] && [ "$value" -le 65535 ]
    return
  fi

  if [[ "$value" =~ ^([0-9]+):([0-9]+)$ ]]; then
    local start_port="${BASH_REMATCH[1]}"
    local end_port="${BASH_REMATCH[2]}"
    [ "$start_port" -ge 1 ] || return 1
    [ "$end_port" -le 65535 ] || return 1
    [ "$start_port" -le "$end_port" ]
    return
  fi

  return 1
}

need_command() {
  local name="$1"

  if command -v "$name" >/dev/null 2>&1; then
    return 0
  fi

  print_fail "Required command is not available: $name"
  exit 1
}

detect_pkg_manager() {
  if command -v apt-get >/dev/null 2>&1; then
    printf 'apt\n'
    return 0
  fi

  if command -v dnf >/dev/null 2>&1; then
    printf 'dnf\n'
    return 0
  fi

  if command -v pacman >/dev/null 2>&1; then
    printf 'pacman\n'
    return 0
  fi

  if command -v zypper >/dev/null 2>&1; then
    printf 'zypper\n'
    return 0
  fi

  return 1
}

install_mosh() {
  local pkg_manager="$1"

  if command -v mosh >/dev/null 2>&1 && command -v mosh-server >/dev/null 2>&1; then
    print_note "mosh and mosh-server are already installed."
    return 0
  fi

  print_section "Installing mosh"
  case "$pkg_manager" in
    apt)
      "${sudo_cmd[@]}" apt-get update
      "${sudo_cmd[@]}" apt-get install -y mosh
      ;;
    dnf)
      "${sudo_cmd[@]}" dnf install -y mosh
      ;;
    pacman)
      "${sudo_cmd[@]}" pacman -Sy --noconfirm --needed mosh
      ;;
    zypper)
      "${sudo_cmd[@]}" zypper --non-interactive install mosh
      ;;
    *)
      print_fail "Unsupported package manager: $pkg_manager"
      exit 1
      ;;
  esac
}

open_firewall_ports() {
  local udp_value="$1"

  if command -v ufw >/dev/null 2>&1; then
    if ufw status 2>/dev/null | grep -Fq 'Status: active'; then
      print_section "Firewall"
      "${sudo_cmd[@]}" ufw allow "${udp_value}/udp"
      print_note "Opened ${udp_value}/udp in ufw"
      return 0
    fi
  fi

  if command -v firewall-cmd >/dev/null 2>&1; then
    if firewall-cmd --state >/dev/null 2>&1; then
      print_section "Firewall"
      "${sudo_cmd[@]}" firewall-cmd --permanent --add-port="${udp_value}/udp"
      "${sudo_cmd[@]}" firewall-cmd --reload
      print_note "Opened ${udp_value}/udp in firewalld"
      return 0
    fi
  fi

  print_warn "No active ufw or firewalld instance detected. Open ${udp_value}/udp manually if another firewall is in use."
}

detect_ssh_server_state() {
  if command -v systemctl >/dev/null 2>&1; then
    if systemctl is-active ssh.service >/dev/null 2>&1 || systemctl is-active sshd.service >/dev/null 2>&1; then
      printf 'active\n'
      return 0
    fi
  fi

  if command -v ss >/dev/null 2>&1; then
    if ss -ltn '( sport = :22 )' 2>/dev/null | tail -n +2 | grep -q .; then
      printf 'listening-on-22\n'
      return 0
    fi
  fi

  printf 'missing\n'
}

udp_port="60000:61000"
original_args=("$@")

while [ $# -gt 0 ]; do
  case "$1" in
    --udp-port)
      shift
      udp_port="${1:-}"
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

if ! is_valid_udp_value "$udp_port"; then
  print_fail "UDP value must be a port like 60001 or a range like 60000:61000"
  exit 1
fi

require_root "${original_args[@]}"

sudo_cmd=()
pkg_manager="$(detect_pkg_manager || true)"
if [ -z "$pkg_manager" ]; then
  print_fail "Could not detect a supported package manager. Supported: apt-get, dnf, pacman, zypper."
  exit 1
fi

need_command install

print_section "Environment"
if [ -r /etc/os-release ]; then
  . /etc/os-release
  print_note "Detected OS: ${PRETTY_NAME:-unknown}"
fi
print_note "Package manager: $pkg_manager"
print_note "UDP ports to open for mosh: $udp_port"

install_mosh "$pkg_manager"
open_firewall_ports "$udp_port"

print_section "Verification"
need_command mosh
need_command mosh-server
print_note "mosh version: $(mosh --version 2>/dev/null | head -n 1)"
print_note "mosh-server path: $(command -v mosh-server)"

ssh_state="$(detect_ssh_server_state)"
case "$ssh_state" in
  active)
    print_note "SSH server appears active. mosh can use it for login bootstrap."
    ;;
  listening-on-22)
    print_note "A listener exists on TCP 22. mosh should be able to bootstrap over SSH."
    ;;
  missing)
    print_warn "I did not detect an active SSH server on this machine."
    print_warn "mosh still needs SSH for the initial login, so install or start OpenSSH server before using it remotely."
    ;;
esac

print_section "How To Connect"
print_note "From another machine, run:"
print_note "  mosh $(id -un)@$(hostname -f 2>/dev/null || hostname)"
print_note ""
print_note "If you changed the firewall rule to a single custom UDP port, make sure your mosh invocation uses a matching mosh-server configuration."
