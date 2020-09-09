#!/usr/bin/env dash
# Look if any media has been mounted in media directory, and if so print out a glyph and the count.

rmcount="$(find /run/media/"$USER" -maxdepth 1 -mindepth 1 | wc -l)"

if test "$rmcount" -gt 0; then
    printf " %s\n" "$rmcount"
fi
