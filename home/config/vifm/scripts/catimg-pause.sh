#!/usr/bin/env bash
# Show a detailed preview of an image, e.g. gif, jpeg and png files.
# Otherwise, just use peekat script for anything else.

FILE_PATH="$1"
FILE_EXT="${FILE_PATH##*.}"
FILE_EXT_LOWER="$(echo "${FILE_EXT}" | tr '[:upper:]' '[:lower:]')"

if  [[ "$FILE_EXT_LOWER" =~ (gif|jpe?g|png) ]]; then
    catimg "${1}"
else
    COLS="$(bash -i -c 'echo $COLUMNS')"
    export PREVIEW_WITH_VIFM="SET"
    "$HOME/.local/bin/peekat" "$1" "$COLS"
fi

read -n 1 -s -r -p "Press any key to continue… "
