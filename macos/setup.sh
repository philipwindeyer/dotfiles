#!/bin/zsh

SCRIPT_DIR="$(dirname $0:a)"
source $SCRIPT_DIR/../shared/lib/setup-fns.sh
source $SCRIPT_DIR/lib/setup-fns.sh

log_heading "Apple macOS 14 Sonoma Setup Script"

install_software_updates
install_xcode_command_line_tools

log_heading "Setting up dotfiles"
add_to_zshrc "source $SCRIPT_DIR/dotfiles/zshrc"
add_to_zshrc "source $SCRIPT_DIR/dotfiles/aliases"
add_to_zshrc "source $SCRIPT_DIR/../shared/dotfiles/aliases"
add_to_zshrc "source $SCRIPT_DIR/../shared/dotfiles/bashrc"
add_to_vimrc "source $SCRIPT_DIR/../shared/dotfiles/vimrc"

install_rosetta
install_homebrew
install_mas

install_homebrew_taps $SCRIPT_DIR/lib/brew-taps.txt
install_homebrew_packages $SCRIPT_DIR/lib/brew-pkgs.txt
install_homebrew_casks $SCRIPT_DIR/lib/brew-casks.txt
install_mas_apps $SCRIPT_DIR/lib/mas-apps.txt

add_git_completion
install_asdf
install_nvm

reload_env

add_asdf_plugins $SCRIPT_DIR/../shared/lib/asdf-plugins.txt
install_asdf_packages $SCRIPT_DIR/lib/asdf-pkgs.txt
set_asdf_global_versions $SCRIPT_DIR/lib/asdf-globals.txt

install_nvm_node_versions $SCRIPT_DIR/lib/nvm-node-versions.txt

configure_git
create_directories

# TODO: Uncomment and invoke these fns once confirmed to be functioning correctly
# configure_dock
# set_dock_apps $SCRIPT_DIR/lib/dock-apps.txt #TODO: confirm the final apps I'd like to list here once tested and working
# configure_finder
# configure_macos_settings

echo "Done ✨"
