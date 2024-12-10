#!/usr/bin/env bash

options="Lock Screen\nSuspend\nSwitch User\nEnd Session\nReboot\nShutdown"

echo -e "$options" | rofi -sep '\n' -dmenu
