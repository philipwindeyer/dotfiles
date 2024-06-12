. "$HOME/.asdf/asdf.sh"
. "$HOME/.asdf/completions/asdf.bash"

if [ -f $HOME/.git-completion.bash ]; then
  . $HOME/.git-completion.bash
fi

if [ -f $HOME/git-prompt.sh ]; then
  . $HOME/git-prompt.sh
fi

export PATH="$HOME/.local/bin:$PATH"
eval "$(thefuck --alias)"
