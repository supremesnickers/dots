#!/usr/bin/env bash

if [ $(uname) = "Darwin" ]; then
    osascript -l JavaScript ~/dotfiles/tmux/.config/tmux/tunes.js
else
    gjs ~/dotfiles/tmux/.config/tmux/linux_tunes.js
fi
