#!/bin/zsh

sudo -v
while true; do
  sudo -n true
  sleep 60
  kill -0 "$$" || exit
done 2>/dev/null &

function log_info() {
  echo "### $1\n"
}

function log_error() {
  >&2 echo "### $1\n"
}

function log_all() {
  log_info $1
  log_error $1
}

function manage_homebrew() {
  log_all 'Managing Homebrew'

  if command -v brew &>/dev/null; then
    log_info 'Homebrew installed. Updating and upgrading'
    brew doctor
    brew update
    brew upgrade
    brew upgrade --cask
    brew cleanup

  else
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"

    if [[ $(uname -m) =~ arm ]]; then
      log_info 'Apply supplemental steps to include brew on path for ARM based machine (i.e. Apple M1 chip)'

      echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
      eval "$(/opt/homebrew/bin/brew shellenv)"
    fi
  fi
}

function manage_asdf() {
  log_all 'Managing asdf'

  if command -v asdf &>/dev/null; then
    log_info 'asdf installed'

  else
    log_info 'Installing asdf for managed versions of JS and Ruby'
    brew install asdf
  fi
}

function add_taps() {
  log_all 'Add Homebrew taps'
  while IFS='' read -r LINE || [ -n "${LINE}" ]; do
    brew tap ${LINE}
  done <$TAPS
}

function install_formulae() {
  log_all 'Install Homebrew formulae'
  while IFS='' read -r LINE || [ -n "${LINE}" ]; do
    brew list ${LINE} || brew install ${LINE}
  done <$FORMULAE
}

function add_asdf_plugins() {
  log_all 'Install asdf plugins'
  while IFS='' read -r LINE || [ -n "${LINE}" ]; do
    asdf plugin add "${LINE}"
  done <$ASDF_PLUGINS

  ~/.asdf/plugins/nodejs/bin/import-release-team-keyring
}

function install_asdf_libs() {
  log_all 'Install asdf libs'
  while IFS='' read -r LINE || [ -n "${LINE}" ]; do
    local lib=$(echo $LINE | awk '{print $1}')
    local version=$(echo $LINE | awk '{print $2}')
    if [[ -z "${version// }" ]]; then version=latest; fi

    asdf install $lib $version

    local global_version=$(asdf list $lib | tail -n 1 | awk '{$1=$1};1')
    asdf global $lib $global_version
  done <$ASDF_LIBS
}

function install_npm_global_pkgs() {
  log_all 'Install NPM global packages'
  while IFS='' read -r LINE || [ -n "${LINE}" ]; do
    local pkg=$(echo $LINE | awk '{print $1}')
    local registry=$(echo $LINE | awk '{print $2}')

    if [[ -z "${registry// }" ]]; then
      npm install -g $pkg
    else
      npm install -g $pkg --registry "$registry"
    fi

  done <$NPM_PKGS

  if [[ -z "${NPM_REGISTRY// }" ]]; then
    npm update -g --registry $NPM_REGISTRY
  else
    npm update -g
  fi
}

function install_gems() {
  log_all 'Install Ruby gems'
  while IFS='' read -r LINE || [ -n "${LINE}" ]; do
    gem install ${LINE}
  done <$GEMS
}

function create_dirs() {
  log_all 'Create working directories'
  [ ! -d ~/workspaces ] && mkdir ~/workspaces
}

function git_settings() {
  log_all 'Git settings'
  git config --global core.editor vim
}

function zshrc() {
  log_all 'Configure zsh'
  local local_zshrc=~/.zshrc
  local local_secrets=~/.zsh_secrets
  local zshrc_config="$(dirname $0:a:h)"/zsh/.zshrc

  if [ -f $local_zshrc ]; then
    log_info "$local_zshrc file already exists"
    grep "source $zshrc_config" $local_zshrc >/dev/null

    if [ ! $? -eq 0 ]; then
      log_info 'Config not sourced in .zshrc. Adding...'
      echo "source $zshrc_config" >>$local_zshrc
    fi

    grep "source $local_secrets" $local_zshrc >/dev/null

    if [ ! $? -eq 0 ]; then
      log_info 'Secrets file not sourced in .zshrc. Adding...'
      echo "source $local_secrets" >>$local_zshrc
    fi
  else
    log_info "Adding new $local_zshrc file"
    touch $local_zshrc
    echo "source $zshrc_config" >>$local_zshrc
    echo "source $local_secrets" >>$local_zshrc
  fi

  if [ ! -f $local_secrets ]; then
    log_info "Adding new $local_secrets file"
    touch $local_secrets
  fi

  log_info "Add your secrets and machine specific aliases etc to $local_secrets"

  compaudit | xargs chmod g-w
}

# Run this from main script
function common_setup() {
  manage_homebrew
  manage_asdf
  add_taps
  install_formulae
  add_asdf_plugins
  install_asdf_libs
  install_npm_global_pkgs
  install_gems
  create_dirs
  git_settings
  zshrc

  log_all 'common settings and apps complete'
}
