#!/usr/bin/env sh
# This file will autorun any of the programs if it isn't already running.

function run {
    if ! pgrep -f "$1" ; then
        "$@" &
    fi
}

run udiskie
run conky
run tmux start-server
