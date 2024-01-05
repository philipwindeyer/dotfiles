# dotfiles

# macOS

TODO

# Linux Mint

TODO

# Windows 11

## Getting started (first time setup)

- Open Terminal app (defaults to PowerShell) or PowerShell session as **Administator**
- `winget install -s winget --accept-package-agreements Git.Git` (first run will prompt you to accept terms and conditions manually)
- `cd ~`
- `mkdir .ssh`
- Copy ssh keys from protected source to ~/.ssh
  - `mv .\id_rsa ~\.ssh\`
  - `mv .\id_rsa.pub ~\.ssh\`
- `cd ~`
- `mkdir workspaces`
- `cd workspaces`
- `mkdir personal`
- `cd personal`
- `git clone git@github.com:philipwindeyer/dotfiles.git`
- `cd ~/workspaces/personal/dotfiles/windows`
- `./setup.ps1`
- Note: the first run will take quite some time. Allow for an hour or more, but keep an eye out for any unexpected prompts.

## Information

- `windows/setup.ps1` is written to be one of the first, and only things to run on my Windows 11 machine in that it installs and configures almost everything I need
  - setup.ps1 can be run anytime. It only updates or makes changes when necessary
- `windows/lib` contains shared functions and vars, and helper files that may be copied to local directories where they can be executed
- `windows/powershell` contains PowerShell profile, aliases (like my git aliases), etc. setup.ps1 sources `windows/powershell/config.ps1` from $PROFILE

### TODO

- Migrate remaining steps from Notion (including Magic Keyboard/Trackpad driver installation, kinto.sh, manual pkgs, windows config, notes, etc)
