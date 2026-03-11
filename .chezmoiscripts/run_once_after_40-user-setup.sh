#!/usr/bin/env bash
set -euo pipefail

echo "Running one-time user setup..."

CURRENT_USER="${USER}"
ZSH_PATH="$(command -v zsh || true)"

if [[ -n "${ZSH_PATH}" ]]; then
  CURRENT_SHELL="$(getent passwd "${CURRENT_USER}" | cut -d: -f7)"
  if [[ "${CURRENT_SHELL}" != "${ZSH_PATH}" ]]; then
    echo "Setting default shell for ${CURRENT_USER} to ${ZSH_PATH}"
    chsh -s "${ZSH_PATH}" "${CURRENT_USER}" || true
  else
    echo "Default shell already set to zsh."
  fi
else
  echo "zsh not found, skipping default shell change."
fi

if getent group docker >/dev/null 2>&1; then
  if id -nG "${CURRENT_USER}" | tr ' ' '\n' | grep -qx docker; then
    echo "User ${CURRENT_USER} is already in the docker group."
  else
    echo "Adding ${CURRENT_USER} to docker group..."
    sudo usermod -aG docker "${CURRENT_USER}"
    echo "Docker group updated. Logout/login is required for this to take effect."
  fi
else
  echo "docker group not found, skipping docker group setup."
fi

echo "One-time user setup completed."
