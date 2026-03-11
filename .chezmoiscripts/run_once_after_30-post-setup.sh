#!/usr/bin/env bash
set -euo pipefail

echo "Running one-time post-setup tasks..."

if command -v pipx >/dev/null 2>&1; then
  pipx ensurepath || true
fi

mkdir -p "${HOME}/.local/bin"
mkdir -p "${HOME}/.local/share/applications"
mkdir -p "${HOME}/.local/share/fonts"

if command -v updatedb >/dev/null 2>&1; then
  echo "updatedb is available."
fi

echo "Post-setup tasks completed."
