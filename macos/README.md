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

### Abacus CodeLLM (27/12/24)

There is no homebrew formula for CodeLLM yet, so download it from https://codellm.abacus.ai/ and install manually

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

### AppCleaner

- Run AppCleaner
- Open Preferences
- Turn on SmartDelete

### Magic Switch

Used to toggle Magic Keyboard and Magic Mouse between two Macs

- Install [Magic Switch](https://www.magic-switch.com/)
  - Note: If you've purchased a license already, you ought to have kept the original app downloaded provided to you
  - I keep mine at ~/<cloud-storage>/Apps (distributed as MagicSwitch.dmg)

### PWA Installation (via Brave Browser)

- Open Brave Browser
- Navigate to each app you'd like to install
- Sign in first if required
- Click "Install" if available, or Settings -> Save and Share -> "Install page as app..."

These are the PWA I install:
- Gmail (https://mail.google.com)
- Google Calendar (https://calendar.google.com)
- Google Contacts (https://contacts.google.com/)
- Abacus ChatLLM (https://apps.abacus.ai/chatllm)
- Ionos Mail (https://email.ionos.co.uk)

### "Missing" App Store (mas) Apps

As of 22/08/2025, MAS [cannot install iOS/iPadOS apps](https://github.com/mas-cli/mas?tab=readme-ov-file#-ios--ipados-apps) though they do appear in search.

These apps (in [mas-app.txt](lib/mas-apps.txt)) need to be installed manually via the Mac App Store:

- Frollo - Feel good about money (ID 1179563005)
- TP-Link Tapo (ID 1472718009)
- ING Australia Banking (ID 427100193)
- Microsoft Copilot (ID 6472538445)
