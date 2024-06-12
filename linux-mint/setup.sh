#!/bin/bash

# sudo apt upgrade
# sudo apt install git
# 0d -/Downloads
# git clone https://github.com/ RedbearAK/ toshy.git
# cd in, chmod +x, then run install PRINT MESSAGE STATING REBOOT REQUIRED
# Open "Configure..." from LM Menu right-click (i.e. right-click the LM menu in bottom right)
# Menu Panel > Behaviour -> Keyboard shortcut to open and close the menu ->
# Click one and set as Cmd+Space (will render as Ctrl+Escape due to Toshy remapping)
# https://github.com/philipwindeyer/dotfiles
# #sudo apt install libdbusmenu-gtk4 gconf2-common libappindicatori libgconf-2-4

# # Install kinto.sh (note: can't currently remap Cmd+Space; set to Cmd+Shift+Space for now)
# /bin/bash -c "$(wget -qO- https://raw.githubusercontent.com/rbreaves/kinto/HEAD/install/linux.sh || curl -fsSL https://raw.githubusercontent.com/rbreaves/kinto/HEAD/install/linux.sh)"

flatpak install -y com.google.Chrome
flatpak install -y com.visualstudio.code

# Install GDrive (https://github.com/astrada/google-drive-ocamlfuse)
sudo add-apt-repository ppa:alessandro-strada/ppa
sudo apt update
sudo apt install google-drive-ocamlfuse
google-drive-ocamlfuse
# Await auth token exhange
mkdir ~/GoogleDrive
google-drive-ocamlfuse ~/GoogleDrive

# Install Keeweb
VER=$(curl -s https://api.github.com/repos/keeweb/keeweb/releases/latest|grep tag_name|cut -d '"' -f 4|sed 's/v//')
cd ~/Downloads
wget https://github.com/keeweb/keeweb/releases/download/v${VER}/KeeWeb-${VER}.linux.x64.deb
sudo apt install libdbusmenu-gtk4 gconf2-common libappindicator1 libgconf-2-4
sudo apt install -f ./KeeWeb-${VER}.linux.x64.deb
rm ./KeeWeb-${VER}.linux.x64.deb
cd ~/
# Note: to run, use this: `keeweb --in-process-gpu` (TODO: figure out how to update flags for running from cinnamon)


# Install GitHub CLI (note will have to do this after grabbing SSH files, and after logging in to Github via browser)
type -p curl >/dev/null || (sudo apt update && sudo apt install curl -y)
curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg \
&& sudo chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg \
&& echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null \
&& sudo apt update \
&& sudo apt install gh -y

sudo apt install steam

