#!/bin/zsh

sudo -v
while true; do
  sudo -n true
  sleep 60
  kill -0 "$$" || exit
done 2>/dev/null &

function manage_homebrew() {
  if command -v brew &>/dev/null; then
    echo "Homebrew installed. Updating and upgrading"
    brew doctor
    brew update
    brew upgrade
    brew upgrade --cask

  else
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
  fi
}

function manage_asdf() {
  if command -v asdf &>/dev/null; then
    echo "asdf installed"

  else
    echo "Installing asdf for managed versions of JS and Ruby"
    brew install asdf
  fi
}

function add_taps() {
  while IFS='' read -r LINE || [ -n "${LINE}" ]; do
    brew tap ${LINE}
  done <$TAPS
}

function install_formulae() {
  while IFS='' read -r LINE || [ -n "${LINE}" ]; do
    brew list ${LINE} || brew install ${LINE}
  done <$FORMULAE
}

function add_asdf_plugins() {
  while IFS='' read -r LINE || [ -n "${LINE}" ]; do
    asdf plugin add "${LINE}"
  done <$ASDF_PLUGINS

  ~/.asdf/plugins/nodejs/bin/import-release-team-keyring
}

function install_asdf_libs() {
  while IFS='' read -r LINE || [ -n "${LINE}" ]; do
    local lib=$(echo $LINE | awk '{print $1}')
    local version=$(echo $LINE | awk '{print $2}')
    if [[ -z "${version// }" ]]; then version=latest; fi

    asdf install $lib $version

    local global_version=$(asdf list $lib | tail -n 1 | awk '{$1=$1};1')
    asdf global $lib $global_version
  done <$ASDF_LIBS
}

function install_yarn_global_pkgs() {
  while IFS='' read -r LINE || [ -n "${LINE}" ]; do
    local pkg=$(echo $LINE | awk '{print $1}')
    local registry=$(echo $LINE | awk '{print $2}')

    if [[ -z "${registry// }" ]]; then
      yarn global add $pkg

    else
      # "--registry" does not work with `yarn global`
      npm install -g $pkg --registry "$registry"
    fi

  done <$YARN_PKGS
}

function create_dirs() {
  [ ! -d ~/workspaces ] && mkdir ~/workspaces
}

function git_settings() {
  git config --global core.editor vim
}

function zshrc() {
  local local_zshrc=~/.zshrc
  local zshrc_config="$(dirname $0:a:h)"/zsh/.zshrc

  if [ -f $local_zshrc ]; then
    echo ".zshrc file already exists"
    grep "source $zshrc_config" $local_zshrc >/dev/null

    if [ ! $? -eq 0 ]; then
      echo "Config not sourced in .zshrc. Adding..."
      echo "source $zshrc_config" >>$local_zshrc
    fi

  else
    echo "Adding new .zshrc file"
    touch $local_zshrc
    echo "source $zshrc_config" >>$local_zshrc
  fi

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
  install_yarn_global_pkgs
  create_dirs
  git_settings
  zshrc
}
