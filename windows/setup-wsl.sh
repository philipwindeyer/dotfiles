#!/bin/bash

SCRIPT_DIR="$(dirname "$(readlink -f "$0")")"
source $SCRIPT_DIR/../shared/lib/setup-fns.sh
source $SCRIPT_DIR/../shared/lib/debian-fns.sh

log_heading "WSL2 (Ubuntu) Setup Script"

sudo apt update -y
sudo apt upgrade -y

log_heading "Installing APT packages"
install_apt_packages $SCRIPT_DIR/lib/apt-pkgs.txt

log_heading "Installing pip packages"
install_pip_packages $SCRIPT_DIR/lib/wsl-pip-pkgs.txt

add_git_completion
install_asdf

add_to_bashrc "source $SCRIPT_DIR/../shared/dotfiles/aliases"
add_to_bashrc "source $SCRIPT_DIR/../shared/dotfiles/bashrc"
add_to_bashrc "source $SCRIPT_DIR/wsl/bashrc"

add_to_vimrc "source $SCRIPT_DIR/../shared/dotfiles/vimrc"

reload_env

add_asdf_plugin ruby
install_asdf_package ruby latest
install_asdf_package ruby 3.0.0
asdf shell ruby 3.0.0
asdf global ruby latest

add_asdf_plugin nodejs
install_asdf_package nodejs latest
asdf shell nodejs latest
asdf global nodejs latest

# Not working as of 20/2/24 (404 not found)
# add_asdf_plugin yarn
# install_asdf_package yarn latest
# asdf shell yarn latest
# asdf global yarn latest

# Fallback
npm install --global yarn

configure_git

if [ ! -d $WIN_HOME/workspaces ]; then
  mkdir $WIN_HOME/workspaces
else
  log_message "Windows workspaces directory already exists"
fi

if [ ! -e "$HOME/workspaces" ]; then
  ln -s $WIN_HOME/workspaces $HOME/workspaces
else
  log_message "~/workspaces symlink already exists"
fi

if [ ! -e "$HOME/Downloads" ]; then
  ln -s $WIN_HOME/Downloads $HOME/Downloads
else
  log_message "~/Downloads symlink already exists"
fi

if [ ! -e "$HOME/Desktop" ]; then
  ln -s $WIN_HOME/Desktop $HOME/Desktop
else
  log_message "$HOME/Desktop symlink already exists"
fi

if [ ! -d ~/.ssh ]; then
  mkdir ~/.ssh
fi

log_message "copy $WIN_HOME/.ssh to $HOME/.ssh"
cp -Rn $WIN_HOME/.ssh/* ~/.ssh/
chmod -R 400 ~/.ssh/*
KNOWN_HOSTS_FILE=~/.ssh/known_hosts
if [ -f "$KNOWN_HOSTS_FILE" ]; then
  chmod 600 "$KNOWN_HOSTS_FILE"
fi

log_message "Ensure mysql is running"
sudo service mysql status

echo "Done ✨"
