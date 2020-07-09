#!/usr/bin/env bash

arg="${1}"
echo "$arg"
file_name="$(basename "${arg}")"
file_path="$(dirname "${arg}")"
echo "$file_name"
echo "$file_path"

ext="${file_name##*.}"
prefix="${file_name%%.*}"

new_prefix="$(rofi -dmenu -p "Enter new name")"

rename --no-overwrite "${prefix}" "${new_prefix}" "${file_path}/${file_name}"
