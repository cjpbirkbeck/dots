#!/usr/bin/env dash
# This file will autorun any of the programs if it isn't already running.

run() {
    if ! pgrep -f "$1" ; then
        "$@" &
    fi
}

run udiskie
# run conky
run tmux start-server
