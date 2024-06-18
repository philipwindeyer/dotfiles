#!/bin/zsh

cd $0:a:h

if [[ ! $1 == '--with-logging' ]]; then
  timestamp=$(date +%Y%m%d-%H%M%S)
  ./$0:t --with-logging > >(tee -a ${timestamp}-info.log) 2> >(tee -a ${timestamp}-err.log >&2)
  exit $?
fi

source common/common-fns.sh
source macos/macos-fns.sh

readonly TAPS=common/taps.txt
readonly FORMULAE=common/formulae.txt
readonly CASKS=macos/casks.txt
readonly APPS=macos/apps.txt
readonly ASDF_PLUGINS=common/asdf-plugins.txt
readonly ASDF_LIBS=common/asdf-libs.txt
readonly NPM_PKGS=common/npm-global-pkgs.txt
readonly GEMS=common/gems.txt
readonly DOCK_APPS=macos/dock-apps.txt

common_setup
macos_setup
