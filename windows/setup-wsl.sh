#!/bin/bash

SCRIPT_DIR="$(dirname "$(readlink -f "$0")")"
. $SCRIPT_DIR/lib/setup-fns.sh

sudo apt update -y
sudo apt upgrade -y

install_apt_package "mysql-server"
install_apt_package "jq"

install_apt_package build-essential
install_apt_package libxml2
install_apt_package libssl-dev
install_apt_package libffi-dev
install_apt_package libffi8
install_apt_package libyaml-dev
install_apt_package libreadline-dev
install_apt_package checkinstall
install_apt_package zlib1g-dev
install_apt_package net-tools

add_to_bashrc ". $SCRIPT_DIR/wsl/bash_aliases.sh"
add_to_bashrc ". $SCRIPT_DIR/wsl/bashrc.sh"

install_asdf

. $HOME/.bashrc

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

WIN_USER=$(powershell.exe '$env:USERNAME' | tr -d '\r')
WIN_HOME="/mnt/c/Users/$WIN_USER"

if [ ! -d $WIN_HOME/workspaces ]; then
  mkdir $WIN_HOME/workspaces
  if [ ! -e "$1" ]; then
    ln -s $WIN_HOME/workspaces ~/workspaces
  fi
else
  echo "Workspaces directory already exists"
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
