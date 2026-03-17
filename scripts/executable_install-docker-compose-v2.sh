#!/usr/bin/env bash

set -euo pipefail

print_step() {
  printf '\n== %s ==\n' "$1"
}

print_note() {
  printf '%s\n' "$1"
}

print_warn() {
  printf 'WARN: %s\n' "$1"
}

run_compose_check() {
  set +e
  COMPOSE_CHECK_OUTPUT="$(docker compose version 2>&1)"
  COMPOSE_CHECK_STATUS=$?
  set -e

  COMPOSE_CHECK_MISSING=0
  if printf '%s' "$COMPOSE_CHECK_OUTPUT" | grep -Fq "is not a docker command"; then
    COMPOSE_CHECK_MISSING=1
  fi
}

download_file() {
  local url="$1"
  local destination="$2"

  if command -v curl >/dev/null 2>&1; then
    curl -fL "$url" -o "$destination"
    return 0
  fi

  if command -v wget >/dev/null 2>&1; then
    wget -O "$destination" "$url"
    return 0
  fi

  print_note "Neither curl nor wget is installed, so the manual fallback cannot download Docker Compose."
  exit 1
}

if ! command -v docker >/dev/null 2>&1; then
  print_note "docker is not installed or not on PATH."
  print_note "Install Docker first, then rerun this script."
  exit 1
fi

run_compose_check
if [ "$COMPOSE_CHECK_STATUS" -eq 0 ] && [ "$COMPOSE_CHECK_MISSING" -eq 0 ]; then
  print_note "docker compose already works. Nothing to install."
  printf '%s\n' "$COMPOSE_CHECK_OUTPUT"
  exit 0
fi

sudo_cmd=()
if [ "${EUID:-$(id -u)}" -ne 0 ] && command -v sudo >/dev/null 2>&1; then
  sudo_cmd=(sudo)
fi

if [ ! -r /etc/os-release ]; then
  print_note "Cannot detect the operating system because /etc/os-release is missing."
  exit 1
fi

. /etc/os-release

install_via_apt=0
install_pkg=""
if command -v apt-cache >/dev/null 2>&1; then
  if apt-cache show docker-compose-v2 >/dev/null 2>&1; then
    install_pkg="docker-compose-v2"
    install_via_apt=1
  elif apt-cache show docker-compose-plugin >/dev/null 2>&1; then
    install_pkg="docker-compose-plugin"
    install_via_apt=1
  fi
fi

if [ "$install_via_apt" -eq 1 ] && { [ "${EUID:-$(id -u)}" -eq 0 ] || [ ${#sudo_cmd[@]} -gt 0 ]; }; then
  print_step "Installing Compose v2 Plugin Via apt"
  print_note "Detected OS: ${PRETTY_NAME:-unknown}"
  print_note "Installing package: $install_pkg"

  if "${sudo_cmd[@]}" apt-get update && "${sudo_cmd[@]}" apt-get install -y "$install_pkg"; then
    run_compose_check
    if [ "$COMPOSE_CHECK_STATUS" -eq 0 ] && [ "$COMPOSE_CHECK_MISSING" -eq 0 ]; then
      print_step "Verification"
      printf '%s\n' "$COMPOSE_CHECK_OUTPUT"
      if command -v docker-compose >/dev/null 2>&1; then
        print_note "Legacy docker-compose is still installed. This script leaves it unchanged."
      fi
      exit 0
    fi

    print_warn "The apt install completed, but docker compose is still not usable. Falling back to a manual plugin install."
  else
    print_warn "The apt install path failed. Falling back to a manual plugin install."
  fi
elif [ "$install_via_apt" -eq 1 ]; then
  print_warn "An apt package is available, but this shell does not have root access or sudo. Falling back to a user-level plugin install."
else
  print_warn "No Compose v2 apt package is available in the current apt sources. Falling back to a user-level plugin install."
fi

print_step "Installing Compose v2 Plugin Manually"

os_name="$(uname -s | tr '[:upper:]' '[:lower:]')"
if [ "$os_name" != "linux" ]; then
  print_note "This fallback currently supports Linux only. Detected OS kernel: $os_name"
  exit 1
fi

arch_name="$(uname -m)"
case "$arch_name" in
  x86_64|amd64)
    compose_arch="x86_64"
    ;;
  aarch64|arm64)
    compose_arch="aarch64"
    ;;
  armv7l|armv7)
    compose_arch="armv7"
    ;;
  ppc64le)
    compose_arch="ppc64le"
    ;;
  s390x)
    compose_arch="s390x"
    ;;
  *)
    print_note "Unsupported architecture for the manual fallback: $arch_name"
    exit 1
    ;;
esac

if [ -n "${COMPOSE_VERSION:-}" ]; then
  compose_url="https://github.com/docker/compose/releases/download/${COMPOSE_VERSION}/docker-compose-${os_name}-${compose_arch}"
else
  compose_url="https://github.com/docker/compose/releases/latest/download/docker-compose-${os_name}-${compose_arch}"
fi

plugin_root="${DOCKER_CONFIG:-$HOME/.docker}/cli-plugins"
plugin_path="$plugin_root/docker-compose"

tmp_file="$(mktemp)"
trap 'rm -f "$tmp_file"' EXIT

print_note "Download URL: $compose_url"
print_note "Install path: $plugin_path"
download_file "$compose_url" "$tmp_file"
mkdir -p "$plugin_root"
install -m 755 "$tmp_file" "$plugin_path"

run_compose_check
if [ "$COMPOSE_CHECK_STATUS" -eq 0 ] && [ "$COMPOSE_CHECK_MISSING" -eq 0 ]; then
  print_step "Verification"
  printf '%s\n' "$COMPOSE_CHECK_OUTPUT"
  if command -v docker-compose >/dev/null 2>&1; then
    print_note "Legacy docker-compose is still installed. This script leaves it unchanged."
  fi
  exit 0
fi

print_note "The manual install completed, but docker compose still is not usable."
printf '%s\n' "$COMPOSE_CHECK_OUTPUT"
exit 1
