#!/usr/bin/env dash

volume="$(pamixer --get-volume)"

pamixer --get-mute > /dev/null && glyph=" " || glyph=" "

printf "%s%s%%\n" "$glyph" "$volume"
