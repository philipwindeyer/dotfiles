Steps:
- Use "Create Installation Media" on actual machine (assuming Windows already installed and running) to create bootable USB drive
- Install Windows
- Sign in etc
- Install NVIDIA Settings / NVIDIA Control Panel
- Install Armoury Crate (ASUS MoBo control panel)
- Start Power Shell "as Administrator"
- Enable WSL `dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart`
- Enable Virtual Machines `dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart`
- Download (is there a wget in powershell?) https://wslstorestorage.blob.core.windows.net/wslblob/wsl_update_x64.msi (this is the kernel)
- 

- Install Chocolatey as per https://chocolatey.org/install
- Install git `choco install git`
- Checkout my dotfiles project
  - Open new (non-administrator) shell OR `cd $HOME` or whatever that is in windows land
  - `mkdir workspaces`
  - `cd workspaces`
  - `git clone https://github.com/philipwindeyer/dotfiles.git`
- Download, run, and put in "Startup" folder, the macOS key bindings: https://github.com/stroebjo/autohotkey-windows-mac-keyboard
  - After chocolatey installed, installation of git, then automatically running this; maybe as shortcut pointing to dotfiles project - could script the entire setup process
  - Or maybe add my own extra ones too;
    - Notably when bouncing around text, "opt+direction" should bounce between the starts/ends of word
    - Opt+Shift instead of Ctrl+Shift to highlight text
    - Cmd+Left/Right to get to start or end of line
    - Cmd+R for reload in Chrome
  OR Just figure out how to cp in Windows, and cp `windows\MacKeyboard - Shortcut.lnk C:\Users\phili\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup`

- Create a .bashrc file in my home directory (as per https://stackoverflow.com/questions/37104273/how-to-set-aliases-in-the-git-bash-for-windows)
  - Except, is there a way in PowerShell to check if file exists && if "source ~/workspaces/dotfiles" is a line in there?
  - and if not `echo "source=~/workspaces/dotfiles/.zshrc"> .bashrc` if that's even possible

  With all these pks installs before, can i auto yes? i.e. `choco install <...> -y`?
- Install Mac Precision Touchpad: `choco install mac-precision-touchpad` (https://github.com/imbushuo/mac-precision-touchpad)
- Install AutoHotKey `choco install autohotkey`
- Start the MacKeyboard AHK shortcut in start menu (to we can start using mac bindings!)
- Install Keeweb `choco install keeweb`
- Grab my vault from Dropbox
- Install Visual Studio Code `choco install visualstudiocode`
- Install Chrome `choco install googlechrome`
- Install Evernote `choco install evernote`
- Install Steam `choco install steam`
- Install Origin `choco install -y origin`
- Install Epic `choco install epicgameslauncher`
- Install Discord `choco install -y discord`
- Install WhatsApp `choco install -y whatsapp`
- Install Facebook Messenger (via Windows Store - is there a tool similar to MAS to automate this?)
- 