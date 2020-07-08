#!/usr/bin/env bash
# Query the weather and prints a synposis with an icon and the temperature.
# Created on Monday December 17, 2018.
# Created by Christopher Birkbeck

# if [[ "$(nmcli networking connectivity)" != "full" ]]; then
#     notify-desktop "Weather update failed" "Unable to connect to the Internet. Please try connecting and try again."
#     exit 1
# fi

glyph=""
current="$(weather --metric "${1}")"
notify-desktop "Weather Updated" "${current}" > /dev/null

temperature=$(echo "$current" | awk ' /Temperature:/ { print $2 " °" $3 } ')

if (echo "$current" | grep "Weather: ") > /dev/null ; then
  conditions=$(echo "$current" | awk ' /Weather: / { $1 = ""; print } ')
else
  conditions=$(echo "$current" | awk ' /Sky conditions: / { $1 = ""; $2 = ""; print } ')
fi

if [[ $conditions =~ snow ]]; then
  glyph=""
elif [[ $conditions =~ rain ]] || [[ $conditions =~ showers ]]; then
  glyph=""
elif [[ $conditions =~ sunny ]] || [[ $conditions =~ clear ]]; then
  glyph=""
elif [[ $conditions =~ overcast ]]; then
  glyph=""
elif [[ $conditions =~ cloudy ]] || [[ $conditions =~ mist ]]; then
  glyph=""
fi

conditions=$(echo "$conditions" | sed -E -e "s_\\b(.)_\\u\\1_g")

echo " $glyph$conditions $temperature"
