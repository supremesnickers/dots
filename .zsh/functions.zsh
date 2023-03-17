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
  IFS=$'\n' files=($(fd -H -E .DS_Store -E .git | fzf-tmux -h --query="$1" --multi --select-1 --exit-0))
  [[ -n "$files" ]] && ${EDITOR:-vim} "${files[@]}"
}

vf() {
  local files

  files=(${(f)"$(locate -Ai -0 $@ | grep -z -vE '~$' | fzf --read0 -0 -1 -m)"})

  if [[ -n $files ]]
  then
     $EDITOR -- $files
     print -l $files[1]
  fi
}

dote() {
  pushd ~ &>/dev/null
  IFS=$'\n' files=($(git --git-dir=/home/hoang/.dotfiles --work-tree=$HOME ls-files | fzf-tmux -h --query="$1" --multi --select-1 --exit-0))
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

cf() {
  local file

  file="$(locate -i -0 $@ | grep --null -vE '~$' | fzf --read0 -0 -1)"

  if [[ -n $file ]]
  then
     if [[ -d $file ]]
     then
        cd -- $file
     else
        cd -- ${file:h}
     fi
  fi
}

fif() {
  if [ ! "$#" -gt 0 ]; then echo "Need a string to search for!"; return 1; fi
  rg --files-with-matches --no-messages "$1" | fzf --preview "highlight -O ansi -l {} 2> /dev/null | rg --colors 'match:bg:yellow' --ignore-case --pretty --context 10 '$1' || rg --ignore-case --pretty --context 10 '$1' {}"
}

dot(){
  if [[ "$#" -eq 0 ]]; then
    (cd /
    for i in $(dotfiles ls-files); do
      echo -n "$(dotfiles -c color.status=always status $i -s | sed "s#$i##")"
      echo -e "¬/$i¬\e[0;33m$(dotfiles -c color.ui=always log -1 --format="%s" -- $i)\e[0m"
    done
    ) | column -t --separator=¬ -T2
  else
    dotfiles $*
  fi
}
