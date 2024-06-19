#!/bin/bash

function install_toshy() {
  if [ ! -d $HOME/workspaces/open-source ]; then
    mkdir $HOME/workspaces/open-source
  else
    log_message "workspaces/open-source directory already exists"
  fi

  cd $HOME/workspaces/open-source
  git clone https://github.com/RedBearAK/toshy.git
  cd toshy
  git fetch && git pull
  log_message "Running ./setup_toshy.py install. You input will be required"
  ./setup_toshy.py install

  log_heading "Toshy installed!"
  log_heading "If it's your first time running ./setup.sh; reboot, then please follow the steps below for Cmd+Space setup:"
  log_message "Cmd+Space Config: Open 'Configure...' from the Linux Mint Menu (right-click the LM menu in the bottom right)"
  log_message "Menu Panel > Behaviour -> Keyboard shortcut to open and close the menu -> Click one and set as Cmd+Space"
  log_message "(will render as Ctrl+Escape due to Toshy remapping)"
}

function install_keeweb() {
  KEEWEB_VERSION=$(curl --silent "https://api.github.com/repos/keeweb/keeweb/releases/latest" | jq -r '.tag_name')
  install_manual_deb https://github.com/keeweb/keeweb/releases/download/v${KEEWEB_VERSION}/KeeWeb-${KEEWEB_VERSION}.linux.x64.deb
}

function install_nordvpn() {
  sh <(curl -sSf https://downloads.nordcdn.com/apps/linux/install.sh)
}

function install_signal() {
  wget -O- https://updates.signal.org/desktop/apt/keys.asc | gpg --dearmor > signal-desktop-keyring.gpg
  cat signal-desktop-keyring.gpg | sudo tee /usr/share/keyrings/signal-desktop-keyring.gpg > /dev/null

  echo 'deb [arch=amd64 signed-by=/usr/share/keyrings/signal-desktop-keyring.gpg] https://updates.signal.org/desktop/apt xenial main' |\
    sudo tee /etc/apt/sources.list.d/signal-xenial.list

  sudo apt update && sudo apt install signal-desktop
}

function install_youtube_music() {
  YT_VERSION=$(curl --silent "https://api.github.com/repos/ytmdesktop/ytmdesktop/releases/latest" | jq -r '.tag_name')
  install_manual_deb https://github.com/ytmdesktop/ytmdesktop/releases/download/v${YT_VERSION}/youtube-music-desktop-app_${YT_VERSION}_amd64.deb
}
