#!/bin/bash

function log_heading() {
  echo -e "\n=================================================="
  echo "  $@"
  echo -e "==================================================\n"
}

function log_message() {
  echo -e "  $@\n"
}

function reload_env() {
  if [ -f ~/.bashrc ]; then
    source ~/.bashrc
  fi

  if [ -f ~/.zprofile ]; then
    source ~/.zprofile
  fi
}

function install_pip_packages() {
  while IFS='' read -r LINE || [ -n "${LINE}" ]; do
    pip install ${LINE} --user
  done <$1
}

function add_git_completion() {
  curl https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.bash -o ~/.git-completion.bash
  curl https://raw.githubusercontent.com/git/git/master/contrib/completion/git-prompt.sh -o ~/.git-prompt.sh

  chmod +x ~/.git-completion.bash
  chmod +x ~/.git-prompt.sh

  if [ -n "$ZSH_VERSION" ]; then
    curl https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.zsh -o ~/.git-completion.zsh
    chmod +x ~/.git-completion.zsh
  fi
}

function install_asdf() {
  if [ -d ~/.asdf ]; then
    log_message "asdf is already installed"
  else
    ASDF_VERSION_TO_INSTALL=$(curl --silent "https://api.github.com/repos/asdf-vm/asdf/releases/latest" | jq -r '.tag_name')
    log_message "Installing asdf ($ASDF_VERSION_TO_INSTALL)"
    git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch $ASDF_VERSION_TO_INSTALL
    log_message "Note: you will neeed to restart your shell and re-run this to complete the installation the first tim"
  fi
}

function add_asdf_plugin() {
  asdf update
  asdf plugin update --all
  asdf plugin add $1
}

function add_asdf_plugins() {
  while IFS='' read -r LINE || [ -n "${LINE}" ]; do
    add_asdf_plugin ${LINE}
  done <$1
}

function install_asdf_package() {
  asdf update
  asdf install $1 $2
}

function install_asdf_packages() {
  while IFS='' read -r LINE || [ -n "${LINE}" ]; do
    PACKAGE=$(echo ${LINE} | cut -d ' ' -f 1)
    VERSION=$(echo ${LINE} | cut -d ' ' -f 2)
    install_asdf_package ${PACKAGE} ${VERSION}
  done <$1
}

function set_asdf_global_versions() {
  while IFS='' read -r LINE || [ -n "${LINE}" ]; do
    PACKAGE=$(echo ${LINE} | cut -d ' ' -f 1)
    VERSION=$(echo ${LINE} | cut -d ' ' -f 2)
    asdf global ${PACKAGE} ${VERSION}
  done <$1
}

function configure_git() {
  git config --global core.editor "vim"
}