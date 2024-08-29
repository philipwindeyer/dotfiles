#!/bin/zsh

function add_to_zprofile() {
  log_message "Adding $1 to ~/.zprofile unless it already exists"
  grep -qxF "$1" ~/.zprofile || echo "$1" >> ~/.zprofile
}

function install_rosetta() {
  if [[ "$(sysctl -n machdep.cpu.brand_string)" == *'Apple'* ]]; then
    if ! arch -x86_64 /usr/bin/true 2> /dev/null; then
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
  if ! command -v brew &> /dev/null; then
    log_message "Installing Homebrew"
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  else
    log_message "Homebrew is already installed"
  fi

  eval "$(/opt/homebrew/bin/brew shellenv)"
}

function install_mas() {
  if ! command -v mas &> /dev/null; then
    log_message "Installing mas"
    brew install mas
  else
    log_message "mas is already installed"
  fi
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
  while IFS='' read -r LINE || [ -n "${LINE}" ]; do
    install_homebrew_cask ${LINE}
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
  while IFS='' read -r LINE || [ -n "${LINE}" ]; do
    install_homebrew_package ${LINE}
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
  while IFS='' read -r LINE || [ -n "${LINE}" ]; do
    install_mas_app "${LINE}"
  done <$1
}

function install_nvm() {
  NVM_VERSION=$(curl --silent "https://api.github.com/repos/nvm-sh/nvm/releases/latest" | jq -r '.tag_name')
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/$NVM_VERSION/install.sh | bash
}

function install_nvm_node_versions() {
  while IFS='' read -r LINE || [ -n "${LINE}" ]; do
    nvm install ${LINE}
  done <$1
}
