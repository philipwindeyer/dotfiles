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
    brew cleanup

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

function install_npm_global_pkgs() {
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
  while IFS='' read -r LINE || [ -n "${LINE}" ]; do
    gem install ${LINE}
  done <$GEMS
}

function install_nativefier_apps() {
  local apps_dir=/Applications

  while IFS='' read -r LINE || [ -n "${LINE}" ]; do
    local app=$(echo $LINE | awk '{print $1}')
    local name=$(echo $LINE | awk '{ $1=""; print}' | sed -e 's/^[[:space:]]*//')

    if [[ -z "${name// }" ]]; then
      local output=$(nativefier --darwin-dark-mode-support "$app")
    else
      local output=$(nativefier --name "$name" --darwin-dark-mode-support "$app")
    fi

    echo $output

    echo "$output" | while IFS= read -r line ; do
      if [[ $line =~ "^App built to*" ]]; then
        local app_path=$(echo $line | awk -F, '{print $1}' | awk '{ $1=""; $2=""; $3=""; print}' | sed -e 's/^[[:space:]]*//')
        echo "Moving $app_path to $apps_dir"
        mv -f $app_path $apps_dir

        if [ -d $app_path ]; then
          rm -Rf $app_path
        fi
      fi
    done
  done <$NATIVEFIER
}

function create_dirs() {
  [ ! -d ~/workspaces ] && mkdir ~/workspaces
}

function git_settings() {
  git config --global core.editor vim
}

function zshrc() {
  local local_zshrc=~/.zshrc
  local local_secrets=~/.zsh_secrets
  local zshrc_config="$(dirname $0:a:h)"/zsh/.zshrc

  if [ -f $local_zshrc ]; then
    echo "$local_zshrc file already exists"
    grep "source $zshrc_config" $local_zshrc >/dev/null

    if [ ! $? -eq 0 ]; then
      echo "Config not sourced in .zshrc. Adding..."
      echo "source $zshrc_config" >>$local_zshrc
    fi

    grep "source $local_secrets" $local_zshrc >/dev/null

    if [ ! $? -eq 0 ]; then
      echo "Secrets file not sourced in .zshrc. Adding..."
      echo "source $local_secrets" >>$local_zshrc
    fi
  else
    echo "Adding new $local_zshrc file"
    touch $local_zshrc
    echo "source $zshrc_config" >>$local_zshrc
    echo "source $local_secrets" >>$local_zshrc
  fi

  if [ ! -f $local_secrets ]; then
    echo "Adding new $local_secrets file"
    touch $local_secrets
  fi

  echo "Add your secrets and machine specific aliases etc to $local_secrets"

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
  install_nativefier_apps
  create_dirs
  git_settings
  zshrc
}
