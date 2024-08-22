# Apple macOS 14 Sonoma Setup

## Manual one-time steps

_Note: This assumes you're running a fresh or company provisioned installation of macOS on a 2020 or newer MacBook (Air or Pro) equipped with an Apple M series chip._

Once drive is wiped, macOS is installed from scratch, and the initial setup is complete;

### First-time Setup

- Ensure you have a connection to the internet established
- Follow the guided "Welcome" screen
- Run Software Update and ensure OS is up to date

### System Settings

_TODO: Add manual one-time settings steps here_

#### Trackpad

Point & Click -> Tap to click -> ON
_TODO: see if this can be scripted_

#### Displays

Night Shift... ->

- Schedule -> Sunset to Sunrise
- Color temperature -> 75%

_TODO: see if this can be scripted_

### Terminal

- Open Terminal
- Settings -> Profiles -> Homebrew -> Set as default

## Automated setup

Assuming you cloned this repo into a desired location locally already;

- Open Terminal app (defaults to zsh)
- `cd ~/path/to/dotfiles/macos` (i.e. `cd ~/workspaces/personal/dotfiles/macos`)
- `./setup.sh`

_Note: the first run will take quite some time. Allow for an hour or more, but keep an eye out for any unexpected prompts._

- Restart (if required)

_Note: this is still a WIP and may require multiple executions (and reboots during first installation) for it to complete._

## Install PWAs (via Safari "Add to Dock" button)

- Gmail

## Pin Apps to Dock (TODO: automate/script)

- TODO: add apps to dock

## TODO

- Finish setup.sh, seeking inspiration from ../linux-mint and ./deprecated
- Install Lulu https://github.com/objective-see/LuLu/ (like PortMaster)
- Add apps to dock

- To install
  - Keybase
  - Postgres
  - pgAdmin
  - Spotify
  - wget
  - Sublime
  - YouTube Music
  - Poolsuite
  - Ollama and a local coding LLM?
  - Airclap
  - VLC
  - Balena Etcher? (don't think i'll ever need it here tbh)
  - Zoom
  - Keka
  - Canva
  - Virtual box
