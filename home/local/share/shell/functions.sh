#!/usr/bin/env zsh

# Make a directory and change into it.
__mkdir_cd() {
    if [ $# -eq 1 ]; then
        mkdir -p "$1" && cd "$1" || return 1
    else
        echo "Incorrect arguments." && return 1
    fi
}

# Wrapper function for coloured manpages.
man() {
    # Termcap escape sequence meanings:
    # mb: start blinking text
    # md: start bolding text
    # me: end bolding, blinking and underlining
    # so: start standout (reverse video)
    # se: stop standout
    # us: start underlining text
    # ue: stop underlining
    LESS_TERMCAP_mb=$'\e[1;32m' \
    LESS_TERMCAP_md=$'\e[1;32m' \
    LESS_TERMCAP_me=$'\e[0m' \
    LESS_TERMCAP_se=$'\e[0m' \
    LESS_TERMCAP_so=$'\e[01;44;33m' \
    LESS_TERMCAP_ue=$'\e[0m' \
    LESS_TERMCAP_us=$'\e[1;4;31m' \
    command man "$@"
}

alias md="__mkdir_cd"
