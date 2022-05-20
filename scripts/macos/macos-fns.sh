#!/bin/zsh

osascript -e 'tell application "System Preferences" to quit'

function install_dev_tools() {
  log_all 'Install Xcode Select and Developer tools'
  xcode-select --install
}

function install_system_updates() {
  log_all 'Update macOS'
  softwareupdate --install --all
}

function manage_mas() {
  log_all 'Manage App Store cmdline installation'
  if command -v mas &>/dev/null; then
    log_info 'mas installed'

  else
    log_info 'Installing mas for App Store apps'
    brew install mas
  fi

  mas upgrade
}

function install_casks() {
  log_all 'Install Homebrew casks'
  while IFS='' read -r LINE || [ -n "${LINE}" ]; do
    brew list --cask ${LINE} || brew install --cask ${LINE}
  done <$CASKS
}

function install_apps() {
  log_all 'Install App Store apps'
  while IFS='' read -r LINE || [ -n "${LINE}" ]; do
    mas lucky "${LINE}"
  done <$APPS
}

function dock_settings() {
  log_all 'Updating dock settings'

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

  log_all 'Dock settings update complete'
}

function finder_settings() {
  log_all 'Updating finder settings'

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
  log_all 'Finder settings update complete'
}

function global_settings() {
  log_all 'Updating global settings'

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

  log_all 'Global settings update complete'
}

# Run this from main script
function macos_setup() {
  install_dev_tools
  install_system_updates
  manage_mas
  install_casks
  install_apps
  dock_settings
  finder_settings
  global_settings

  log_all 'macOS settings and apps complete'
}
