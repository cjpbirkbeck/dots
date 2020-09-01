#!/bin/sh

OS="$(uname)"

reboot_function () {
    test "$OS" = "FreeBSD" && shutdown -r now

    test "$OS" = "Linux" && system reboot
}

shutdown_function () {
    test "$OS" = "FreeBSD" && shutdown -p now

    test "$OS" = "Linux" && system poweroff
}
switch_user="Switch user <small><i>(Change to another user with current user logged on)</i></small>"
restart="Restart <small><i>(Restarts AwesomeWM)</i></small>"
exit_wm="Exit <small><i>(Exits AwesomeWM and returns to LightDM)</i></small>"
lock="Lock <small><i>(Locks machine)</i></small>"
suspend_wm="Suspend <small><i>(Suspends machine)</i></small>"
reboot="Reboot <small><i>(Reboots machine)</i></small>"
shutdown="Shutdown <small><i>(Shutdown machine)</i></small>"

action="$(printf "%s|%s|%s|%s|%s|%s|%s" "$switch_user" "$restart" "$exit_wm" "$lock" "$suspend_wm" "$reboot" "$shutdown" \
    | rofi -dmenu -i -sep '|' -p "Which action?" -markup-rows | cut -d " " -f 1)"

case "$action" in
    "Switch") dm-tool switch-to-greeter ;;
    "Restart") awesome-client "awesome.restart()" ;;
    "Exit") awesome-client "awesome.quit()" ;;
    "Lock") xautolock -locknow ;;
    "Suspend") systemctl suspend ;;
    "Reboot") reboot_function ;;
    "Shutdown") shutdown_function ;;
    *) ;;
esac
