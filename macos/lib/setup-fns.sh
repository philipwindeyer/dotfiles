#!/bin/zsh

function add_to_zshrc() {
  log_message "Adding $1 to ~/.zshrc unless it already exists"
  grep -qxF "$1" ~/.zshrc || echo "$1" >>~/.zshrc
}

function install_software_updates() {
  log_heading "Installing macOS software updates"
  sudo softwareupdate --install --all
}

function install_xcode_command_line_tools() {
  log_heading "Xcode Command Line Tools"

  if ! command -v xcode-select &>/dev/null; then
    log_message "Installing Xcode Command Line Tools"
    xcode-select --install
  else
    log_message "Xcode Command Line Tools are already installed"
  fi
}

function install_rosetta() {
  log_heading "Rosetta"

  if [[ "$(sysctl -n machdep.cpu.brand_string)" == *'Apple'* ]]; then
    if ! arch -x86_64 /usr/bin/true 2>/dev/null; then
      log_message "Installing Rosetta"
      sudo softwareupdate --install-rosetta --agree-to-license
    else
      log_message "Rosetta is already installed"
    fi
  else
    log_message "Rosetta will not be installed. This is not an Apple Silicon Mac"
  fi
}

function install_homebrew() {
  log_heading "Homebrew"

  if ! command -v brew &>/dev/null; then
    log_message "Installing Homebrew"
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  else
    log_message "Homebrew is already installed"
  fi

  eval "$(/opt/homebrew/bin/brew shellenv)"

  log_message "Updating Homebrew"
  brew update
  brew upgrade
  brew cleanup
}

function install_mas() {
  log_heading "Mac App Store CLI"

  if ! command -v mas &>/dev/null; then
    log_message "Installing mas"
    brew install mas
  else
    log_message "mas is already installed"
  fi

  mas upgrade
}

function install_homebrew_taps() {
  log_heading "Adding Homebrew taps"

  while IFS='' read -r LINE || [ -n "${LINE}" ]; do
    brew tap "${LINE}"
  done <$1
}

function install_homebrew_cask() {
  brew list --cask $1 >/dev/null 2>&1

  if [ $? -eq 0 ]; then
    log_message "$1 is already installed"
  else
    log_message "Installing $1"
    brew install --cask $1
  fi
}

function install_homebrew_casks() {
  log_heading "Installing Homebrew casks"

  while IFS='' read -r LINE || [ -n "${LINE}" ]; do
    install_homebrew_cask "${LINE}"
  done <$1
}

function install_homebrew_package() {
  brew list $1 >/dev/null 2>&1

  if [ $? -eq 0 ]; then
    log_message "$1 is already installed"
  else
    log_message "Installing $1"
    brew install $1
  fi
}

function install_homebrew_packages() {
  log_heading "Installing Homebrew packages (formulae)"

  while IFS='' read -r LINE || [ -n "${LINE}" ]; do
    install_homebrew_package "${LINE}"
  done <$1
}

function install_mas_app() {
  mas list | grep -q "$1"

  if [ $? -eq 0 ]; then
    log_message "$1 is already installed"
  else
    log_message "Installing $1"
    mas lucky "$1"
  fi
}

function install_mas_apps() {
  log_heading "Installing Mac App Store apps"

  while IFS='' read -r LINE || [ -n "${LINE}" ]; do
    install_mas_app "${LINE}"
  done <$1
}

function install_web_app() {
  if [ -d "$HOME"/Applications/"$2".app ]; then
    log_message "$2 ($1) is already installed"
  else
    log_message "Installing $2 ($1)"
    osascript lib/add-to-dock.scpt "$1" "$2"
  fi
}

function install_web_apps() {
  log_heading "Installing web apps"

  while IFS=' ' read -r url name || [[ -n "$url" ]]; do
    [[ -z "$url" || "$url" =~ ^# ]] && continue
    read -r url name <<<"$(echo "$url $name" | tr -d '"')"
    read -r url name <<<"$(echo "$url $name" | tr -d "\"'")"

    install_web_app "$url" "$name"
  done <"$1"
}

function install_nvm() {
  log_heading "Node Version Manager (nvm)"

  NVM_VERSION=$(curl --silent "https://api.github.com/repos/nvm-sh/nvm/releases/latest" | jq -r '.tag_name')
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/$NVM_VERSION/install.sh | bash
}

function install_nvm_node_versions() {
  log_heading "Installing Node.js versions with nvm"

  while IFS='' read -r LINE || [ -n "${LINE}" ]; do
    nvm install "${LINE}"
  done <$1
}

function configure_dock() {
  log_heading "Configuring macOS Dock"

  # TODO: ensure these are still valid (test individually)
  defaults write com.apple.dock autohide -bool true
  defaults write com.apple.dock mouse-over-hilite-stack -bool true
  defaults write com.apple.dock showhidden -bool false
  defaults write com.apple.dock show-recents -bool false
  defaults write com.apple.dock mineffect suck
  defaults write com.apple.dock tilesize 52
  defaults write com.apple.dock orientation bottom
  defaults write com.apple.dock ResetLaunchPad -bool true

  # Dock apps/directories
  defaults write com.apple.dock persistent-apps -array
  defaults write com.apple.dock persistent-others -array

  killall Dock
}

function set_dock_apps() {
  log_heading "Setting Dock Apps"

  while IFS='' read -r LINE || [ -n "${LINE}" ]; do
    defaults write com.apple.dock persistent-apps -array-add "<dict><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>$(eval echo "${LINE}")</string><key>_CFURLStringType</key><integer>0</integer></dict></dict></dict>"
  done <$DOCK_APPS

  local dirs=(
    "$HOME/"
    "$HOME/Downloads/"
  )

  for dir in "${dirs[@]}"; do
    defaults write com.apple.dock persistent-others -array-add "<dict><key>tile-data</key><dict><key>arrangement</key><integer>1</integer><key>displayas</key><integer>1</integer><key>file-data</key><dict><key>_CFURLString</key><string>file://$dir</string><key>_CFURLStringType</key><integer>15</integer></dict><key>showas</key><integer>2</integer></dict><key>tile-type</key><string>directory-tile</string></dict>"
  done

  killall Dock
}

function configure_finder() {
  log_heading "Configuring Finder"

  # TODO: ensure these are still valid (test individually)
  defaults write com.apple.finder ShowHardDrivesOnDesktop -bool true
  defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool true
  defaults write com.apple.finder ShowMountedServersOnDesktop -bool true
  defaults write com.apple.finder ShowRemovableMediaOnDesktop -bool true

  defaults write com.apple.finder ShowStatusBar -bool true
  defaults write com.apple.finder ShowTabView -bool true
  defaults write com.apple.finder ShowPathbar -bool true
  defaults write com.apple.finder ShowToolbar -bool true
  defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"
  defaults write com.apple.finder NewWindowTarget -string "PfHm"
  defaults write com.apple.finder AppleShowAllFiles false
  defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"

  # Enable snap-to-grid for icons on the desktop and in other icon views
  /usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:arrangeBy grid" ~/Library/Preferences/com.apple.finder.plist
  /usr/libexec/PlistBuddy -c "Set :FK_StandardViewSettings:IconViewSettings:arrangeBy grid" ~/Library/Preferences/com.apple.finder.plist
  /usr/libexec/PlistBuddy -c "Set :StandardViewSettings:IconViewSettings:arrangeBy grid" ~/Library/Preferences/com.apple.finder.plist

  chflags nohidden ~/Library
  sudo chflags nohidden /Volumes

  killAll cfprefsd
  killAll Finder
}

function configure_macos_settings() {
  log_heading 'Updating global macOS settings'
  # TODO: test all of these before rolling into setup script

  defaults write NSGlobalDomain AppleShowAllExtensions -bool true

  # Disable the “Are you sure you want to open this application?” dialog
  defaults write com.apple.LaunchServices LSQuarantine -bool false

  # Resets audio out controller
  killall coreaudiod

  # Resets hostname to prevent rewrites when on other networks
  sudo scutil --set HostName "$(scutil --get LocalHostName).local"

  # Enable "Tap to click"
  defaults write com.apple.AppleMultitouchTrackpad Clicking -bool true
  sudo defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
  sudo defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
  sudo defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1

  # Date and time in Finder bar
  defaults write com.apple.menuextra.clock IsAnalog -bool false
  defaults write com.apple.menuextra.clock DateFormat -string "EEE d MMM HH:mm"

  # Battery percentage
  defaults write com.apple.menuextra.battery ShowPercent -bool true

  # Global Keyboard shortcuts
  defaults write -globalDomain NSUserKeyEquivalents -dict-add "Save as PDF\\U2026" "@\$p"
  defaults write -globalDomain NSUserKeyEquivalents -dict-add "Show Next Tab" "@~\\U2192"
  defaults write -globalDomain NSUserKeyEquivalents -dict-add "Show Previous Tab" "@~\\U2190"

  # Terminal theme
  defaults write ~/Library/Preferences/com.apple.Terminal.plist "Default Window Settings" "Homebrew"
  defaults write ~/Library/Preferences/com.apple.Terminal.plist "Startup Window Settings" "Homebrew"

  killall SystemUIServer
  sleep 2
  killAll Finder
}
