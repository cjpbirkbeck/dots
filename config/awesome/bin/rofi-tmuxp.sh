#!/usr/bin/env dash
# Looks at the tmuxp directory for tmux session files,
# and if one is selected, starts a terminal that loads the session with tmuxp.

selection="$(find "$HOME"/.config/tmuxp -maxdepth 1 -mindepth 1 | sed -E -e 's_(.*)/(.*).yaml_\2_'\
    | rofi -dmenu -i -p 'Choose a tmuxp session')"

test -n "$selection" && st -e tmuxp load "$selection"
