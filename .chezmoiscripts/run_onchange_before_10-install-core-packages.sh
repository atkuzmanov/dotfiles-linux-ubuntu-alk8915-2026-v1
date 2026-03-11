#!/usr/bin/env bash
set -euo pipefail

if ! command -v apt-get >/dev/null 2>&1; then
  exit 0
fi

export DEBIAN_FRONTEND=noninteractive

sudo apt-get update

sudo apt-get install -y \
  age \
  bash-completion \
  build-essential \
  ca-certificates \
  curl \
  file \
  gawk \
  git \
  gnupg \
  jq \
  less \
  locales \
  lsb-release \
  make \
  nano \
  openssh-client \
  passwd \
  rsync \
  software-properties-common \
  tmux \
  unzip \
  wget \
  xclip \
  zip \
  zsh



