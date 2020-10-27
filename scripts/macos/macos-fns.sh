#!/bin/zsh

function install_dev_tools() {
  xcode-select --install
}

function install_system_updates() {
  softwareupdate --install --all
}

function manage_mas() {
  if command -v mas &>/dev/null; then
    echo "mas installed"

  else
    echo "Installing mas for App Store apps"
    brew install mas
  fi

  mas upgrade
}

function install_casks() {
  while IFS='' read -r LINE || [ -n "${LINE}" ]; do
    brew list --cask ${LINE} || brew cask install ${LINE}
  done <$CASKS
}

function install_apps() {
  while IFS='' read -r LINE || [ -n "${LINE}" ]; do
    mas lucky "${LINE}"
  done <$APPS
}

function dock_settings() {
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

  while IFS='' read -r LINE || [ -n "${LINE}" ]; do
    defaults write com.apple.dock persistent-apps -array-add "<dict><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>${LINE}</string><key>_CFURLStringType</key><integer>0</integer></dict></dict></dict>"
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

function finder_settings() {
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

  killAll cfprefsd
  killAll Finder
}

function global_settings() {
  defaults write NSGlobalDomain AppleShowAllExtensions -bool true
  killAll Finder

  # Resets audio out controller
  killall coreaudiod

  # Resets hostname to prevent rewrites when on other networks
  sudo scutil --set HostName "$(scutil --get LocalHostName).local"
}
