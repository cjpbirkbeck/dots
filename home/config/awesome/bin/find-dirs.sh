#!/usr/bin/env zsh
# Search through directories and open one in a new terminal.

selected="$(pazi view \
    | fzf --no-sort --nth=1 --no-multi --ansi \
    --preview="ls -gAGh --color --group-directories-first {-1}" --preview-window=up | \
    cut -f 2)"

test -n "$selected" && setsid --fork st -d "$selected"
