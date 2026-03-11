#!/usr/bin/env bash
set -euo pipefail

if ! command -v apt-get >/dev/null 2>&1; then
  exit 0
fi

export DEBIAN_FRONTEND=noninteractive

sudo apt-get update

sudo apt-get install -y \
  btop \
  direnv \
  fd-find \
  fzf \
  gh \
  htop \
  nvtop \
  pipx \
  plocate \
  python3-pip \
  ranger \
  ripgrep \
  shellcheck \
  tree \
  wl-clipboard \
  xsel
