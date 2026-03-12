# Dotfiles Architecture & Home Directory Audit

This document describes the architecture of the dotfiles system managed
with **chezmoi** and explains which files in `$HOME` are **managed** vs
**ignored**, including the reasons for each decision.

------------------------------------------------------------------------

# Dotfiles System Architecture

    Git Repo (dotfiles)
            │
            ▼
       chezmoi apply
            │
            ▼
     ┌───────────────────────┐
     │ Managed configuration │
     │  ~/.bashrc            │
     │  ~/.zshrc             │
     │  ~/.tmux.conf         │
     │  ~/.gitconfig         │
     │  ~/.config/*          │
     └───────────────────────┘
            │
            ▼
     Bootstrap scripts
     (.chezmoiscripts)
            │
            ▼
     System setup
      - install packages
      - install dev tools
      - apply GNOME settings
      - configure environment
            │
            ▼
     Fully configured machine

------------------------------------------------------------------------

# Managed by Dotfiles

  Path                           Reason
  ------------------------------ --------------------------------
  .bashrc                        Bash configuration
  .zshrc                         Zsh configuration
  .tmux.conf                     Terminal multiplexer
  .gitconfig                     Git global configuration
  .profile                       Login shell configuration
  .config/\*                     Most application configuration
  .config/starship.toml          Prompt configuration
  .config/htop                   htop configuration
  .config/btop                   btop configuration
  .config/ranger                 ranger file manager
  .config/lazydocker             Docker TUI configuration
  .config/autostart/\*.desktop   Startup applications
  .ssh/config                    SSH client configuration
  .ssh/id_ed25519.pub            Public SSH key
  .config/gh                     GitHub CLI configuration
  .config/secrets/env            Encrypted environment secrets

------------------------------------------------------------------------

# Unmanaged Files

Ignored because they contain cache, runtime state, machine-specific
data, or installed software.

  Path            Reason
  --------------- -------------------------------------
  .bash_history   Shell history
  .zsh_history    Shell history
  .viminfo        Editor history
  .cache          Application cache
  .local/state    Runtime state
  .log            Logs
  .zcompdump\*    Zsh completion cache
  .nvm            Node version manager installation
  .pyenv          Python version manager installation
  .sdkman         JVM SDK manager installation
  .oh-my-zsh      Zsh framework source
  .npm            npm cache
  .n8n            n8n runtime database
  .var            Flatpak app data
  .nv             NVIDIA compute cache
  .p2             Eclipse plugin cache
  .sane           Scanner configuration
  .swt            Java SWT runtime state

------------------------------------------------------------------------

# Security Sensitive (Never Commit)

  Path              Contains
  ----------------- -----------------------
  .gnupg            GPG private keys
  .ssh/id_ed25519   SSH private key
  .pki              TLS certificate store

------------------------------------------------------------------------

# Installed Frameworks (Reinstalled via bootstrap)

  Framework   Location
  ----------- ---------------
  nvm         \~/.nvm
  pyenv       \~/.pyenv
  sdkman      \~/.sdkman
  oh-my-zsh   \~/.oh-my-zsh

These are installed automatically via bootstrap scripts.

------------------------------------------------------------------------

# Machine Rebuild Procedure

This procedure allows rebuilding the entire development machine from
scratch in minutes.

## 1. Install Base OS

Install a fresh system (Ubuntu).

During installation:

-   create user account
-   enable internet connection
-   install OpenSSH if available

------------------------------------------------------------------------

## 2. Install Git

``` bash
sudo apt update
sudo apt install git
```

------------------------------------------------------------------------

## 3. Install Chezmoi

``` bash
sh -c "$(curl -fsLS get.chezmoi.io)"
```

------------------------------------------------------------------------

## 4. Initialize Dotfiles

``` bash
chezmoi init <your-repo-url>
```

Example:

``` bash
chezmoi init https://github.com/yourusername/dotfiles.git
```

------------------------------------------------------------------------

## 5. Apply Configuration

``` bash
chezmoi apply
```

This will:

-   install configuration files
-   run bootstrap scripts
-   configure the shell
-   configure GNOME settings
-   install developer tools

------------------------------------------------------------------------

## 6. Run Bootstrap

If needed:

``` bash
~/bootstrap/bootstrap.sh
```

Bootstrap installs:

-   development platforms
-   CLI tooling
-   desktop configuration
-   system utilities

------------------------------------------------------------------------

## 7. Verify Environment

Run diagnostics:

``` bash
~/bootstrap/doctor.sh
```

------------------------------------------------------------------------

# Final Result

After the rebuild:

-   shell environment configured
-   developer tools installed
-   desktop environment configured
-   applications configured
-   secrets restored

Total rebuild time: **\~10--20 minutes**.
