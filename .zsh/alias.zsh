alias weather='curl wttr.in'
alias svim='sudo nvim'
alias lx='exa --group-directories-first'
unset ll
unalias ll
alias ll='exa --group-directories-first --long --header --git'
alias la='exa --group-directories-first --long --header --git --all'
alias ls='exa --group-directories-first --git'
alias mux='tmuxinator'
alias lg='lazygit'
alias te='toolbox enter'
alias open='xdg-open'
alias rpn='java -jar ~/Downloads/rpncalc.jar'
alias dotfiles="git --git-dir=/home/hoang/.dotfiles --work-tree=$HOME"
alias dotlg='lg -g .dotfiles -w ~/'

alias e='emacs -Q -nw'

# Fedora Laptop
alias charge_limit='sudo tlp setcharge 0 1 BAT1'
alias charge_full='sudo tlp fullcharge BAT1'

alias tlm='tmuxp load main -y'
