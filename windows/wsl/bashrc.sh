export WIN_USER=$(powershell.exe '$env:USERNAME' | tr -d '\r')
export WIN_HOME="/mnt/c/Users/$WIN_USER"

SCRIPT_DIR="$(dirname "$(readlink -f "$0")")"
. $SCRIPT_DIR/../../shared/dotfiles/bashrc.sh
