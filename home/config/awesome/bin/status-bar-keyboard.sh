#!/bin/sh
# Prints out the keyboard toggle states.

awk_script=' /00:/ {
    if ($4 == "on" || $8 == "on" || $12 == "on") {
        printf " " ;
    } else {
        exit ;
    }
    if ($4 == "on") {
        printf "C";
    }
    if ($8 == "on") {
        printf "N";
    }
    if ($12 == "on") {
        printf "S";
    }
    printf " \n";
} '

xset q | awk "$awk_script"
