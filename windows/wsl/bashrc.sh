export WIN_USER=$(powershell.exe '$env:USERNAME' | tr -d '\r')
export WIN_HOME="/mnt/c/Users/$WIN_USER"

. "$HOME/.asdf/asdf.sh"
. "$HOME/.asdf/completions/asdf.bash"

if [ -f $HOME/.git-completion.bash ]; then
  . $HOME/.git-completion.bash
fi

if [ -f $HOME/git-prompt.sh ]; then
  . $HOME/git-prompt.sh
fi
