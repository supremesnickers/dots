alias lx='eza --group-directories-first'
unset ll
unalias ll
alias ll='eza --group-directories-first --long --header --git'
alias la='eza --group-directories-first --long --header --git --all'
alias ls='eza --group-directories-first --git'
alias lg='lazygit'
if [ "$osname" != "Darwin" ]; then
  alias te='toolbox enter'
  alias open='xdg-open'
fi
alias dotfiles="git --git-dir=$HOME/.dotfiles --work-tree=$HOME"

alias tlm='tmuxp load main -y'
