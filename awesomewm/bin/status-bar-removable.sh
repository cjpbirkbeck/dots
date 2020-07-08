#!/usr/bin/env dash

rmcount="$(find /run/media/"$USER" -maxdepth 1 -mindepth 1 | wc -l)"

if test "$rmcount" -gt 0; then
    printf " %s\n" "$rmcount"
fi
