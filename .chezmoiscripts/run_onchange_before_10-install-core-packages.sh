#!/usr/bin/env bash
set -euo pipefail

if ! command -v apt-get >/dev/null 2>&1; then
  exit 0
fi

sudo apt-get update
sudo apt-get install -y \
  curl \
  git \
  zsh \
  age
