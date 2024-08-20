#!/bin/zsh

SCRIPT_DIR="$(dirname $0:a)"
source $SCRIPT_DIR/../shared/lib/setup-fns.sh
source $SCRIPT_DIR/lib/setup-fns.sh

log_heading "Apple macOS 14 Sonoma Setup Script"

softwareupdate --install --all

add_to_zprofile "source $SCRIPT_DIR/dotfiles/zprofile"
add_to_zprofile "source $SCRIPT_DIR/../shared/dotfiles/aliases"
add_to_zprofile "source $SCRIPT_DIR/../shared/dotfiles/bashrc"

install_homebrew

# TODO: install taps here (if needed)

log_heading "Installing Homebrew packages (formulae)"
install_homebrew_packages $SCRIPT_DIR/lib/brew-pkgs.txt

log_heading "Installing Homebrew casks"
install_homebrew_casks $SCRIPT_DIR/lib/brew-casks.txt

# TODO: install pip packages here (if needed)

add_git_completion
install_asdf

reload_env

add_asdf_plugins $SCRIPT_DIR/../shared/lib/asdf-plugins.txt
install_asdf_packages $SCRIPT_DIR/lib/asdf-pkgs.txt
set_asdf_global_versions $SCRIPT_DIR/lib/asdf-globals.txt

configure_git

if [ ! -d $HOME/workspaces ]; then
  mkdir $HOME/workspaces
else
  log_message "workspaces directory already exists"
fi
