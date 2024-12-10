#!/usr/bin/env bash

# Auto excutes programs for the qtile shell.

# Rebinds caps lock to escape (when pressed alone) and control with another key.
# Rebinds scroll lock to caps lock. 
setxkbmap -option ctrl:nocaps
xmodmap -e 'keycode 78 = Caps_Lock'
pkill xcape; xcape -e 'Control_L=Escape'

# Allows programs to use KDE themes, if they can.
export XDG_CURRENT_DESKTOP=kde

exec twmnd &
exec sct &
exec mpd &
