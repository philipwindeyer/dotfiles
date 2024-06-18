#!/bin/bash

SCRIPT_DIR="$(dirname "$(readlink -f "$0")")"
. $SCRIPT_DIR/../shared/lib/setup-fns.sh
. $SCRIPT_DIR/../shared/lib/debian-fns.sh
. $SCRIPT_DIR/lib/setup-fns.sh

log_heading "Linux Mint (Cinnamon Edition) Setup Script"
log_message "Note: this is a work in progress (see notes and TODOs within)"

sudo apt update -y
sudo apt upgrade -y

log_heading "Adding APT repositories"
add_apt_repos $SCRIPT_DIR/lib/apt-repos.txt

log_heading "Installing APT packages"
install_apt_packages $SCRIPT_DIR/lib/apt-pkgs.txt

log_heading "Installing pip packages"
install_pip_packages $SCRIPT_DIR/lib/pip-pkgs.txt

log_heading "Installing Flatpaks packages"
install_flatpaks $SCRIPT_DIR/lib/flatpaks.txt

add_git_completion
install_asdf

add_to_bashrc ". $SCRIPT_DIR/../shared/dotfiles/bash_aliases.sh"
add_to_bashrc ". $SCRIPT_DIR/../shared/dotfiles/bashrc.sh"

reload_env

add_asdf_plugins $SCRIPT_DIR/lib/asdf-plugins.txt
install_asdf_packages $SCRIPT_DIR/lib/asdf-pkgs.txt
set_asdf_global_versions $SCRIPT_DIR/lib/asdf-globals.txt

configure_git

if [ ! -d $HOME/workspaces ]; then
  mkdir $HOME/workspaces
else
  log_message "workspaces directory already exists"
fi

install_toshy

# TODO organise and complete all of the below

# # Install Keeweb
# VER=$(curl -s https://api.github.com/repos/keeweb/keeweb/releases/latest|grep tag_name|cut -d '"' -f 4|sed 's/v//')
# cd ~/Downloads
# wget https://github.com/keeweb/keeweb/releases/download/v${VER}/KeeWeb-${VER}.linux.x64.deb
# sudo apt install libdbusmenu-gtk4 gconf2-common libappindicator1 libgconf-2-4
# sudo apt install -f ./KeeWeb-${VER}.linux.x64.deb
# rm ./KeeWeb-${VER}.linux.x64.deb
# cd ~/
