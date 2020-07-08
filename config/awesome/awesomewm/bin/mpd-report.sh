#!/usr/bin/env dash
# Prints out a simplifed status of mpd, via mpc.

mpc status | tr -d '()#' | awk ' /\[playing\]/ {print "  "$4", "$2; exit }
                                 /\[paused\]/ {print "  "$4", "$2; exit }
                                 /\[.*\]/ { print "  "$4", "$2; exit }'
