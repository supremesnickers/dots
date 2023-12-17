alias lx='exa --group-directories-first'
unset ll
unalias ll
alias ll='exa --group-directories-first --long --header --git'
alias la='exa --group-directories-first --long --header --git --all'
alias ls='exa --group-directories-first --git'
alias lg='lazygit'
if [ "$osname" != "Darwin" ]; then
  alias te='toolbox enter'
  alias open='xdg-open'
fi
alias dotfiles="git --git-dir=$HOME/.dotfiles --work-tree=$HOME"

alias tlm='tmuxp load main -y'
