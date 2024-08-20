# Linux Mint Cinnamon Edition Setup (for my MBP)

## Manual one-time steps

_Note: This assumes you're running a fresh Linux Mint installation on a 2012-2020 Intel MacBook (Air or Pro). It's also specific to my setup (e.g. I use an Apple keyboard and trackpad as I go between my desktop and MacBook)_

Once drive is wiped, Linux Mint is installed from scratch, and the initial setup is complete;

### First-time Setup

- Ensure you have a wired network connection in place initially
  _Note: the Broadcom Inc BCM4331 802.11a/b/g/n (AirPort Extreme) driver is not available immediately post OS installation_
- Follow the guided "Welcome" screen, i.e. "First Steps"
  - Desktop Colors as you'd like
  - Set up System Snapshots (Timeshift) using rsync (in my case I set up backups to my NAS)
  - Driver Manager
    - Install `bcmwl-kernel-source`, i.e. the Broadcom Wi-Fi driver
  - Update Manager
    - Update all packages that require updates
    - Edit -> Software Sources -> Official Repositories
      - Update "Main" and "Base" to local Australian servers (AARnet is the fastest)
  - Firewall
    - Enable it

### System Settings

#### Applets

- Corner bar -> "Peek at the desktop on hover": ON
- Menu -> Panel -> Behaviour -> Keyboard shortcut to open and close the menu -> Super+Space (with toshy running this remaps to Ctrl+Escape)
  - Note: do this only AFTER `./setup.sh` has been run successfully. I.e. after toshy has been installed

#### Desktop

- Desktop Icons ->
  - Computer
  - Home
  - Trash
  - Mounted Drives

#### Gestures

- Enable Gestures
  - Swipe -> "Swipe with 3 fingers" AND "4 fingers"
    - Left: Switch to right workspace
    - Right: Switch to left workspace
    - Up: Show the workspace selector (Expo)
    - Down: Show the window selector (Scale)
  - Pinch -> "Pinch with 3 fingers" AND "4 fingers"
    - In: Show Desktop
    - Out: Show Desktop

#### Window Tiling

- Preferences -> "Maximize, instead of tile, when dragging a window to the top edge": ON

#### Online Accounts

- Sign in to online account(s)
- For each account, enable "Files"

### Web App Installation

- Open "Web Apps" app (AKA Web App Manager)
- For each app below;

  - Name appropriately
  - "Find icons online" to get the correct app icon
  - Category: N/A
  - Browser: Firefox, or Chrome after it is installed

- Install the following, using the steps above;
  - Notion: https://www.notion.so
  - Gmail: https://mail.google.com
  - Google Calendar: https://calendar.google.com
  - Google Contacts: https://contacts.google.com
  - Facebook Messenger: https://www.messenger.com
  - WhatsApp: https://web.whatsapp.com
  - Canva: https://www.canva.com/?continue_in_browser=true
  - Poolsuite FM: https://poolsuite.net
  - SoundCloud: https://soundcloud.com
  - ClickUp: https://app.clickup.com
  - Excalidraw: https://excalidraw.com
  - YT Music: https://music.youtube.com/

### Symlink Online Files

_I.e.: create concrete links to files hosted online via Online Accounts (Google Drive, OneDrive, etc)_

_Note: this is necessary for any files that are automatically updated or saved by apps that consume them, as the online accounts feature and Nautilus dynamically maps online files to local files by a different name_

- After signing in to your online account(s), for each;
- Open Nemo File Explorer, and locate the file(s) you need a symlink for
- Open a terminal
- For each file, drag the file into terminal to get the full path of that file
- Run `ln -s <path-to-hosted-file> <path-to-symlink>`
  - E.g. `ln -s /run/user/1001/gvfs/google-drive:host=gmail.com,user=old-mate/1234abcd/1234abcd ~/file.txt`

### Install Manual APT Repositories and Pkgs (that cannot be automatically installed)

#### MySQL APT Repository (for Workbench)

- Visit https://dev.mysql.com/downloads/repo/apt/ and download the latest APT repo file
- Double click in file explorer, and run through the process to add the repository

_Note: this is manual due to Oracle's dynamic links and checkboxes during the download process_

#### Zoom

- Download the correct installer via https://zoom.us/download
- Double click in file explorer, and run through the process to install it

## Automated setup

Assuming you cloned this repo into a desired location locally already;

- Open Terminal app (defaults to bash)
- `cd ~/path/to/dotfiles/linux-mint` (i.e. `cd ~/workspaces/personal/dotfiles/linux-mint`)
- `./setup.sh`

_Note: the first run will take quite some time. Allow for an hour or more, but keep an eye out for any unexpected prompts._

- Restart (if required)

_Note: this is still a WIP and may require multiple executions (and reboots during first installation) for it to complete._

## Pin Apps to Panel (taskbar)

- File Explorer
- Chrome
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

## TODO

- Automate installations from Github releases (i.e. for KeeWeb and YT Music) - e.g. github-pkgs.txt with the repo name and the <file>.deb file name pattern (with $VER in there)
- Finish Timeshift set-up to backup to NAS
- Keyboard and trackpad configuration
  - [ ] Add F3 → Expose / “Mission Control” / Show all windows and workspaces
  - [ ] Add F4 → Menu (i.e. “app launcher”)
  - [ ] Cmd+Tilda shortcut to cycle between common app windows
  - [ ] Figure out how to map Cmd+Shift+F3 to show or hide desktop
  - [ ] Add 2 finger swipe from right of trackpad shortcut to open notification centre
