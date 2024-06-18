#!/bin/bash

function add_apt_repos() {
  while IFS='' read -r LINE || [ -n "${LINE}" ]; do
    # TODO: add repos here - i.e. needs to do key exchange and add to sources.list.d
    # sudo add-apt-repository ${LINE} -y
    echo ${LINE}
  done <$1
}

function install_apt_package() {
  apt list $1 --installed 2>/dev/null | grep $1 >/dev/null 2>&1
  
  if [ $? -eq 0 ]; then
    log_message "$1 is already installed"
  else
    log_message "Installing $1"
    sudo apt install $1 -y
  fi
}

function install_apt_packages() {
  while IFS='' read -r LINE || [ -n "${LINE}" ]; do
    install_apt_package ${LINE}
  done <$1
}

function add_to_bashrc() {
  log_message "Adding $1 to ~/.bashrc unless it already exists"
  grep -qxF "$1" ~/.bashrc || echo "$1" >> ~/.bashrc
}
