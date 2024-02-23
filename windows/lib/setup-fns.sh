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
  . $HOME/.bashrc
}

function install_asdf() {
  if [ -d ~/.asdf ]; then
    echo "asdf is already installed"
  else
    ASDF_VERSION_TO_INSTALL=$(curl --silent "https://api.github.com/repos/asdf-vm/asdf/releases/latest" | jq -r '.tag_name')
    echo "Installing asdf ($ASDF_VERSION_TO_INSTALL)"
    git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch $ASDF_VERSION_TO_INSTALL
    . $HOME/.bashrc
  fi
}

function install_openssl_1-1-1() {
  # Deprecated 20240220 - Not required if `python` or `python` alias is available
  
  # Sources
  # - https://help.dreamhost.com/hc/en-us/articles/360001435926-Installing-OpenSSL-locally-under-your-username
  # - https://askubuntu.com/questions/1399788/ruby-installation-build-failed-ubuntu-20-04-using-ruby-build-20220324#answer-1406051
  
  echo "Install OpenSSL 1.1.1"
  wget https://www.openssl.org/source/openssl-1.1.1g.tar.gz
  wget https://www.openssl.org/source/openssl-1.1.1g.tar.gz.sha256
  
  sha256sum openssl-1.1.1g.tar.gz
  cat openssl-1.1.1g.tar.gz.sha256
  tar zxvf openssl-1.1.1g.tar.gz
  cd openssl-1.1.1g
  ./config --prefix=/home/$USER/openssl --openssldir=/home/$USER/openssl no-ssl2
  make
  make test
  make install
  
  add_to_bashrc "export PATH=$HOME/openssl/bin:$PATH"
  add_to_bashrc "export LD_LIBRARY_PATH=$HOME/openssl/lib"
  add_to_bashrc "export LC_ALL=\"en_US.UTF-8\""
  add_to_bashrc "export LDFLAGS=\"-L /home/$USER/openssl/lib -Wl,-rpath,/home/$USER/openssl/lib\""
  
  cd $SCRIPT_DIR
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
