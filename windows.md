Set up on my Windows machine (i.e. gaming rig) requires some initial manual steps before package managed apps etc can be installed.

## Installing Windows

- Use the "Create Installation Media" tool on actual machine (assuming Windows already installed and running) to create bootable USB drive
  - https://www.microsoft.com/en-us/software-download/windows10
  - If not building from origin machine, or on another OS, download the ISO and find an appropriate tool to create a USB installer
- Install Windows
- Connect to Network
- Sign in to Microsoft Account, etc

## Installing Drivers

- Install NVIDIA Settings / NVIDIA Control Panel
  - You should be prompted to automatically as Windows discovers drivers etc

- Install Armoury Crate (ASUS MoBo control panel)
  - You should be prompted to automatically as Windows discovers drivers etc

## Installing Dependencies

- Install Chocolatey (for package managed apps)
  - https://chocolatey.org/install

## Installing Google Drive (aka "Backup and Sync)
### To access shared/sync'd files

- Start a PowerShell session as "Administrator"
- Run `choco install -y google-backup-and-sync`
- Start Backup and Sync, sign in and sync Google Drive

## Preliminary set up steps

- Start a PowerShell session as "Administrator"
- `choco install -y git`
- `cd ~`
- `mkdir workspaces`
- `cd workspaces`
- `git clone https://github.com/philipwindeyer/dotfiles.git`

 ## "Automated" setup/update script

 


Steps:


- Download, run, and put in "Startup" folder, the macOS key bindings: https://github.com/stroebjo/autohotkey-windows-mac-keyboard
  - After chocolatey installed, installation of git, then automatically running this; maybe as shortcut pointing to dotfiles project - could script the entire setup process
  - Or maybe add my own extra ones too;
    - Notably when bouncing around text, "opt+direction" should bounce between the starts/ends of word
    - Opt+Shift instead of Ctrl+Shift to highlight text
    - Cmd+Left/Right to get to start or end of line
    - Cmd+R for reload in Chrome
  OR Just figure out how to cp in Windows, and cp `windows\MacKeyboard - Shortcut.lnk C:\Users\phili\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup`

- Install Google Backup and Sync, and set up (so I have access to KeePass DB)
  - Install Google Backup and Sync `choco install -y google-backup-and-sync`
  - Set up and sync Google Drive

- Create a .bashrc file in my home directory (as per https://stackoverflow.com/questions/37104273/how-to-set-aliases-in-the-git-bash-for-windows)
  - Except, is there a way in PowerShell to check if file exists && if "source ~/workspaces/dotfiles" is a line in there?
  - and if not `echo "source=~/workspaces/dotfiles/.zshrc"> .bashrc` if that's even possible

  With all these pks installs before, can i auto yes? i.e. `choco install <...> -y`?
- Install Mac Precision Touchpad: `choco install mac-precision-touchpad` (https://github.com/imbushuo/mac-precision-touchpad)
- Install AutoHotKey `choco install autohotkey`
- Start the MacKeyboard AHK shortcut in start menu (to we can start using mac bindings!)
- Install Keeweb `choco install keeweb`

- Install Visual Studio Code `choco install visualstudiocode`
- Install Chrome `choco install googlechrome`
- Install Evernote `choco install evernote`
- Install Steam `choco install steam`
- Install Origin `choco install -y origin`
- Install Epic `choco install epicgameslauncher`
- Install Discord `choco install -y discord`
- Install WhatsApp `choco install -y whatsapp`
- Install Facebook Messenger (via Windows Store - is there a tool similar to MAS to automate this?)
- Install Windows Terminal `choco install -y microsoft-windows-terminal`