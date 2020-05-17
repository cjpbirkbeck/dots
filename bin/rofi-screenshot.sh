#!/usr/bin/env dash

test "$1" = "select" && choice="Selection" || choice="$(printf "All Screens|Current Screens|Current Window|Selection" | rofi -dmenu -sep '|' -p "Take a picture of? ")"

default_name="$(date +%F_%T_%p)"
screenshots_path="$HOME/Images/Screenshots/"

case "$choice" in
    "All Screens") maim "$screenshots_path"/whole/"$default_name".png && sxiv "$screenshots_path"/whole/"$default_name".png ;;
    "Current Screens") maim "$screenshots_path"/whole/"$default_name".png && sxiv "$screenshots_path"/whole/"$default_name".png ;;
    "Current Window")
        maim --hidecursor --window="$(xdotool getactivewidnow)" --nodectorations=1 "$screenshots_path"/window/"$default_name".png && sxiv "$screenshots_path"/window/"$default_name".png ;;
    "Seleted Window") maim --select --nodectorations=1 "$screenshots_path"/selection/"$default_name".png && sxiv "$screenshots_path"/window/"$default_name".png ;;
    "Selection") maim --hidecursor --select --color=1,0,0,0.6 --padding=0 "$screenshots_path"/selection/"$default_name".png && sxiv "$screenshots_path"/selection/"$default_name".png ;;
esac
