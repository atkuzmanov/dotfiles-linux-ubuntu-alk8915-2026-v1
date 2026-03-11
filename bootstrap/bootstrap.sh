#!/usr/bin/env bash
set -euo pipefail

trap 'echo "Bootstrap failed on line $LINENO" >&2; exit 1' ERR

REPO_SHORT="atkuzmanov/dotfiles-linux-ubuntu-alk8915-2026-v1"

echo "Starting bootstrap..."

if ! command -v sudo >/dev/null 2>&1; then
  echo "sudo is required."
  exit 1
fi

if ! command -v apt-get >/dev/null 2>&1; then
  echo "This bootstrap currently supports apt-based systems only."
  exit 1
fi

if [[ -f /etc/os-release ]]; then
  . /etc/os-release
  if [[ "${ID:-}" != "ubuntu" ]]; then
    echo "This bootstrap currently supports Ubuntu only."
    exit 1
  fi
else
  echo "Cannot determine operating system."
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
  echo "Initializing chezmoi from ${REPO_SHORT} ..."
  chezmoi init --apply "${REPO_SHORT}"
fi

echo
echo "Bootstrap completed."
echo "You may need to log out and log back in if docker group membership or shell changes were applied."



