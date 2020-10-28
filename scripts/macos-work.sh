#!/bin/zsh

cd $0:a:h

source common/common-fns.sh
source macos/macos-fns.sh

readonly TAPS=macos-work/taps.txt
readonly FORMULAE=macos-work/formulae.txt
readonly CASKS=macos-work/casks.txt
readonly APPS=macos-work/apps.txt
readonly ASDF_PLUGINS=common/asdf-plugins.txt
readonly ASDF_LIBS=common/asdf-libs.txt
readonly YARN_PKGS=macos-work/yarn-global-pkgs.txt
readonly DOCK_APPS=macos-work/dock-apps.txt

common_setup
macos_setup
