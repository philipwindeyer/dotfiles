#!/bin/bash

function install_apt_package() {
  apt list $1 --installed | grep $1 >/dev/null 2>&1
  
  if [ $? -eq 0 ]; then
    echo "$1 is already installed"
  else
    echo "Installing $1"
    sudo apt install $1 -y
  fi
}

function add_to_bashrc() {
  echo "Adding $1 to ~/.bashrc unless it already exists"
  grep -qxF "$1" ~/.bashrc || echo "$1" >> ~/.bashrc
}

function install_asdf() {
  if [ -d ~/.asdf ]; then
    echo "asdf is already installed"
  else
    ASDF_VERSION_TO_INSTALL=$(curl --silent "https://api.github.com/repos/asdf-vm/asdf/releases/latest" | jq -r '.tag_name')
    echo "Installing asdf ($ASDF_VERSION_TO_INSTALL)"
    git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch $ASDF_VERSION_TO_INSTALL
  fi
}

function add_asdf_plugin() {
  asdf update
  asdf plugin update --all
  asdf plugin add $1
}

function install_asdf_package() {
  asdf update
  asdf install $1 $2
}
