#! /usr/bin/env dash

UNICODE_LIST="${UNICODE_CHARS:-"$HOME/.local/share/unicode-chars"}"

char="$(column "$UNICODE_LIST" | rofi -dmenu -i -p "Choose a character" | cut --fields=1)"

test -z "$char" && exit

if test -z "$1"; then
    xdotool type "$char"
else
    echo "$char" | xclip -selection clipboard
    notify-desktop "Copied \"$char\" to the clipboard"
fi
