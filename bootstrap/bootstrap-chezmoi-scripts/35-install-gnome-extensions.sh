#!/usr/bin/env bash
set -euo pipefail

if ! command -v apt-get >/dev/null 2>&1; then
  exit 0
fi

export DEBIAN_FRONTEND=noninteractive

echo "Installing GNOME extension tooling..."

sudo apt-get update
sudo apt-get install -y \
  gnome-shell-extension-manager \
  gnome-shell-extensions

sudo apt-get install -y gnome-shell-extension-ubuntu-tiling-assistant || true

if ! command -v gnome-extensions >/dev/null 2>&1; then
  echo "gnome-extensions CLI not found; skipping extension installation."
  exit 0
fi

EXT_ZIP_DIR="${HOME}/.local/share/private_files_repo/gnome-extensions"

install_zip_if_present() {
  local zip_file="$1"
  if [[ -f "$zip_file" ]]; then
    echo "Installing GNOME extension ZIP: $zip_file"
    gnome-extensions install --force "$zip_file" || true
  else
    echo "ZIP not found, skipping: $zip_file"
  fi
}

enable_if_installed() {
  local uuid="$1"
  if gnome-extensions info "$uuid" >/dev/null 2>&1; then
    if ! gnome-extensions list --enabled | grep -qx "$uuid"; then
      echo "Enabling GNOME extension: $uuid"
      gnome-extensions enable "$uuid" || true
    else
      echo "GNOME extension already enabled: $uuid"
    fi
  else
    echo "Extension not installed, cannot enable: $uuid"
  fi
}

disable_if_installed() {
  local uuid="$1"
  if gnome-extensions info "$uuid" >/dev/null 2>&1; then
    if gnome-extensions list --enabled | grep -qx "$uuid"; then
      echo "Disabling GNOME extension: $uuid"
      gnome-extensions disable "$uuid" || true
    else
      echo "GNOME extension already disabled: $uuid"
    fi
  else
    echo "Extension not installed, cannot disable: $uuid"
  fi
}

install_zip_if_present "${EXT_ZIP_DIR}/caffeine@patapon.info.shell-extension.zip"
install_zip_if_present "${EXT_ZIP_DIR}/Vitals@CoreCoding.com.shell-extension.zip"
install_zip_if_present "${EXT_ZIP_DIR}/vitalsWidget@ctrln3rd.github.com.shell-extension.zip"

enable_if_installed "caffeine@patapon.info"
enable_if_installed "Vitals@CoreCoding.com"
enable_if_installed "vitalsWidget@ctrln3rd.github.com"

disable_if_installed "gTile@vibou"
disable_if_installed "tiling-assistant@leleat-on-github"

echo "GNOME extension installation completed."
echo "A logout/login may be required for changes to fully appear."



