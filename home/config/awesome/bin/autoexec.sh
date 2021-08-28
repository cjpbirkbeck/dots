#!/usr/bin/env dash
# This file will autorun any of the programs if it isn't already running.

run() {
    if ! pgrep -f "$1" ; then
        "$@" &
    fi
}

# run udiskie
# run flameshot
run tmux new-session -d -x 100 -c "$HOME" -s "General" -n "Main" "pfetch; zsh"
