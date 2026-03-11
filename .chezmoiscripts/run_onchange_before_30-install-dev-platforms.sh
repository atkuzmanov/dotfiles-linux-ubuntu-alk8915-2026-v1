#!/usr/bin/env bash
set -euo pipefail

if ! command -v apt-get >/dev/null 2>&1; then
  exit 0
fi

export DEBIAN_FRONTEND=noninteractive

# -------------------------------
# CONFIGURABLE VERSIONS
# -------------------------------

KUBERNETES_VERSION="v1.32"

# -------------------------------
# Base packages
# -------------------------------

sudo apt-get update

sudo apt-get install -y \
  ca-certificates \
  curl \
  gnupg \
  openjdk-21-jdk \
  maven

# -------------------------------
# Docker
# -------------------------------

if ! command -v docker >/dev/null 2>&1; then
  echo "Installing Docker..."

  sudo install -m 0755 -d /etc/apt/keyrings

  curl -fsSL https://download.docker.com/linux/ubuntu/gpg \
    | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

  sudo chmod a+r /etc/apt/keyrings/docker.gpg

  echo \
    "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] \
    https://download.docker.com/linux/ubuntu \
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

# -------------------------------
# Kubernetes (kubectl)
# -------------------------------

if ! command -v kubectl >/dev/null 2>&1; then
  echo "Installing kubectl (${KUBERNETES_VERSION})..."

  sudo mkdir -p /etc/apt/keyrings

  curl -fsSL "https://pkgs.k8s.io/core:/stable:/${KUBERNETES_VERSION}/deb/Release.key" \
    | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg

  sudo chmod 644 /etc/apt/keyrings/kubernetes-apt-keyring.gpg

  echo "deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] \
https://pkgs.k8s.io/core:/stable:/${KUBERNETES_VERSION}/deb/ /" \
    | sudo tee /etc/apt/sources.list.d/kubernetes.list > /dev/null

  sudo chmod 644 /etc/apt/sources.list.d/kubernetes.list

  sudo apt-get update

  sudo apt-get install -y kubectl
fi

# -------------------------------
# Helm
# -------------------------------

if ! command -v helm >/dev/null 2>&1; then
  echo "Installing Helm..."

  curl https://baltocdn.com/helm/signing.asc \
    | sudo gpg --dearmor -o /etc/apt/keyrings/helm.gpg

  sudo chmod go+r /etc/apt/keyrings/helm.gpg

  echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/helm.gpg] \
https://baltocdn.com/helm/stable/debian/ all main" \
    | sudo tee /etc/apt/sources.list.d/helm-stable-debian.list > /dev/null

  sudo apt-get update
  sudo apt-get install -y helm
fi

echo "Dev platforms installation completed."
