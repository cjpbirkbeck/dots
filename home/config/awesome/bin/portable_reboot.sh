#!/usr/env/env dash

sel="$(printf %s "Yes|No" | rofi -dmenu -sep "|" -p "Reboot your system?")"

if [ "$sel" = "Yes" ]; then
    OP_SYS="$(uname)"

    if [ "$OP_SYS" = "Linux" ]; then
        # For system using systemd
        systemctl reboot
    elif [ "$OP_SYS" = "FreeBSD" ]; then
        # Requires user to be in the operator group
        shutdown -r now
    elif [ "$OP_SYS" = "OpenBSD" ]; then
        # Need to figure out how to reboot without a password.
        doas shutdown -P now
    fi
fi

