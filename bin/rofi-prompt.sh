#!/usr/bin/env zsh
# TODO: Why does this only work with zsh?

printf %s "Yes|No" | dmenu -sep "|" -p "${1}" | { read reply && test "$reply" = "Yes" && shift; ${@} }
