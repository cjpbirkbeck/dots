#!/usr/bin/env dash

if command -v nmtui; then
    nmcli general
else
    status="$(ip link show eno1)"

    printf "%s" "$status"
fi
