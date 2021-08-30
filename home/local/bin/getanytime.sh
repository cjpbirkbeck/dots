#!/usr/bin/env dash
# Get the current time and date for any timezone within the tz database.

TZ="$(timedatectl list-timezones | fzf)" date
