# dotfiles

# macOS

TODO

# Linux Mint

## Getting started (first time setup)

- Open Terminal app (defaults to bash)
- `sudo apt upgrade`
- `sudo apt install git`
- `cd ~`

---

_If cloning over SSH, AND/OR have write-access wish to contribute, follow these steps:_

- `mkdir .ssh`
- Copy ssh keys from protected source to ~/.ssh

  - `mv ./id_rsa ~/.ssh/`
  - `mv ./id_rsa.pub ~/.ssh/`
  - `chmod 400 ~/.ssh/*`

---

_Clone anywhere you'd like. This is how I setup and manage my repos locally_

- `mkdir workspaces`
- `cd workspaces`
- `mkdir personal`
- `cd personal`
- `git clone git@github.com:philipwindeyer/dotfiles.git`
  - OR `git clone https://github.com/philipwindeyer/dotfiles.git`

---

- Follow the steps in [linux-mint/README.md](./linux-mint/README.md) to complete the setup

# Windows 11

## Getting started (first time setup)

- Open Terminal app (defaults to PowerShell) or PowerShell session as **Administator**
- `winget install -s winget --accept-package-agreements Git.Git` (first run will prompt you to accept terms and conditions manually)
- `cd ~`

---

_If cloning over SSH, AND/OR have write-access wish to contribute, follow these steps:_

- `mkdir .ssh`
- Copy ssh keys from protected source to ~/.ssh

  - `mv .\id_rsa ~\.ssh\`
  - `mv .\id_rsa.pub ~\.ssh\`

---

_Clone anywhere you'd like. This is how I setup and manage my repos locally_

- `mkdir workspaces`
- `cd workspaces`
- `mkdir personal`
- `cd personal`
- `git clone git@github.com:philipwindeyer/dotfiles.git`
  - OR `git clone https://github.com/philipwindeyer/dotfiles.git`

---

- Follow the steps in [windows/README.md](./windows/README.md) to complete the setup
