#!/usr/bin/env dash
# Script for spawning new terminals of unattached tmux sessions from rofi.

pgrep tmux 1> /dev/null || tmux start-server

tmux_format="#S : #W [#I/#{session_windows}] : #T [#P/{window_panes}] #{session_attached}"
prompt="Choose session to attach"

session="$(tmux list-sessions -F "$tmux_format" | grep ".* 0" | sed -E -e 's/(.*) 0/\1/' | rofi -dmenu -p "$prompt" | cut --delimiter=" " --fields=1)"

test -z "$session" || st -e tmux attach-session -t "$session"
