#!/usr/bin/env dash
# Search all the man pages and opens a new one in a terminal.

manpage="$(man -k . | fzf --prompt="Man> " --preview="man {1}" | sed -E 's/\((.*)\)/\1/g' | awk ' { print $2" "$1 } ')"

setsid --fork termite --exec="man $manpage"
