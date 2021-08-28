#!/usr/env/env dash

sel="$(printf %s "Yes|No" | rofi -dmenu -sep "|" -p "Reboot your system?")"

if [ "$sel" = "Yes" ]; then systemctl reboot; fi
