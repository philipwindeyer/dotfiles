#!/bin/zsh

cd "$(dirname "${BASH_SOURCE[0]}")"

source macos/macos-fns.sh
source common/common-fns.sh

readonly TAPS=common/taps.txt
readonly FORMULAE=common/formulae.txt
readonly CASKS=macos/casks.txt
readonly APPS=macos/apps.txt
readonly ASDF_PLUGINS=common/asdf-plugins.txt
readonly ASDF_LIBS=common/asdf-libs.txt
readonly YARN_PKGS=common/yarn-global-pkgs.txt
readonly DOCK_APPS=macos/dock-apps.txt

sudo -v
while true; do
  sudo -n true
  sleep 60
  kill -0 "$$" || exit
done 2>/dev/null &

# TODO better logging using tee

install_dev_tools
install_system_updates
manage_homebrew
manage_mas
manage_asdf
add_taps
install_formulae
install_casks
install_apps
add_asdf_plugins
install_asdf_libs
install_yarn_global_pkgs
dock_settings
create_dirs
finder_settings
global_settings
zshrc
