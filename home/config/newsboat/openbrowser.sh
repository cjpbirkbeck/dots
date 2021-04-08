#!/usr/bin/env dash

# Keep this around make the browser customizable.
browser="${BROWSER:-qutebrowser}"
url="$1"

if pgrep "$browser" > /dev/null; then
    "$browser" "$url"
else
    setsid --fork "$browser" "$url"
fi
