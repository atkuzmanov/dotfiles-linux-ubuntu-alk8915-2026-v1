#!/usr/bin/env bash
set -euo pipefail

log() {
  echo "[INFO] $*"
}

warn() {
  echo "[WARN] $*" >&2
}

require_sudo() {
  sudo -v
}

apt_repo_contains() {
  local pattern="$1"
  grep -Rqs "$pattern" /etc/apt/sources.list /etc/apt/sources.list.d 2>/dev/null
}

remove_legacy_helm_repo() {
  local changed=0

  # Remove known old file name
  if [ -f /etc/apt/sources.list.d/helm-stable-debian.list ]; then
    if grep -q "baltocdn.com/helm/stable/debian" /etc/apt/sources.list.d/helm-stable-debian.list 2>/dev/null; then
      log "Removing legacy Helm repo file: /etc/apt/sources.list.d/helm-stable-debian.list"
      sudo rm -f /etc/apt/sources.list.d/helm-stable-debian.list
      changed=1
    fi
  fi

  # Remove any other repo file containing the old Helm repo URL
  while IFS= read -r file; do
    [ -n "$file" ] || continue
    log "Removing legacy Helm repo file: $file"
    sudo rm -f "$file"
    changed=1
  done < <(
    find /etc/apt -type f \( -name "*.list" -o -name "*.sources" \) -print0 \
      | xargs -0 grep -l "baltocdn.com/helm/stable/debian" 2>/dev/null || true
  )

  return $changed
}

ensure_helm_key() {
  local keyring="/usr/share/keyrings/helm.gpg"

  if [ -f "$keyring" ]; then
    log "Helm key already present: $keyring"
    return 1
  fi

  log "Installing Helm GPG key..."
  curl -fsSL https://packages.buildkite.com/helm-linux/helm-debian/gpgkey \
    | gpg --dearmor \
    | sudo tee "$keyring" >/dev/null

  return 0
}

ensure_helm_repo() {
  local repo_file="/etc/apt/sources.list.d/helm-stable-debian.list"
  local repo_line='deb [signed-by=/usr/share/keyrings/helm.gpg] https://packages.buildkite.com/helm-linux/helm-debian/any/ any main'

  if [ -f "$repo_file" ] && grep -Fqx "$repo_line" "$repo_file"; then
    log "Helm APT repo already configured"
    return 1
  fi

  log "Configuring Helm APT repo..."
  echo "$repo_line" | sudo tee "$repo_file" >/dev/null
  return 0
}

install_helm() {
  require_sudo

  if command -v helm >/dev/null 2>&1; then
    log "Helm already installed: $(helm version --short 2>/dev/null || echo "present")"
    return 0
  fi

  local apt_changed=0

  if remove_legacy_helm_repo; then
    apt_changed=1
  fi

  if ensure_helm_key; then
    apt_changed=1
  fi

  if ensure_helm_repo; then
    apt_changed=1
  fi

  if [ "$apt_changed" -eq 1 ]; then
    log "Running apt-get update..."
    sudo apt-get update
  else
    log "APT repo state unchanged"
  fi

  log "Installing Helm..."
  sudo apt-get install -y helm

  log "Helm installed successfully: $(helm version --short)"
}

install_helm

