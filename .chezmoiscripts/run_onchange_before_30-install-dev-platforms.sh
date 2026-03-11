#!/usr/bin/env bash
set -euo pipefail

if ! command -v apt-get >/dev/null 2>&1; then
  exit 0
fi

export DEBIAN_FRONTEND=noninteractive

KUBERNETES_VERSION="v1.32"

sudo apt-get update

sudo apt-get install -y \
  ca-certificates \
  curl \
  gnupg \
  openjdk-21-jdk \
  maven

sudo install -m 0755 -d /etc/apt/keyrings

write_gpg_keyring() {
  local url="$1"
  local output="$2"
  local tmp
  tmp="$(mktemp)"
  curl -fsSL "$url" | gpg --dearmor --batch --yes > "$tmp"
  sudo mv "$tmp" "$output"
  sudo chmod a+r "$output"
}

# Docker
if ! command -v docker >/dev/null 2>&1; then
  echo "Installing Docker..."

  if [[ ! -f /etc/apt/keyrings/docker.gpg ]]; then
    write_gpg_keyring \
      "https://download.docker.com/linux/ubuntu/gpg" \
      "/etc/apt/keyrings/docker.gpg"
  fi

  echo \
    "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
$(. /etc/os-release && echo "$VERSION_CODENAME") stable" \
    | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

  sudo apt-get update
  sudo apt-get install -y \
    docker-ce \
    docker-ce-cli \
    containerd.io \
    docker-buildx-plugin \
    docker-compose-plugin
fi

# kubectl
if ! command -v kubectl >/dev/null 2>&1; then
  echo "Installing kubectl (${KUBERNETES_VERSION})..."

  if [[ ! -f /etc/apt/keyrings/kubernetes-apt-keyring.gpg ]]; then
    write_gpg_keyring \
      "https://pkgs.k8s.io/core:/stable:/${KUBERNETES_VERSION}/deb/Release.key" \
      "/etc/apt/keyrings/kubernetes-apt-keyring.gpg"
  fi

  echo "deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/${KUBERNETES_VERSION}/deb/ /" \
    | sudo tee /etc/apt/sources.list.d/kubernetes.list > /dev/null

  sudo chmod 644 /etc/apt/sources.list.d/kubernetes.list
  sudo apt-get update
  sudo apt-get install -y kubectl
fi

# Helm
if ! command -v helm >/dev/null 2>&1; then
  echo "Installing Helm..."

  if [[ ! -f /etc/apt/keyrings/helm.gpg ]]; then
    write_gpg_keyring \
      "https://baltocdn.com/helm/signing.asc" \
      "/etc/apt/keyrings/helm.gpg"
  fi

  echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/helm.gpg] https://baltocdn.com/helm/stable/debian/ all main" \
    | sudo tee /etc/apt/sources.list.d/helm-stable-debian.list > /dev/null

  sudo apt-get update
  sudo apt-get install -y helm
fi

echo "Dev platforms installation completed."
