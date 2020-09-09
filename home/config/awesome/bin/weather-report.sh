#!/usr/bin/env zsh
# Query the weather and prints a synposis with an icon and the temperature.
# Created on Monday December 17, 2018.
# Created by Christopher Birkbeck

glyph=""
current="$(weather --metric "${1}")"
notify-send "Weather Updated" "${current}" > /dev/null

temperature=$(echo "$current" | awk ' /Temperature:/ { print $2 " °" $3 } ')

if (echo "$current" | grep "Weather: ") > /dev/null ; then
  conditions=$(echo "$current" | awk ' /Weather: / { $1 = ""; print } ')
else
  conditions=$(echo "$current" | awk ' /Sky conditions: / { $1 = ""; $2 = ""; print } ')
fi

case "$conditions" in
    "snow") glyph="" ;;
    "rain"|"showers") glyph="" ;;
    "sunny"|"clear") glyph="" ;;
    "overcast") glyph="" ;;
    "cloudy"|"mist") glyph="" ;;
esac

echo " $glyph $temperature"
