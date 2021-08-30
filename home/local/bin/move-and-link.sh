#!/usr/bin/env dash
# Script moves a file to a destination, then creates a symbolic link to the new
# file.

SOURCE="${1}"
TARGET="${2}"

test -z "$SOURCE" && printf "No source indicated.\n" && exit 1
test -z "$TARGET" && printf "No target indicated.\n" && exit 2

# NB: This will resolve to the 'base' file, if source is a symlink itself.
SOURCE="$(realpath "$SOURCE")"
TARGET="$(realpath "$TARGET")"

# If the target is a directory, then assume that the file will be moved to that
# directory with the same name.
test -d "$TARGET" && TARGET="${TARGET}/$(basename "$SOURCE")"

test -e "$TARGET" && printf "Target already exists. Exiting.\n" && exit 3

mv "$SOURCE" "$TARGET"
ln -s "$TARGET" "$SOURCE"
