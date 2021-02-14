#!/bin/sh
# Show a small glyph using weathericons and the temperature, with data from weather(1)

# weather doesn't have the correct path for its data files on FreeBSD.
[ "$(uname)" = "FreeBSD" ] && weatherpath="--setpath=/usr/local/share/weather"

if ! current="$(weather ${weatherpath} --metric "${1}")"; then
    echo " Error"
    exit 1
fi

temperature=$(echo "$current" | awk ' /Temperature:/ { print $2 " °" $3 } ')

conditions="$(echo "$current" | awk ' /Weather: / { $1 = ""; print }
                                      /Sky conditions: / { $1 = ""; $2 = ""; print } ' )"

glyph=""

glyph="$(echo "$conditions" | awk '/clear|sunny/ { print "" end }
                                   /partly clear/ { print "" end }
                                   /(mostly|partly) cloudy/ { print "" end}
                                   /overcast/ { print "" end }
                                   /rainy/ { print "" end }
                                   /.*snow/ {print "" end }
                                   /.*showers/ { print "" end }')"

glyph="$(echo "$glyph" | head -1)"

printf " %s %s\n" "$glyph" "$temperature"
