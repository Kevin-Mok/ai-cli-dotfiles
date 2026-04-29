#!/usr/bin/env bash

set -euo pipefail

if [ "$(id -u)" -ne 0 ]; then
  printf 'Run with sudo: sudo %s\n' "$0" >&2
  exit 1
fi

apt-get update
apt-get install -y numlockx
