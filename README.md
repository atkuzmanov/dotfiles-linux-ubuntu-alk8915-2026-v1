# Rebuild System Environment

This repository contains the **dotfiles and automation scripts used to rebuild my Linux development environment from scratch**.

It is designed so that a **fresh Ubuntu machine can be configured in minutes** using a single bootstrap command.

The system is built around:

* **chezmoi** for dotfile management
* **age encryption** for secrets
* **layered setup scripts** for system, developer tools, and user configuration

The goal is to make my environment:

* reproducible
* portable
* version controlled
* secure

---

# System Architecture

The rebuild system is structured as a **layered pipeline**.

```
Fresh Ubuntu Install
        │
        ▼
bootstrap.sh
        │
        ▼
Install prerequisites
(curl, git, chezmoi)
        │
        ▼
chezmoi init --apply
        │
        ▼
┌───────────────────────────────────────────┐
│        SYSTEM INSTALL LAYERS              │
│                                           │
│ run_onchange_before_10-install-core       │
│ run_onchange_before_20-dev-cli-tools      │
│ run_onchange_before_30-dev-platforms      │
│                                           │
└───────────────────────────────────────────┘
        │
        ▼
Dotfiles Applied
(.zshrc, .tmux.conf, .gitconfig, ~/.config)
        │
        ▼
┌───────────────────────────────────────────┐
│        DESKTOP CONFIGURATION              │
│                                           │
│ run_onchange_after_20-apply-gnome-dconf   │
│                                           │
└───────────────────────────────────────────┘
        │
        ▼
┌───────────────────────────────────────────┐
│        POST SETUP TASKS                   │
│                                           │
│ run_once_after_30-post-setup              │
│ run_once_after_40-user-setup              │
│                                           │
└───────────────────────────────────────────┘
        │
        ▼
Fully Configured Development Environment
```

Typical rebuild time:

```
OS install       ~10–15 minutes
bootstrap setup  ~3–5 minutes
verification     ~2 minutes
```

Total rebuild time:

**~20 minutes**

---

# Quick Start (Fresh Machine)

On a brand new Ubuntu system run:

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/atkuzmanov/dotfiles-linux-ubuntu-alk8915-2026-v1/main/bootstrap.sh)
```

This will:

1. Install required base tools (`curl`, `git`)
2. Install **chezmoi**
3. Clone this repository
4. Apply all dotfiles and setup scripts

---

# Repository Layout

The repository follows the **chezmoi source directory structure**.

```
bootstrap.sh
README.md

.chezmoiscripts/
    run_onchange_before_10-install-core-packages.sh
    run_onchange_before_20-install-dev-cli-tools.sh
    run_onchange_before_30-install-dev-platforms.sh
    run_onchange_after_20-apply-gnome-dconf.sh
    run_once_after_30-post-setup.sh
    run_once_after_40-user-setup.sh

dot_config/
    application configuration files

dot_gitconfig
dot_tmux.conf
dot_zshrc

private_dot_ssh/
    encrypted SSH configuration
```

### Naming Conventions

chezmoi uses special naming rules:

| Prefix            | Meaning                       |
| ----------------- | ----------------------------- |
| `dot_`            | maps to `.` in home directory |
| `private_`        | encrypted or sensitive        |
| `.chezmoiscripts` | automation scripts            |

Examples:

```
dot_zshrc     → ~/.zshrc
dot_tmux.conf → ~/.tmux.conf
dot_config/   → ~/.config/
```

---

# Setup Layers

## Core System Packages

Script:

```
run_onchange_before_10-install-core-packages.sh
```

Installs essential system utilities:

* git
* curl
* zsh
* age
* build tools
* system utilities

---

## Developer CLI Tools

Script:

```
run_onchange_before_20-install-dev-cli-tools.sh
```

Installs useful command-line tools:

* fzf
* ripgrep
* fd
* gh
* btop
* htop
* nvtop
* ranger
* direnv
* pipx
* shellcheck
* tree

---

## Developer Platforms

Script:

```
run_onchange_before_30-install-dev-platforms.sh
```

Installs major development platforms:

* Docker
* Kubernetes CLI (`kubectl`)
* Helm
* OpenJDK
* Maven

Kubernetes version is configurable:

```
KUBERNETES_VERSION="v1.32"
```

---

## Desktop Environment Configuration

Script:

```
run_onchange_after_20-apply-gnome-dconf.sh
```

Restores GNOME configuration including:

* theme
* fonts
* shell extensions
* Nautilus settings
* GNOME preferences

---

## Post Setup Tasks

Script:

```
run_once_after_30-post-setup.sh
```

Performs environment finishing tasks:

* `pipx ensurepath`
* directory initialization

---

## User Configuration

Script:

```
run_once_after_40-user-setup.sh
```

Applies user configuration:

* set default shell to **zsh**
* add user to **docker group**

Logout/login may be required.

---

# Secrets Management

Sensitive data is handled using:

* **chezmoi encryption**
* **age**

Encrypted files use:

```
.age
```

Example:

```
dot_config/warp-terminal/encrypted_user_preferences.json.age
```

Private SSH keys are stored under:

```
private_dot_ssh/
```

Secrets are automatically decrypted during `chezmoi apply`.

---

# Dotfiles Managed

Examples of configuration managed by this repository:

```
~/.zshrc
~/.tmux.conf
~/.gitconfig
~/.config/*
```

These are stored using chezmoi conventions:

```
dot_zshrc
dot_tmux.conf
dot_config/
```

---

# Updating the Environment

To update the environment from this repository:

```bash
chezmoi update
```

or manually apply changes:

```bash
chezmoi apply
```

---

# Supported Systems

Currently designed for:

* Ubuntu 22.04 LTS
* Ubuntu 24.04 LTS

Assumptions:

* `apt` package manager
* GNOME desktop environment

---

# Machine Rebuild Checklist

## 1. Install Operating System

Install:

* Ubuntu 24.04 LTS (preferred)
* Ubuntu 22.04 LTS

Recommended options:

* enable **full disk encryption**
* enable **LVM**
* create a normal user account

---

## 2. Update System

```bash
sudo apt update
sudo apt upgrade -y
sudo reboot
```

---

## 3. Install GPU Drivers (if applicable)

```
ubuntu-drivers devices
sudo ubuntu-drivers autoinstall
sudo reboot
```

Verify:

```
nvidia-smi
```

---

## 4. Run Environment Bootstrap

```
bash <(curl -fsSL https://raw.githubusercontent.com/atkuzmanov/dotfiles-linux-ubuntu-alk8915-2026-v1/main/bootstrap.sh)
```

---

## 5. Logout / Login

Required for:

* Docker group membership
* shell changes

---

## 6. Verify Core Tools

```
docker --version
kubectl version --client
helm version
java -version
mvn -version
git --version
zsh --version
```

---

## 7. Verify Docker

```
docker run hello-world
```

---

## 8. Verify Shell

```
echo $SHELL
```

Expected:

```
/usr/bin/zsh
```

---

## 9. Verify Dotfiles

Check configuration files exist:

```
~/.zshrc
~/.tmux.conf
~/.gitconfig
~/.config/
```

---

## 10. Restore SSH Keys

If necessary restore:

```
~/.ssh/
```

Verify GitHub access:

```
ssh -T git@github.com
```

---

## 11. Verify GNOME Configuration

Confirm that settings were restored:

* dark theme
* fonts
* GNOME extensions
* Nautilus preferences

---

## 12. Final Checks

```
gh --version
fzf --version
rg --version
fd --version
btop
```

---

# Author

**Atanas Kuzmanov (Nasko)**
Senior Software Engineer
Cybersecurity MSc
AI enthusiast

This repository is part of my **personal infrastructure and development environment automation**.

EOF
