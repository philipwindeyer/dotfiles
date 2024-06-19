#!/bin/bash

SCRIPT_DIR="$(dirname "$(readlink -f "$0")")"
. $SCRIPT_DIR/../shared/lib/setup-fns.sh
. $SCRIPT_DIR/../shared/lib/debian-fns.sh
. $SCRIPT_DIR/lib/setup-fns.sh

log_heading "Linux Mint (Cinnamon Edition) Setup Script"

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

log_heading "Installing other (manual .deb) packages"
install_manual_debs $SCRIPT_DIR/lib/manual-pkgs.txt

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
install_keeweb
install_nordvpn

sudo apt autoremove -y
