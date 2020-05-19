#!/usr/bin/env dash

selection="$(find "$HOME"/.config/tmuxp -maxdepth 1 -mindepth 1 | sed -E -e 's_(.*)/(.*).yaml_\2_' | rofi -dmenu -p 'Choose a tmuxp session -i')"

st -e tmuxp load "$selection"
