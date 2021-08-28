#!/usr/env/env dash

sel="$(printf %s "Yes|No" | rofi -dmenu -sep "|" -p "Shutdown your computer?")"

if [ "$sel" = "Yes" ]; then systemctl poweroff; fi
