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
readonly NPM_PKGS=macos-work/npm-global-pkgs.txt
readonly GEMS=common/gems.txt
readonly DOCK_APPS=macos-work/dock-apps.txt
readonly NPM_REGISTRY=https://repositories.services.jqdev.net/repository/npm/

common_setup
macos_setup
