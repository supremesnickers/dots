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

# adding builtin oh-my-zsh plugins
plugins=(
  git
  # web-search
  command-not-found
  colored-man-pages
  safe-paste
  # sudo
  # mercurial
)

if [[ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/fast-syntax-highlighting" ]]; then
  echo "Adding fast-syntax-highlighting to zsh plugins"
  git clone https://github.com/zdharma-continuum/fast-syntax-highlighting.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/fast-syntax-highlighting
fi

plugins+=(fast-syntax-highlighting)

if [[ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/fzf-tab" ]]; then
  echo "Adding fzf-tab to zsh plugins"
  git clone https://github.com/Aloxaf/fzf-tab ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/fzf-tab
  plugins+=(fzf-tab)
fi

if [[ "$osname" = "Darwin" ]]; then
  plugins+=(brew macos)
elif [[ "$osname" = "Ubuntu Linux" ]]; then
  plugins+=(ubuntu)
elif [[ "$osname" = "Fedora Linux" ]]; then
  plugins+=(dnf)
fi

if [[ $(uname) = "Linux" ]]; then
  source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh
  source /usr/share/fzf/shell/key-bindings.zsh
  # source /usr/share/doc/fzf/examples/completion.zsh
elif [[ "$osname" = "Darwin" ]]; then
  [ -f "/opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh" ] && source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
fi


# Speeds up load time
DISABLE_UPDATE_PROMPT=true

# # Perform compinit only once a day.
# autoload -Uz compinit
# for dump in ~/.zcompdump(N.mh+24); do
#   compinit
# done
# compinit -C

source "$ZSH/oh-my-zsh.sh"
source $HOME/.zsh/alias.zsh
source $HOME/.zsh/functions.zsh

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

[[ go ]] && GOPATH=$(go env GOPATH)

if [[ "$osname" != "Darwin" ]]; then
  # export EMACS="/usr/bin/toolbox run /usr/bin/emacs"
  # export EMACS="/usr/bin/flatpak run org.gnu.emacs"
fi

path+=("$HOME/.local/bin")
path+=("$HOME/.node/bin")
path+=("$HOME/.cargo/bin")
path+=("$HOME/.config/emacs/bin")
path+=("$GOPATH/bin")
path+=("$HOME/.platformio/penv/bin")

export NODE_PATH="$HOME/.node/lib/node_modules:$NODE_PATH"

if [[ -d "/Applications/Emacs.app/Contents/MacOS/bin" ]]; then
  path+=("/Applications/Emacs.app/Contents/MacOS/bin")
  # alias emacs="emacs -nw" # Always launch "emacs" in terminal mode.
fi

# macOS specific
if [ "$osname" = "Darwin" ]; then
  launchctl setenv PATH $PATH
  [ -f "${HOME}/.iterm2_shell_integration.zsh" ] && source "${HOME}/.iterm2_shell_integration.zsh"
fi

[ -d "$HOME/.cargo" ] && source "$HOME/.cargo/env"

# eval "$(direnv hook zsh)"

# with zoxide installed from homebrew
[ -f "$HOME/.ghcup/env" ] && source "$HOME/.ghcup/env" # ghcup-env

# raylib
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:

export NVM_DIR="$HOME/.nvm"
[[ -s "$NVM_DIR/nvm.sh" ]] && \. "$NVM_DIR/nvm.sh" --no-use  # This loads nvm

# FZF
[[ -f ~/.fzf.zsh ]] && source ~/.fzf.zsh

# # Flutter
# [[ -f ~/.local/share/completions/flutter.sh ]] && source ~/.local/share/completions/flutter.sh

export FZF_DEFAULT_COMMAND='fd --type file --follow --hidden --exclude .git'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

export ANDROID_HOME="$HOME/Android/Sdk"
path+=("$ANDROID_HOME/emulator")
path+=("$ANDROID_HOME/platform-tools")

# after adding all the variables
export PATH

if [ -e /home/hoang/.nix-profile/etc/profile.d/nix.sh ]; then . /home/hoang/.nix-profile/etc/profile.d/nix.sh; fi # added by Nix installer


eval "$(zoxide init zsh)"
eval "$(starship init zsh)"
eval "$(mcfly init zsh)"
eval "$(direnv hook zsh)"

export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"

# [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

if [ "$osname" = "Darwin" ]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
  ssh-add --apple-load-keychain 2> /dev/null
fi

# profiling
# zprof
