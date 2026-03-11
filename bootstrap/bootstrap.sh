#!/usr/bin/env bash
set -euo pipefail

echo "Starting bootstrap..."

if ! command -v apt-get >/dev/null 2>&1; then
  echo "This bootstrap currently supports apt-based systems only."
  exit 1
fi

export DEBIAN_FRONTEND=noninteractive

sudo apt-get update
sudo apt-get install -y curl git

if ! command -v chezmoi >/dev/null 2>&1; then
  echo "Installing chezmoi..."
  sh -c "$(curl -fsLS get.chezmoi.io)" -- -b "${HOME}/.local/bin"
fi

export PATH="${HOME}/.local/bin:${PATH}"

if ! command -v chezmoi >/dev/null 2>&1; then
  echo "chezmoi installation failed."
  exit 1
fi

if [[ -d "${HOME}/.local/share/chezmoi" ]]; then
  echo "chezmoi source already exists, running apply..."
  chezmoi apply
else
  echo "Initializing chezmoi..."
  chezmoi init --apply atkuzmanov/dotfiles-linux-ubuntu-alk8915-2026-v1
fi

echo "Bootstrap completed."
echo "You may need to log out and log back in if docker group membership or shell changes were applied."


