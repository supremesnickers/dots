# If there's a frame open, opens the file in that frame
# else creates a new instance
ee() {
  emacsclient -n -e "(if (>= (length (frame-list)) 1) 't)" 2> /dev/null | grep t &> /dev/null

  if [ "$?" -eq "1" ]; then
    emacsclient -a '' -nqc "$@" &> /dev/null
  else
    emacsclient -nq "$@" &> /dev/null
  fi
}

fh() {
  print -z $( ([ -n "$ZSH_NAME" ] && fc -l 1 || history) | fzf +s --tac | sed -E 's/ *[0-9]*\*? *//' | sed -E 's/\\/\\\\/g')
}

fe() {
  IFS=$'\n' files=($(fd -H -E .DS_Store -E .git | fzf --query="$1" --multi --select-1 --exit-0))
  [[ -n "$files" ]] && ${EDITOR:-vim} "${files[@]}"
}

dote() {
  pushd ~ &>/dev/null
  IFS=$'\n' files=($(git --git-dir=$HOME/.dotfiles --work-tree=$HOME ls-files | fzf --query="$1" --multi --select-1 --exit-0))
  [[ -n "$files" ]] && ${EDITOR:-vim} "${files[@]}"
  popd &>/dev/null
}

ftpane() {
  local panes current_window current_pane target target_window target_pane
  panes=$(tmux list-panes -s -F '#I:#P - #{pane_current_path} #{pane_current_command}')
  current_pane=$(tmux display-message -p '#I:#P')
  current_window=$(tmux display-message -p '#I')

  target=$(echo "$panes" | grep -v "$current_pane" | fzf +m --reverse) || return

  target_window=$(echo $target | awk 'BEGIN{FS=":|-"} {print$1}')
  target_pane=$(echo $target | awk 'BEGIN{FS=":|-"} {print$2}' | cut -c 1)

  if [[ $current_window -eq $target_window ]]; then
    tmux select-pane -t ${target_window}.${target_pane}
  else
    tmux select-pane -t ${target_window}.${target_pane} &&
      tmux select-window -t $target_window
  fi
}

fda() {
  local dir
  dir=$(fd --type d . 2> /dev/null | fzf-tmux -h --query="$1" --multi --select-1 --exit-0) && cd "$dir"
}

fif() {
  if [ ! "$#" -gt 0 ]; then echo "Need a string to search for!"; return 1; fi
  rg --files-with-matches --no-messages "$1" | fzf --preview "highlight -O ansi -l {} 2> /dev/null | rg --colors 'match:bg:yellow' --ignore-case --pretty --context 10 '$1' || rg --ignore-case --pretty --context 10 '$1' {}"
}

dots(){
  if [[ "$#" -eq 0 ]]; then
    (cd /
     for i in $(dotfiles ls-files); do
       echo -n "$(dotfiles -c color.status=always status $i -s | sed "s#$i##")"
       echo -e "¬/$i¬\e[0;33m$(dotfiles -c color.ui=always log -1 --format="%s" -- $i)\e[0m"
     done
    ) | column -s¬ -t
  else
    dotfiles $*
  fi
}

unzip_d () {
    zipfile="$1"
    zipdir=${1%.zip}
    unzip -d "$zipdir" "$zipfile"
}

recurse_unzip_to_dirs () {
    find . '(' -iname '*.zip' -o -iname '*.jar' ')' -exec sh -c 'unzip -o -d "${0%.*}" "$0"' '{}' ';'
}
