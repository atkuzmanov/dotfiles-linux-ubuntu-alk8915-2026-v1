#!/usr/bin/env bash
set -euo pipefail

echo "Running one-time post-setup tasks..."

mkdir -p "${HOME}/.local/bin"
mkdir -p "${HOME}/.local/share/applications"
mkdir -p "${HOME}/.local/share/fonts"

if command -v pipx >/dev/null 2>&1; then
  if [[ ":$PATH:" != *":${HOME}/.local/bin:"* ]]; then
    pipx ensurepath || true
  else
    echo "${HOME}/.local/bin is already in PATH."
  fi
fi

echo "Post-setup tasks completed."



