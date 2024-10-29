########## zsh shell config @hoangolo #########
## profiling
# zmodload zsh/zprof

# oh my zsh
export ZSH="$HOME/.oh-my-zsh"
export DISABLE_AUTO_TITLE='true' # fix for tmux sessions

if [[ -f "/etc/os-release" ]]; then
    osname=$(cat /etc/os-release | grep -e '^NAME=' | cut -d = -f 2 | tr -d '"')
else
    osname=$(uname)
fi

# ======PLUGINS=======
# adding builtin oh-my-zsh plugins
plugins=(
  git
  command-not-found
  colored-man-pages
  safe-paste
)

if [[ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/fast-syntax-highlighting" ]]; then
  echo "Adding fast-syntax-highlighting to zsh plugins"
  git clone https://github.com/zdharma-continuum/fast-syntax-highlighting.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/fast-syntax-highlighting
fi
plugins+=(fast-syntax-highlighting)

if [[ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/fzf-tab" ]]; then
  echo "Adding fzf-tab to zsh plugins"
  git clone https://github.com/Aloxaf/fzf-tab ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/fzf-tab
fi
plugins+=(fzf-tab)
# disable sort when completing `git checkout`
zstyle ':completion:*:git-checkout:*' sort false
# set descriptions format to enable group support
# NOTE: don't use escape sequences here, fzf-tab will ignore them
zstyle ':completion:*:descriptions' format '[%d]'
# set list-colors to enable filename colorizing
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
# force zsh not to show completion menu, which allows fzf-tab to capture the unambiguous prefix
zstyle ':completion:*' menu no
# preview directory's content with eza when completing cd
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 --color=always $realpath'
# switch group using `<` and `>`
zstyle ':fzf-tab:*' switch-group '<' '>'
# This will check for updates every 7 days
zstyle ':omz:update' frequency 7
zstyle ':omz:update' verbose minimal # only few lines
# Speeds up load time
zstyle ':omz:update' mode auto

if [[ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-fzf-history-search" ]]; then
  echo "Adding zsh-fzf-history-search to zsh plugins"
  git clone https://github.com/joshskidmore/zsh-fzf-history-search ${ZSH_CUSTOM:=~/.oh-my-zsh/custom}/plugins/zsh-fzf-history-search
fi
plugins+=(zsh-fzf-history-search)

if [[ "$osname" = "Darwin" ]]; then
  plugins+=(macos iterm2)

  eval "$(/opt/homebrew/bin/brew shellenv)"
elif [[ "$osname" = "Ubuntu Linux" ]]; then
  plugins+=(ubuntu)
elif [[ "$osname" = "Fedora Linux" ]]; then
  plugins+=(dnf)
fi

plugins+=(eza)

if [[ $(uname) = "Linux" ]]; then
  source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh
  source /usr/share/fzf/shell/key-bindings.zsh
elif [[ "$osname" = "Darwin" ]]; then
  [ -f "/opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh" ] && source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
fi


source "$ZSH/oh-my-zsh.sh"

# add homebrew completions
FPATH="$(brew --prefix)/share/zsh/site-functions:${FPATH}"

# color the username and stuff
autoload -U colors && colors

# macOS specific
if [ "$osname" = "Darwin" ]; then
  launchctl setenv PATH $PATH
  [ -f "${HOME}/.iterm2_shell_integration.zsh" ] && source "${HOME}/.iterm2_shell_integration.zsh"
fi

PROMPT='%F{blue}%2~%f %(?.%F{14}>.%F{9}>)%f '
RPROMPT=''

export EDITOR="nvim"
export VISUAL=$EDITOR

# Tab completion
zstyle ':completion:*' menu select
zmodload zsh/complist
_comp_options+=(globdots)		# Include hidden files.

# autoload -Uz compinit
# compinit

[[ go ]] && GOPATH=$(go env GOPATH)

brew_prefix=$(brew --prefix)

path+=("$HOME/Developer/lem")
path+=("$HOME/.qlot/bin")
path+=("$HOME/.local/bin")
path+=("$HOME/.node/bin")
path+=("$HOME/.cargo/bin")
path+=("$HOME/.config/emacs/bin")
path+=("$GOPATH/bin")
path+=("$HOME/.platformio/penv/bin")
path+=("$brew_prefix/opt/llvm/bin")

export NODE_PATH="$HOME/.node/lib/node_modules:$NODE_PATH"

if [[ -d "/Applications/Emacs.app/Contents/MacOS/bin" ]]; then
  path+=("/Applications/Emacs.app/Contents/MacOS/bin")
  # alias emacs="emacs -nw" # Always launch "emacs" in terminal mode.
fi

[ -d "$HOME/.cargo" ] && source "$HOME/.cargo/env"

# eval "$(direnv hook zsh)"

# raylib
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:

# # Flutter
# [[ -f ~/.local/share/completions/flutter.sh ]] && source ~/.local/share/completions/flutter.sh

# FZF
[[ -f ~/.fzf.zsh ]] && source ~/.fzf.zsh
export FZF_DEFAULT_COMMAND='fd --type file --follow --hidden --exclude .git'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

export FZF_DEFAULT_OPTS='--border --layout=reverse'
export FZF_CTRL_T_OPTS="
  --walker-skip .git,node_modules,target
  --preview 'bat -n --color=always {}'
  --bind 'ctrl-/:change-preview-window(down|hidden|)'"

export ANDROID_HOME="$HOME/Android/Sdk"
path+=("$ANDROID_HOME/emulator")
path+=("$ANDROID_HOME/platform-tools")

path+=("$HOME/.jenv/bin")

# after adding all the variables
export PATH

eval "$(jenv init -)"
eval "$(zoxide init zsh)"
# eval "$(starship init zsh)"
# eval "$(mcfly init zsh)"
# eval "$(direnv hook zsh)"

# # LANGUAGE VERSION MANAGEMENT
# export PYENV_ROOT="$HOME/.pyenv"
# [[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
# eval "$(pyenv init -)"

# . /opt/homebrew/opt/asdf/libexec/asdf.sh

source $HOME/.zsh/alias.zsh
source $HOME/.zsh/functions.zsh

# profiling
# zprof
