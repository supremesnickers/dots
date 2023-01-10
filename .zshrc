########## zsh shell config @hoangolo #########
## profiling 
# zmodload zsh/zprof

# oh my zsh
export ZSH="$HOME/.oh-my-zsh"
export DISABLE_AUTO_TITLE='true' # fix for tmux sessions

[[ -f "/etc/os-release" ]] && osname=$(cat /etc/os-release | grep -e '^NAME=' | cut -d = -f 2 | tr -d '"')

plugins=(
    git
    web-search
    command-not-found
    colored-man-pages
    safe-paste
    dnf
    sudo
    mercurial
)


[[ -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/fast-syntax-highlighting" ]] && plugins+=(fast-syntax-highlighting)

[[ -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/fzf-tab" ]] && plugins+=(fzf-tab)

if [ $(uname) = "Darwin" ]; then
    plugins+=(brew macos)
elif [ "$osname" = "Ubuntu Linux" ]
then
    plugins+=(ubuntu)
fi

source "$ZSH/oh-my-zsh.sh"

[ -f "/usr/local/share/zsh-autosuggestions/zsh-autosuggestions.zsh" ] && source /usr/local/share/zsh-autosuggestions/zsh-autosuggestions.zsh

if [ $(uname) = "Linux" ]; then
    source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh
    source /usr/share/fzf/shell/key-bindings.zsh
    # source /usr/share/doc/fzf/examples/completion.zsh
fi

if [ -d ~/dotfiles ]; then
    source ~/dotfiles/zsh/.zsh/alias.zsh
    source ~/dotfiles/zsh/.zsh/functions.zsh
fi

# export LC_CTYPE=en_US.UTF-8
# export LC_ALL=en_US.UTF-8


# Speeds up load time
DISABLE_UPDATE_PROMPT=true

# # Perform compinit only once a day.
# autoload -Uz compinit
# for dump in ~/.zcompdump(N.mh+24); do
#   compinit
# done
# compinit -C

# color the username and stuff
autoload -U colors && colors

# deprecated due to the amazing starship prompt
#PS1="%B%{$fg[red]%}[%{$fg[green]%}%n%{$fg[blue]%}@%{$fg[yellow]%}%M %{$fg[blue]%}%~%{$fg[red]%}]%{$fg[blue]%}$%b "

export EDITOR="nvim"
export VISUAL=$EDITOR


# Tab completion
zstyle ':completion:*' menu select
zmodload zsh/complist
_comp_options+=(globdots)		# Include hidden files.

[ go ] && GOPATH=$(go env GOPATH)


if [ $(uname) != "Darwin" ]; then
    # export EMACS="/usr/bin/toolbox run /usr/bin/emacs"
    # export EMACS="/usr/bin/flatpak run org.gnu.emacs"
fi

path+=("$HOME/.local/bin/")
path+=("$HOME/.node/bin")
path+=("$HOME/.cargo/bin")
path+=("$HOME/scripts")
path+=("$HOME/.emacs.d/bin")
path+=("$HOME/.composer/vendor/bin")
path+=("$GOPATH/bin")
path+=("$HOME/.poetry/bin")
path+=("$HOME/.nimble/bin")

path+=("/usr/local/opt/openjdk/bin")
path+=("/Library/TeX/texbin")
path+=("$HOME/.local/share/flutter/bin")
path+=("$HOME/.deno/bin")
path+=("$HOME/Projects/bsc/bin")
path+=("$HOME/Downloads/nvim-linux64/bin")
path+=("$HOME/Downloads/helix-22.12-x86_64-linux/")


if [ $(uname) = "Darwin" ]; then
    dt="/Volumes/PortableSSD/uni/dt"
else
    dt="/run/media/hoang/PortableSSD/uni/dt"
fi
path+=("$dt/verilog/bin/")

export NODE_PATH="$HOME/.node/lib/node_modules:$NODE_PATH"

if [ -d "/Applications/Emacs.app/Contents/MacOS/bin" ]; then
    path+=("/Applications/Emacs.app/Contents/MacOS/bin")
  # alias emacs="emacs -nw" # Always launch "emacs" in terminal mode.
fi

# macOS specific
if [ $(uname) = "Darwin" ]; then
    launchctl setenv PATH $PATH
    [ -f "${HOME}/.iterm2_shell_integration.zsh" ] && source "${HOME}/.iterm2_shell_integration.zsh"
fi

[ -d "$HOME/.cargo" ] && source "$HOME/.cargo/env"

# eval "$(direnv hook zsh)"

# [ bw ] && eval "$(bw completion --shell zsh); compdef _bw bw;"

# with zoxide installed from homebrew
[ -f "$HOME/.ghcup/env" ] && source "$HOME/.ghcup/env" # ghcup-env

# path+=("$HOME/.nvm/versions/node/v16.4.2/bin")

# raylib
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" --no-use  # This loads nvm

# FZF
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Flutter
[ -f ~/.local/share/completions/flutter.sh ] && source ~/.local/share/completions/flutter.sh

# OPAM
[[ ! -r /var/home/hoang/.opam/opam-init/init.zsh ]] || source /var/home/hoang/.opam/opam-init/init.zsh  > /dev/null 2> /dev/null

export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_DEFAULT_COMMAND='fd --type file --follow --hidden --exclude .git --color=always'
export FZF_DEFAULT_OPS="--ansi"

# after adding all the variables
export PATH

# loading zsh-syntax-highlighting
# if [ $(uname) = "Darwin" ]; then
#     source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
# else
#     source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
# fi

eval "$(zoxide init zsh)"
eval "$(starship init zsh)"
eval "$(mcfly init zsh)"
# profiling
# zprof
