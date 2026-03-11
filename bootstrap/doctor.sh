#!/usr/bin/env bash
set -e

echo "Checking dev environment..."

check() {
  if command -v "$1" >/dev/null 2>&1; then
    echo "✓ $1"
  else
    echo "✗ $1 missing"
  fi
}

check git
check zsh
check docker
check kubectl
check helm
check java
check mvn
check fzf
check rg

echo
echo "Docker:"
docker --version || true

echo
echo "Kubernetes:"
kubectl version --client || true

echo
echo "Helm:"
helm version || true


