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
- Sign in to Microsoft OneDrive (via the taskbar icon or entering the OneDrive directory)
  - In "Sync & Backup", click "manage backups" and de-select all folders (especially "Documents")
  - In "Account", "Unlink this PC"
- Navigate to your home directory
  For `Desktop`, `Documents`, `Pictures`, `Music`, and `Videos`;
  - For each directory, right-click -> Properties -> Location -> `Restore Default`, then Apply -> OK
  - _Note_: This must be done before the automated setup script uninstall OneDrive. Windows 11 forces you into using OneDrive synchronised home directory sub directories on first install. This ensures that these directories do not break or become unwritable once OneDrive has been removed
- Install PowerShell 7+
  - Microsoft Store -> search "PowerShell" and install (note: PowerShell on msstore is different to the stock "Windows PowerShell")
- Install `winget` (AKA "App Installer") update [from here](https://apps.microsoft.com/detail/9NBLGGH4NNS1) ([source](https://learn.microsoft.com/en-us/windows/package-manager/winget/))
- Settings ->
  - Windows Update -> Check for updates
    - “Update all”
    - PLUS optional updates EXCEPT for drivers
    - _Note: IIRC the current NVIDIA graphics driver Microsoft offers (which may not be the most recent), and the `NVIDIA Settings` app are installed during this process_
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
    - Power -> Screen and sleep
      - When plugged in, turn off my screen after -> 15 minutes
      - When plugged in, put my device to sleep after -> Never
  - Apps -> Advanced app settings ->
    - App execution aliases ->
      - App Installer python.exe -> OFF
      - App Installer python3.exe -> OFF
  - Accessibility -> Mouse pointer and touch
    - Change to black mouse cursor
  - Privacy & security -> Activity history
    - Store my activity history on this device -> OFF
    - (Existing history can also be cleared here)
- Control Panel -> Back up and Restore
  - Ensure automatic backups for Storage (D:) are on
- Microsoft Store ->
  - Profile -> Settings -> App updates -> **Turn on**
  - Library -> **Get Updates** (ensure all apps are up to date)
- Open a File Explorer -> View -> Show ->
  - File name extensions -> Turn on
  - Hidden items -> Turn on
- Install the following manually (as they are not packaged managed as of 11/11/23)
  - **These can be factored in to the automated script, as prompts (first checking if already installed)**
  - Razer 7.1 Surround Sound (for my headphones)
    - Source: https://www.razer.com/au-en/71-surround-sound
    - Note: Activation key is in password manager
  - ClickUp
    - Source: https://clickup.com/download
- View advanced system settings -> Start-up and Recovery -> System failure
  - Write an event to the system log -> ON
  - Automatically restart -> OFF
  - Write debugging information -> Complete memory dump
- Control Panel -> Power Options -> Choose what the power buttons do ->
  - Turn on fast startup -> OFF
- Edit group policy (run from Start)
  - Computer Configuration -> Administrative Templates -> Windows Components -> Windows PowerShell ->
    - Turn on Script Execution - double-click it
      - Turn on Script Execution: `Enabled`
      - Execution Policy -> `Allow local scripts and remote signed scripts`
- Restart once all complete

## Automated setup

Assuming you cloned this repo into a desired location locally already;

- Open Terminal app (defaults to PowerShell) or PowerShell session as **Administator**, unless already open
- `cd ~/path/to/dotfiles/windows` (i.e. `cd ~/workspaces/personal/dotfiles/windows`)

- `./setup.ps1`

_Note: the first run will take quite some time. Allow for an hour or more, but keep an eye out for any unexpected prompts._

- Restart (if required)
- Open a WSL terminal (if first time running, follow the setup prompts)
- navigate to cd /mnt/c/Users/<your-windows-home-dir>/workspaces/dotfiles/windows
- `./setup-wsl.sh`

_Note: this is still a WIP and may require multiple executions (and reboots during first installation) for it to complete._

## Pin Apps to Panel (taskbar)

- File Explorer
- Chrome
- Edge
- Notion
- Gmail
- GCalendar
- JungleCat Email (Ionos)
- Terminal
- VS Code
- Sublime
- ClickUp
- Excalidraw
- Spotify
- YT Music
- Poolsuite.fm
- SoundCloud
- WhatsApp
- FB Messenger
- Signal
- Slack
- KeeWeb
- Settings
- Google Contacts

## Information

- `windows/setup.ps1` is written to be one of the first, and only things to run on my Windows 11 machine in that it installs and configures almost everything I need
  - setup.ps1 can be run anytime. It only updates or makes changes when necessary
- `windows/lib` contains shared functions and vars, and helper files that may be copied to local directories where they can be executed
- `windows/powershell` contains PowerShell profile, aliases (like my git aliases), etc. $PROFILE sources `windows/powershell/config.ps1` and `windows/powershell/aliases.ps1`
- `windows/setup-wsl.sh` is written to setup a WSL environment with my bare minimum for developing in a _nix environemnt_
- `windows/wsl` contains a WSL-specific bash profile, aliases
- `shared/dotfiles` contains bash profile (`bashrc.sh`) and bash aliases (`bash_aliases.sh`)
- `shared/lib` contains shared functions and vars common across all my \*nix environments

## TODO

- Keyboard and trackpad configuration
  - [ ] Add F3 → Expose / “Mission Control” / Show all windows and workspaces
  - [ ] Add F4 → Start menu (i.e. “app launcher”)
  - [ ] Cmd+Tilda shortcut to cycle between common app windows
  - [ ] Figure out how to map Cmd+Shift+F3 to show or hide desktop (currently have Cmd+F3 working via Kinto default setup)
  - Perhaps remap or assign the above with PowerToys instead of AutoHotKey/Kinto
    - https://www.lifewire.com/use-magic-keyboard-on-windows-pc-5197318
    - https://arschles.com/blog/powertoys-mac/
  - [ ] Add 2 finger swipe from right of trackpad shortcut to open notification centre
- [ ] See what else I can automate from the above, i.e.;
  - File Explorer configuration
  - Windows Settings automation
  - Microsoft Store configuration
- [ ] Figure out best way to configure and maintain automatic backups
- [ ] Trigger Windows "clean up, and the new "optimisation" features in Windows 11

## Notes

### Maintenance

In the event of an issue with machine, in Powershell, run:

```
dism /online /cleanup-image /restorehealth
sfc /scannow
chkdsk /f
```

For further ways to diagnose, see the [debugging](#debugging) section.

### Dynamic Lock

- I don't use "Dynamic Lock" with my phone (i.e. auto lock when leaving the vicinity based on my phone's proximity) as it caused issues with my machine and disrupted other Bluetooth connections
  - Methods for attempting to have it function correctly (all failed in my case):
    - https://allthings.how/how-to-fix-the-dynamic-lock-not-working-issue-in-windows-11/
    - https://www.digitbin.com/fix-dynamic-lock-not-working-in-windows-11/

### Microsoft OneDrive Complete Uninstallation

- If you intend not to use OneDrive, before running setup.ps1; sign out and "unlink this pc" unless already done so (or not signed in at all)
  - Source: https://support.microsoft.com/en-us/office/turn-off-disable-or-uninstall-onedrive-f32a17ce-3336-40fe-9c38-6efb09f944b0
- setup.ps1 uninstalls the OneDrive application and background services
- Reset "default location" for `Desktop`, `Documents`, `Pictures`, etc (from ~/<user>/OneDrive/Documents to ~/<user>/Documents)
  - Backup registry: https://support.microsoft.com/en-us/topic/how-to-back-up-and-restore-the-registry-in-windows-855140ad-e318-2a13-2829-d428a2ab0692
  - Then Follow: https://support.microsoft.com/en-gb/topic/operation-to-change-a-personal-folder-location-fails-in-windows-ffb95139-6dbb-821d-27ec-62c9aaccd720

### Preliminary PowerShell and winget upgrade

Before running the automated setup, some preliminary steps (detailed in [Manual one-time steps](#manual-one-time-steps)) must take place first.
They are;

- Install PowerShell 7+ via the Microsoft Store GUI
- Install the latest winget [from here](https://apps.microsoft.com/detail/9NBLGGH4NNS1)

The stock version of PowerShell that comes with Windows 11 is "Windows PowerShell v5" specifically, is outdated, and unmaintained but still the defacto version of PowerShell supplied with Windows 11 out of the box.
The same applies to winget (or "App Installer"). The stock version is outdated and needs to be updated before it can run

### Installing the latest NVIDIA RTX Drivers (Studio)

Latest Studio driver as of 30/1/24: https://www.nvidia.co.uk/download/driverResults.aspx/218485/en-uk
Or search for correct driver (use the Studio Driver) here: https://www.nvidia.com/download/index.aspx

Once setup above is all complete, it is wise to update the NVIDIA Graphics driver. I'd done this previously by installing the GeForce Experience app (for remote play, etc), however I started seeing BSODs regularly after installing this software and using it to update drivers.

Note: Opt for the "Studio" version of the driver, vs the "Game Ready" driver.
Game Ready = Node.js edge/latest
Studio = Nodes.js stable/LTS

### Debugging

_Note: run the tasks described in [this section](#maintenance). If they don't solve your issue, read on_

#### Disable automatic restart (i.e. enable Blue Screen)

- See [Manual one-time steps](#manual-one-time-steps) `> View advanced system settings -> Start-up and Recovery -> System failure` for settings to prevent automatic restarts and default to a good ol' bluescreen of death instead (source: https://www.youtube.com/watch?v=M5I-N3ZmSr8)

#### View shutdown logs

- Open "Event Viewer" -> Windows Logs -> System -> Filter Current Log... ->
  - Type "41,1074,6006,6605,6008" into "Includes/Excludes..." to filter by shutdown events
  - (source: https://www.partitionwizard.com/partitionmanager/random-shutdowns-on-windows-11.html#method-8:-view-shutdown-log-in-event-viewer-23278)

#### View system crash details (i.e. when blue screens occur)

- Install "BlueScreenView" unless already installed
- Run "BlueScreenView" and observe the top-most (latest) crash record
