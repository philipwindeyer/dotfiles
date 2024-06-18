#!/bin/zsh

# Setup
source ${0%/*}/setup/startup
source ${0%/*}/setup/homebrew
source ${0%/*}/setup/asdf
source ${0%/*}/setup/yarn
source ${0%/*}/setup/thefuck
source ${0%/*}/setup/jsc

# Env vars, settings and aliases
source ${0%/*}/common/aliases
source ${0%/*}/common/env
source ${0%/*}/common/vim_settings
