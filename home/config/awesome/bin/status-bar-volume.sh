#!/usr/bin/env zsh
# Get the volume status of the widget

if [ "$OSTYPE" = "linux-gnu" ]; then
    volume="$(pamixer --get-volume)"

    if pamixer --get-mute > /dev/null; then
        glyph=" "
    else
        glyph=" "
    fi
elif [ "${OSTYPE%%[0-9.]*}" = "freebsd" ]; then
    volume="$(mixer -s pcm | cut -d ' ' -f 2)"

    if [ "$volume" = "0:0" ]; then
        glyph=" "
    else
        glyph=" "
    fi
fi

printf "%s%s%%\n" "$glyph" "$volume"
