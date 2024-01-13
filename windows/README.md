# Microsoft Windows 11 Setup (for my desktop)

## Manual one-time steps

_Note: This assumes you're running a fresh Windows 11 installation on a device with an ASUS motherboard and GeForce graphics card. It's also specific to my setup (e.g. I use an Apple keyboard and trackpad as I go between my desktop and MacBook)_

Once drive is wiped, Windows 11 Pro is installed from scratch, and the initial setup is complete;

- Activate Windows, if required (see password manager for Kinguin OEM key in my case); OR
- Sign in to Microsoft during set-up and Windows will activate automatically
- Bluetooth connect Magic Keyboard and Magic Trackpad
- Download and install the “Armoury Crate App” (i.e. the ASUS Motherboard management app)
  - You should be prompted to download and install it automatically
- Armoury Crate -> Device -> Update Center -> Update All
- Settings ->
  - Windows Update -> Check for updates
    - “Update all”
    - PLUS optional updates EXCEPT for drivers
    - _Note: IIRC the latest NVIDIA graphics drivers, and the `NVIDIA Settings` app are installed during this process_
  - System ->
    - Display -> Night light
      - Turn on
      - Strength: 85%
      - Schedule night light: on
        - 22:00 - 6:00
    - For developers -> Terminal -> Select “Windows Terminal”
    - Multi-tasking -> Snap windows
      - When I snap a window, suggest what I can snap next to it - turn off
      - Show my snapped windows when I hover over taskbar apps - turn off (turns off window grouping)
    - Storage -> Advanced storage settings -> Back-up options
      - Make sure OneDrive backup and sync is on
    - Apps -> Advanced app settings ->
      - App execution aliases ->
        - App Installer python.exe -> OFF
        - App Installer python3.exe -> OFF
    - Accessibility -> Mouse pointer and touch
      - Change to black mouse cursor
  - Control Panel -> Back up and Restore
    - Ensure automatic backups for Storage (D:) are on
- Microsoft Store ->
  - Profile -> Settings -> App updates -> **Turn on**
  - Library -> **Get Updates** (ensure all apps are up to date)
- Open a File Explorer -> View -> Show ->
  - File name extensions -> Turn on
  - Hidden items -> Turn on
- Install Apple Magic Keyboard 2 Driver
  - Source: https://github.com/AbsentForeskin/Apple-Input-Device-Drivers-Windows-10-11
  - Navigate to Apple-Input-Device-Drivers-Windows-10-11\AppleKeyboardMagic2
  - Right click “Keymagic2.inf” and then “Install”
  - Note: This installs the official (repackaged) Apple Boot Camp Keyboard driver, and ensure the volume, media, brightness, and fn keys function as expected
  - Note: mac-precision-touchpad is installed automatically when setup.ps1 is executed. This installs current, community maintained drivers for the Magic Trackpad and integrates with Windows 11 native touchpad settings
- Instal Kinto.sh
  - Homepage: https://kinto.sh/
  - Source: https://github.com/rbreaves/kinto#how-to-install-windows
- Install the following manually (as they are not packaged managed as of 11/11/23)
  - **These can be factored in to the automated script, as prompts (first checking if already installed)**
  - Razer 7.1 Surround Sound (for my headphones)
    - Source: https://www.razer.com/au-en/71-surround-sound
    - Note: Activation key is in password manager
- Open “Phone Link” on Windows
  - Then “Link to Windows” on iOS, and follow the instructions to pair and link my phone

## Automated setup

Assuming you cloned this repo into a desired location locally already;

- Open Terminal app (defaults to PowerShell) or PowerShell session as **Administator**, unless already open
- `cd ~/path/to/dotfiles/windows` (i.e. `cd ~/workspaces/personal/dotfiles/windows`)

- `./setup.ps1`

_Note: the first run will take quite some time. Allow for an hour or more, but keep an eye out for any unexpected prompts._

## Information

- `windows/setup.ps1` is written to be one of the first, and only things to run on my Windows 11 machine in that it installs and configures almost everything I need
  - setup.ps1 can be run anytime. It only updates or makes changes when necessary
- `windows/lib` contains shared functions and vars, and helper files that may be copied to local directories where they can be executed
- `windows/powershell` contains PowerShell profile, aliases (like my git aliases), etc. setup.ps1 sources `windows/powershell/config.ps1` from $PROFILE

## TODO

- Keyboard and trackpad configuration
  - [ ] Add F3 → Expose / “Mission Control” / Show all windows and workspaces
  - [ ] Add F4 → Start menu (i.e. “app launcher”)
  - [ ] Cmd+Tilda shortcut to cycle between common app windows
  - [ ] Figure out how to map Cmd+Shift+F3 to show or hide desktop (currently have Cmd+F3 working via Kinto default setup)
  - Perhaps remap or assign the above with PowerToys instead of AutoHotKey/Kinto
    - https://www.lifewire.com/use-magic-keyboard-on-windows-pc-5197318
    - https://arschles.com/blog/powertoys-mac/
- Keyboard and trackpad configuration
  - [ ] Add 2 finger swipe from right of trackpad shortcut to open notification centre
- [ ] Add Git Bash to Windows Terminal (after Git installed): https://www.timschaeps.be/post/adding-git-bash-to-windows-terminal/
- [ ] Install ZSH
  - https://walterteng.com/using-zsh-on-windows#replace-git-bash-with-zsh
  - https://dev.to/equiman/zsh-on-windows-without-wsl-4ah9
- [ ] Figure out how to automate pinning apps to the taskbar

  - File Explorer
  - Chrome
  - Notion
  - Gmail
  - GCalendar
  - Terminal
  - VS Code
  - Sublime
  - ClickUp
  - Excalidraw
  - Spotify
  - YT Music
  - Poolsuite.fm
  - Phone Link
  - WhatsApp
  - FB Messenger
  - Slack
  - KeeWeb
  - Settings

- [ ] See what else I can automate from the above, i.e.;
  - [Kinto.sh](http://Kinto.sh) installation
  - Magic Keyboard driver installation
  - Fetching the Razer SS app and triggering the installation
  - File Explorer configuration
  - Windows Settings automation
  - Microsoft Store configuration

## Notes

- I don't use "Dynamic Lock" with my phone (i.e. auto lock when leaving the vicinity based on my phone's proximity) as it caused issues with my machine and disrupted other Bluetooth connections
  - Methods for attempting to have it function correctly (all failed in my case):
    - https://allthings.how/how-to-fix-the-dynamic-lock-not-working-issue-in-windows-11/
    - https://www.digitbin.com/fix-dynamic-lock-not-working-in-windows-11/
