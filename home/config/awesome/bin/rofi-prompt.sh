#!/usr/bin/env zsh
# Display a dialog box with rofi's dmenu mode. First argument is the prompt, second is the command to be executed.

printf %s "Yes|No" | rofi -dmenu -sep "|" -p "${1}" | { read reply && test "$reply" = "Yes" && shift; ${@} }
