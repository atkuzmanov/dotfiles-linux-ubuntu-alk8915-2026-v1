#!/usr/bin/env bash
set -euo pipefail

load_dconf_file() {
  local prefix="$1"
  local file="$2"

  if [[ -f "$file" ]]; then
    echo "Applying dconf settings: $prefix from $file"
    dconf load "$prefix" < "$file"
  else
    echo "Skipping missing dconf file: $file"
  fi
}

BASE="${HOME}/.config/dconf"

load_dconf_file /org/gnome/desktop/interface/ "${BASE}/org-gnome-desktop-interface.conf"
load_dconf_file /org/gnome/mutter/ "${BASE}/org-gnome-mutter.conf"
load_dconf_file /org/gnome/nautilus/preferences/ "${BASE}/org-gnome-nautilus-preferences.conf"
load_dconf_file /org/gnome/shell/ "${BASE}/org-gnome-shell.conf"
load_dconf_file /org/gnome/shell/extensions/caffeine/ "${BASE}/org-gnome-shell-extensions-caffeine.conf"
load_dconf_file /org/gnome/shell/extensions/tiling-assistant/ "${BASE}/org-gnome-shell-extensions-tiling-assistant.conf"
load_dconf_file /org/gnome/shell/extensions/vitals/ "${BASE}/org-gnome-shell-extensions-vitals.conf"
load_dconf_file /org/gnome/shell/extensions/vitalswidget/ "${BASE}/org-gnome-shell-extensions-vitalswidget.conf"
