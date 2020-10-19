#!/bin/zsh

sudo -v
while true; do
  sudo -n true
  sleep 60
  kill -0 "$$" || exit
done 2>/dev/null &

# TODO Add a "-f" for full-install option to the script
# I.e. don't run all of the config steps unless -f specified
# AND/OR keep state in a dotfile (i.e. if never run, then run "first time install" mode)

# Add a "--work" option so the script uses the *-work.txt files for apps on work issued machine
# Add better logging using tee

function install_dev_tools() {
  xcode-select --install
}

function install_system_updates() {
  softwareupdate --install --all
}

function manage_homebrew() {
  if command -v brew &>/dev/null; then
    echo "Homebrew installed. Updating and upgrading"
    brew doctor
    brew update
    brew upgrade
    brew upgrade --cask

  else
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
  fi
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

function manage_asdf() {
  if command -v asdf &>/dev/null; then
    echo "asdf installed"

  else
    echo "Installing asdf for managed versions of JS and Ruby"
    brew install asdf
  fi
}

function add_taps() {
  while IFS='' read -r LINE || [ -n "${LINE}" ]; do
    brew tap ${LINE}
  done <./taps.txt
}

function install_formulae() {
  while IFS='' read -r LINE || [ -n "${LINE}" ]; do
    brew list ${LINE} || brew install ${LINE}
  done <./formulae.txt
}

function install_casks() {
  while IFS='' read -r LINE || [ -n "${LINE}" ]; do
    brew list --cask ${LINE} || brew cask install ${LINE}
  done <./casks.txt
}

function install_apps() {
  while IFS='' read -r LINE || [ -n "${LINE}" ]; do
    mas lucky "${LINE}"
  done <./apps.txt
}

function add_asdf_plugins() {
  while IFS='' read -r LINE || [ -n "${LINE}" ]; do
    asdf plugin add "${LINE}"
  done <./asdf-plugins.txt

  ~/.asdf/plugins/nodejs/bin/import-release-team-keyring
}

function install_asdf_libs() {
  while IFS='' read -r LINE || [ -n "${LINE}" ]; do
    local lib=$(echo $LINE | awk '{print $1}')
    local version=$(echo $LINE | awk '{print $2}')
    if [[ -z "${version// }" ]]; then version=latest; fi

    asdf install $lib $version

    local global_version=$(asdf list $lib | tail -n 1 | awk '{$1=$1};1')
    asdf global $lib $global_version
  done <./asdf-libs.txt
}

function install_yarn_global_pkgs() {
  while IFS='' read -r LINE || [ -n "${LINE}" ]; do
    local pkg=$(echo $LINE | awk '{print $1}')
    local registry=$(echo $LINE | awk '{print $2}')

    if [[ -z "${registry// }" ]]; then
      yarn global add $pkg

    else
      # "--registry" does not work with `yarn global`
      npm install -g $pkg --registry "$registry"
    fi

  done <./yarn-global-pkgs.txt
}

function dock_settings() {
  defaults write com.apple.dock autohide -bool true
  defaults write com.apple.dock mouse-over-hilite-stack -bool true
  defaults write com.apple.dock showhidden -bool true
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
  done <./dock-apps.txt

  local dirs=(
    "$HOME/"
    "$HOME/Downloads/"
  )
  
  for dir in "${dirs[@]}"; do
    defaults write com.apple.dock persistent-others -array-add "<dict><key>tile-data</key><dict><key>arrangement</key><integer>1</integer><key>displayas</key><integer>1</integer><key>file-data</key><dict><key>_CFURLString</key><string>file://$dir</string><key>_CFURLStringType</key><integer>15</integer></dict><key>showas</key><integer>2</integer></dict><key>tile-type</key><string>directory-tile</string></dict>"
  done

  killall Dock
}

function create_dirs() {
  [ ! -d ~/workspaces ] && mkdir ~/workspaces
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
  defaults write com.apple.finder AppleShowAllFiles true

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

function daemon_settings() {
  # TODO: Update to ONLY pevent iTunes from opening when "play" pressed
  # This was in to stop iTunes from opening when the "play" key was pressed, but it actually disables the media keys/controls
  launchctl unload -w /System/Library/LaunchAgents/com.apple.rcd.plist
}

function zshrc() {
  local local_zshrc=~/.zshrc
  local zshrc_config="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"/zsh/.zshrc

  if [ -f $local_zshrc ]; then
    echo ".zshrc file already exists"
    grep "source $zshrc_config" $local_zshrc >/dev/null

    if [ ! $? -eq 0 ]; then
      echo "Config not sourced in .zshrc. Adding..."
      echo "source $zshrc_config" >>$local_zshrc
    fi

  else
    echo "Adding new .zshrc file"
    touch $local_zshrc
    echo "source $zshrc_config" >>$local_zshrc
  fi
}

install_dev_tools
install_system_updates
manage_homebrew
manage_mas
manage_asdf
add_taps
install_formulae
install_casks
install_apps
add_asdf_plugins
install_asdf_libs
install_yarn_global_pkgs
dock_settings
create_dirs
finder_settings
global_settings
# daemon_settings
zshrc
