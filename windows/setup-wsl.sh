#!/bin/bash

SCRIPT_DIR="$(dirname "$(readlink -f "$0")")"
. $SCRIPT_DIR/../shared/lib/setup-fns.sh

log_heading "WSL2 (Ubuntu) Setup Script"
log_message "Note: this is a work in progress (see notes and TODOs within)"

sudo apt update -y
sudo apt upgrade -y

log_heading "Installing APT packages"
install_apt_packages $SCRIPT_DIR/lib/apt-pkgs.txt

log_heading "Installing pip packages"
install_pip_packages $SCRIPT_DIR/lib/wsl-pip-pkgs.txt

add_git_completion
install_asdf

add_to_bashrc ". $SCRIPT_DIR/../shared/dotfiles/bash_aliases.sh"
add_to_bashrc ". $SCRIPT_DIR/../shared/dotfiles/bashrc.sh"
add_to_bashrc ". $SCRIPT_DIR/wsl/bashrc.sh"

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

git config --global core.editor "vim"

if [ ! -d $WIN_HOME/workspaces ]; then
  mkdir $WIN_HOME/workspaces
else
  echo "Windows workspaces directory already exists"
fi

if [ ! -e "$HOME/workspaces" ]; then
  ln -s $WIN_HOME/workspaces $HOME/workspaces
else
  echo "~/workspaces symlink already exists"
fi

if [ ! -e "$HOME/Downloads" ]; then
  ln -s $WIN_HOME/Downloads $HOME/Downloads
else
  echo "~/Downloads symlink already exists"
fi

if [ ! -e "$HOME/Desktop" ]; then
  ln -s $WIN_HOME/Desktop $HOME/Desktop
else
  echo "~/Desktop symlink already exists"
fi

if [ ! -d ~/.ssh ]; then
  mkdir ~/.ssh
fi

echo "copy $WIN_HOME/.ssh to $HOME/.ssh"
cp -Rn $WIN_HOME/.ssh/* ~/.ssh/
chmod -R 400 ~/.ssh/*
KNOWN_HOSTS_FILE=~/.ssh/known_hosts
if [ -f "$KNOWN_HOSTS_FILE" ]; then
  chmod 600 "$KNOWN_HOSTS_FILE"
fi

echo "Ensure mysql is running"
sudo service mysql status
