#!/usr/bin/env dash
# Prints out the networking status of each network interface

test -e /sys/class/net/e* && ethernet="$(cat /sys/class/net/e*/operstate 2> /dev/null | sed "s/down/❎/;s/up/🌐/")"
test -e /sys/class/net/w* && wireless="$(cat /sys/class/net/w*/operstate 2> /dev/null )"

case "$wireless" in
    down) wireless="📡 " ;;
    up) wireless="$(awk '/^\s*w/ { print "📶", int($3 * 100 / 70) "% " }' /proc/net/wireless)" ;;
esac

printf "%s %s\n" "$ethernet" "$wireless"
