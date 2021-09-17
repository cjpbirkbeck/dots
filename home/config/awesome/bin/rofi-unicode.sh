#!/usr/bin/env zsh
# Show a rofi menu of various unicode character, and choose one of them.
# By default, it will directly insert that symbol, but if there is an argument,
# it will instead copy it to the clipboard

UNICODE_LIST="${UNICODE_CHARS:-"$HOME/.local/share/unicode-chars"}"

char="$(column "$UNICODE_LIST" | rofi -dmenu -i -p "Choose a character" | cut -f 1)"

test -z "$char" && exit

if test -z "$1"; then
    xdotool type "$char"
else
    echo "$char" | xclip --clipboard
    notify-send "Unicode glyph" "Copied \"$char\" to the clipboard"
fi
