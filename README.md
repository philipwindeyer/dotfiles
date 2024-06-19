# dotfiles

My machine setup, including dotfiles, step-by-step instructions for manual setup, and scripts for automated installation and maintenance updates.

# Getting started (first time setup)

## macOS

- Open Terminal app (defaults to zsh)
- `git` (should trigger "Developer Tool" / Xcode installation)
- Follow the Developer Tool installation process
- `cd ~`
- (Optional) Follow the steps [Add SSH keys (macOS / Linux)](#add-ssh-keys-macos--linux)
- Follow [Cloning this repo over SSH](#cloning-this-repo-over-ssh)
- Follow the steps in [macos/README.md](./macos/README.md) to complete the setup

## Linux Mint

- Open Terminal app (defaults to bash)
- `sudo apt upgrade`
- `sudo apt install git`
- `cd ~`
- (Optional) Follow [Add SSH keys (macOS / Linux)](#add-ssh-keys-macos--linux)
- Follow [Cloning this repo over SSH](#cloning-this-repo-over-ssh)
- Follow the steps in [linux-mint/README.md](./linux-mint/README.md) to complete the setup

## Windows 11

- Open Terminal app (defaults to PowerShell) or PowerShell session as **Administator**
- `winget install -s winget --accept-package-agreements Git.Git` (first run will prompt you to accept terms and conditions manually)
- `cd ~`
- _If cloning over SSH, AND/OR have write-access wish to contribute, follow these steps:_
- `mkdir .ssh`
- Copy ssh keys from protected source to ~/.ssh
  - `mv .\id_rsa ~\.ssh\`
  - `mv .\id_rsa.pub ~\.ssh\`
- Follow [Cloning this repo over SSH](#cloning-this-repo-over-ssh)
- Follow the steps in [windows/README.md](./windows/README.md) to complete the setup

---

## Add SSH keys (macOS / Linux)

_If cloning over SSH, AND/OR have write-access wish to contribute, follow these steps:_

- `mkdir .ssh`
- Copy ssh keys from protected source to ~/.ssh

  - `mv ./id_rsa ~/.ssh/`
  - `mv ./id_rsa.pub ~/.ssh/`
  - `chmod 400 ~/.ssh/*`

## Cloning this repo over SSH

_Clone anywhere you'd like. This is how I setup and manage my repos locally_

- `mkdir workspaces`
- `cd workspaces`
- `mkdir personal`
- `cd personal`
- `git clone git@github.com:philipwindeyer/dotfiles.git`
  - OR `git clone https://github.com/philipwindeyer/dotfiles.git`
