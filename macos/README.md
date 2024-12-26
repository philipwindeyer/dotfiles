# Apple macOS 14 Sequoia Setup

## Manual one-time steps

_Note: This assumes you're running a fresh or company provisioned installation of macOS on a 2020 or newer MacBook (Air or Pro) equipped with an Apple M series chip._

Once drive is wiped, macOS is installed from scratch, and the initial setup is complete;

### First-time Setup

- Ensure you have a connection to the internet established
- Follow the guided "Welcome" screen
- Run Software Update and ensure OS is up to date
- Open a terminal and run `sudo xcodebuild -license`
  - Agree to the terms

## Automated setup

Assuming you cloned this repo into a desired location locally already;

- Open Terminal app (defaults to zsh)
- `cd ~/path/to/dotfiles/macos` (i.e. `cd ~/workspaces/personal/dotfiles/macos`)
- `./setup.sh`

_Note: the first run will take quite some time. Allow for an hour or more, but keep an eye out for any unexpected prompts._

- Restart (if required)

_Note: this is still a WIP and may require multiple executions (and reboots during first installation) for it to complete._

## Post Installation App Configuration

### Rectangle

- Run Rectangle
- Enable Rectangle and set it to start with computer on startup
- Disable native macOS window snapping (in System Settings)

### LuLu

- Run LuLu
- You will be prompted to enable the LuLu extension in System Settings;
  - System Settings -> General -> Login Items & Extensions -> Network Extensions -> LuLu.app -> ON
- Once enabled and running, open LuLu settings -> Mode, and check "No Icon Mode"

### NordVPN

- Run NordVPN
- Login and setup as normal
- Turn on Meshnet
- Set to run on startup
