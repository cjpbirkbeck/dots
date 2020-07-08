#!/usr/bin/env dash

error=' Error'
current="$(weather --metric "${1}" || echo "$error && exit 1")"

# test "$current" = "$error" && printf "%s" "$error" && exit 1

temperature=$(echo "$current" | awk ' /Temperature:/ { print $2 " °" $3 } ')

conditions="$(echo "$current" | awk ' /Weather: / { $1 = ""; print }
                                      /Sky conditions: / { $1 = ""; $2 = ""; print } ' )"

glyph=""

glyph="$(echo "$conditions" | awk '/clear|sunny/ { print "" end }
                                   /partly clear/ { print "" }
                                   /(mostly|partly) cloudy/ { print ""}
                                   /overcast/ { print ""}
                                   /rainy/ { print "" end }
                                   /.*showers/ { print "" end }
                                   /.*snow/ {print "" end }')"

printf " %s %s\n" "$glyph" "$temperature"
