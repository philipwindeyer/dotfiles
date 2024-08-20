#!/bin/zsh

function add_to_zprofile() {
  log_message "Adding $1 to ~/.zprofile unless it already exists"
  grep -qxF "$1" ~/.zprofile || echo "$1" >> ~/.zprofile
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