#!/usr/bin/env dash
# Script for controlling tmux from rofi. Currently, only spawns a terminal with an inactive session
# TODO: Add option to create new session
# TODO: If the session is currently connected, switch to that terminal

pgrep tmux && session="$(tmux list-sessions | rofi -dmenu | cut -d " " -f 1 | sed -E -e 's/(.*):/\1/')"

test -n "$session" && st -e tmux attach-session -t "$session"
