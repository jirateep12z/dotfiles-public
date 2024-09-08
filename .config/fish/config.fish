set fish_greeting ""

set -gx editor nvim

export XDG_CONFIG_HOME="$HOME/.config"

if test -d /opt/homebrew
  eval "$(/opt/homebrew/bin/brew shellenv)"
end

if not test -d "$HOME/Developers"
  mkdir -p "$HOME/Deveopers"
end

alias vim "nvim"
alias ls "ls -p -G"
alias la "ls -A"
alias ll "ls -l"
alias lla "ll -A"
alias g "git"
alias lg "lazygit"
alias pip "pip3"
alias ide "$HOME/.script/ide.sh"
alias youtube_download "$HOME/.script/youtube_download.sh"
alias cleanup_directories "$HOME/.script/cleanup_directories.sh"
alias initialize_command_history "$HOME/.script/initialize_command_history.sh"
alias resize_dock "$HOME/.script/resize_dock.sh"

source (dirname (status --current-filename))/config_common.fish

python3 "$HOME/.script/sorted_history.py"
