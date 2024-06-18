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

function install_flatpak() {
  flatpak list | grep $1 >/dev/null 2>&1

  if [ $? -eq 0 ]; then
    log_message "$1 is already installed"
  else
    log_message "Installing $1"
    flatpak install flathub $1 -y
  fi
}

function install_flatpaks() {
  while IFS='' read -r LINE || [ -n "${LINE}" ]; do
    install_flatpak ${LINE}
  done <$1
}

function install_manual_deb() {
  DEB_FILE=$(basename $1)

  if [ -z "$2" ]; then
    PACKAGE_NAME=${DEB_FILE%%[_.]*}
    PACKAGE_NAME=${PACKAGE_NAME%-*}
  else
    PACKAGE_NAME=$2
  fi

  apt list --installed 2>/dev/null | grep -i $PACKAGE_NAME >/dev/null 2>&1

  if [ $? -eq 0 ]; then
    log_message "$PACKAGE_NAME is already installed"
  else
    log_message "Installing $PACKAGE_NAME from $1"
    curl -JLO $1

    if [[ $DEB_FILE != *.deb ]]; then
      DEB_FILE=$(ls -t | grep .deb | head -1)
    fi

    sudo apt install -f ./$DEB_FILE -y
    rm ./$DEB_FILE
  fi
}

function install_manual_debs() {
  while IFS='' read -r LINE || [ -n "${LINE}" ]; do
    install_manual_deb ${LINE}
  done <$1
}

function add_to_bashrc() {
  log_message "Adding $1 to ~/.bashrc unless it already exists"
  grep -qxF "$1" ~/.bashrc || echo "$1" >> ~/.bashrc
}
