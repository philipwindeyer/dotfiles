#!/bin/zsh

# TODO figure out how to automatically run this script with `> >(tee -a stdout.log) 2> >(tee -a stderr.log >&2)`
# I.e. https://stackoverflow.com/questions/692000/how-do-i-write-standard-error-to-a-file-while-using-tee-with-a-pipe

# To log output, run like this:
# ./scripts/macos-work.sh > >(tee -a stdout.log) 2> >(tee -a stderr.log >&2)

# TODO Add log_info, log_error and log_all helper fns to make it easier to distinguish where errors are originating from

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
