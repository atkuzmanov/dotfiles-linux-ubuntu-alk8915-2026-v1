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
  gnome-shell-extension-prefs \
  gnome-shell-extensions

# Ubuntu-packaged extensions
# Tiling Assistant is packaged on Ubuntu 24.04.
sudo apt-get install -y gnome-shell-extension-ubuntu-tiling-assistant || true

# Wait until gnome-extensions is available
if ! command -v gnome-extensions >/dev/null 2>&1; then
  echo "gnome-extensions CLI not found; skipping GNOME extension installation."
  exit 0
fi

# Optional: install extension ZIPs vendored in the repo
EXT_ZIP_DIR="${HOME}/.local/share/nasko/gnome-extensions"

install_zip_if_present() {
  local zip_file="$1"
  if [[ -f "$zip_file" ]]; then
    echo "Installing GNOME extension pack: $zip_file"
    gnome-extensions install --force "$zip_file" || true
  fi
}

# Example vendored ZIPs:
# install_zip_if_present "${EXT_ZIP_DIR}/Vitals@CoreCoding.com.shell-extension.zip"
# install_zip_if_present "${EXT_ZIP_DIR}/vitalswidget@ctrln3rd.github.com.shell-extension.zip"
# install_zip_if_present "${EXT_ZIP_DIR}/caffeine@patapon.info.shell-extension.zip"

# Enable/disable extensions to match your desired state
enable_if_installed() {
  local uuid="$1"
  if gnome-extensions info "$uuid" >/dev/null 2>&1; then
    echo "Enabling GNOME extension: $uuid"
    gnome-extensions enable "$uuid" || true
  else
    echo "Extension not installed, cannot enable: $uuid"
  fi
}

disable_if_installed() {
  local uuid="$1"
  if gnome-extensions info "$uuid" >/dev/null 2>&1; then
    echo "Disabling GNOME extension: $uuid"
    gnome-extensions disable "$uuid" || true
  fi
}

# Your current desired state from dconf
enable_if_installed "caffeine@patapon.info"
enable_if_installed "Vitals@CoreCoding.com"
enable_if_installed "vitalsWidget@ctrln3rd.github.com"

disable_if_installed "gTile@vibou"
disable_if_installed "tiling-assistant@leleat-on-github"

# Ubuntu's packaged tiling assistant UUID may differ from upstream naming.
# This helps if the Ubuntu-packaged version is present.
enable_if_installed "ubuntu-tiling-assistant@ubuntu.com" || true
disable_if_installed "ubuntu-tiling-assistant@ubuntu.com" || true

echo "GNOME extension installation step completed."
