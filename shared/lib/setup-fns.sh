#!/bin/bash

# These 2 lines for sudo keep-alive are from https://gist.github.com/cowboy/3118588
sudo -v
while true; do
  sudo -n true
  sleep 60
  kill -0 "$$" || exit
done 2>/dev/null &

function log_heading() {
  echo -e "\n=================================================="
  echo "  $@"
  echo -e "==================================================\n"
}

function log_message() {
  echo -e "  $*\n"
}

function reload_env() {
  log_heading "Reloading environment"

  if [ -f ~/.bashrc ]; then
    source ~/.bashrc
  fi

  if [ -f ~/.zprofile ]; then
    source ~/.zprofile
  fi

  if [ -f ~/.zshrc ]; then
    source ~/.zshrc
  fi
}

function install_pip_packages() {
  while IFS='' read -r LINE || [ -n "${LINE}" ]; do
    pip install ${LINE} --user
  done <$1
}

function add_git_completion() {
  log_heading "Adding git completion"

  curl https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.bash -o ~/.git-completion.bash
  curl https://raw.githubusercontent.com/git/git/master/contrib/completion/git-prompt.sh -o ~/.git-prompt.sh

  chmod +x ~/.git-completion.bash
  chmod +x ~/.git-prompt.sh

  if [ -n "$ZSH_VERSION" ]; then
    curl https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.zsh -o ~/.git-completion.zsh
    chmod +x ~/.git-completion.zsh
  fi
}

function configure_git() {
  log_heading "Configuring git"

  git config --global core.editor "vim"
}

function add_to_vimrc() {
  log_message "Adding $1 to ~/.vimrc unless it already exists"

  if [ ! -f ~/.vimrc ]; then
    touch ~/.vimrc
  fi

  grep -qxF "$1" ~/.vimrc || echo "$1" >>~/.vimrc
}

function create_directories() {
  log_heading "Creating directories"

  if [ ! -d $HOME/workspaces ]; then
    mkdir $HOME/workspaces
  else
    log_message "workspaces directory already exists"
  fi
}
