#!/usr/env/env dash

sel="$(printf %s "Yes|No" | rofi -dmenu -sep "|" -p "Shutdown your system?")"

if [ "$sel" = "Yes" ]; then
    OP_SYS="$(uname)"

    if [ "$OP_SYS" = "Linux" ]; then
        # For system using systemd
        systemctl poweroff
    elif [ "$OP_SYS" = "FreeBSD" ]; then
        # Requires user to be in the operator group
        shutdown -p now
    elif [ "$OP_SYS" = "OpenBSD" ]; then
        # Need to figure out how to shutdown without a password.
        doas shutdown -P now
    fi
fi

