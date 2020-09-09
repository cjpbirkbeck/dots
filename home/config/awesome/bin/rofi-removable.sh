#!/usr/bin/env dash
# Print out any media mounted with udiskie(1), and ask if it should be removed or not.

test "$(find /run/media/"$USER" -maxdepth 1 -mindepth 1 | wc -l)" -eq 0 && \
    notify-desktop "Error" "No removable drives are found!" && exit

disk="$(udiskie-info /run/media/"$USER"/* --output "\"{id_label}\" \"{mount_path}\" {device_file} {id_uuid}" | \
    rofi -dmenu -p "Umount which drive?" | sed -E -e 's/"(.*)" "(.*)".*/\2/')"

test -n "$disk" || exit 0

reply="$(printf "Yes|No" | rofi -dmenu -sep '|' -p "Umount?" -msg "$disk" -only-match -no-custom)"

test "$reply" = "Yes" && udiskie-umount --detach "$disk"
