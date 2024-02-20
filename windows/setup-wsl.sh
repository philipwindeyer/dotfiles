#!/bin/bash

SCRIPT_DIR="$(dirname "$(readlink -f "$0")")"
. $SCRIPT_DIR/lib/setup-fns.sh

sudo apt update -y
sudo apt upgrade -y

install_apt_package "mysql-server"
install_apt_package "jq"

# TODO Consider removing these as most of these will be already installed, or installed during asdf installation
install_apt_package build-essential
install_apt_package libxml2
install_apt_package libssl-dev
install_apt_package libffi-dev
install_apt_package libffi8
install_apt_package libyaml-dev
install_apt_package libreadline-dev
install_apt_package checkinstall
install_apt_package zlib1g-dev


add_to_bashrc ". $SCRIPT_DIR/wsl/bash_aliases.sh"

# TODO: Consider ditching this - was only for the ruby installation. The python alias above did the trick
# install_openssl_1-1-1

install_asdf

add_to_bashrc ". $SCRIPT_DIR/wsl/bashrc.sh"
. $HOME/.bashrc

add_asdf_plugin ruby
install_asdf_package ruby latest
install_asdf_package ruby 3.0.0

asdf global ruby latest

echo "Ensure mysql is running"
sudo service mysql status