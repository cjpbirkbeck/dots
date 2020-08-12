#!/bin/sh

# Make a directory and change into it.
__mkdir_cd() {
    if [ $# -eq 1 ]; then
        mkdir -p "$1" && cd "$1" || return 1
    else
        echo "Incorrect arguments." && return 1
    fi
}

alias md="__mkdir_cd"
