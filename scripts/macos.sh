#!/bin/zsh

cd $0:a:h

source common/common-fns.sh
source macos/macos-fns.sh

readonly TAPS=common/taps.txt
readonly FORMULAE=common/formulae.txt
readonly CASKS=macos/casks.txt
readonly APPS=macos/apps.txt
readonly ASDF_PLUGINS=common/asdf-plugins.txt
readonly ASDF_LIBS=common/asdf-libs.txt
readonly YARN_PKGS=common/yarn-global-pkgs.txt
readonly DOCK_APPS=macos/dock-apps.txt

common_setup
macos_setup
