#!/usr/bin/env dash

switch_user="Switch user <small><i>(Change to another user with current user logged on.</i></small>)"
restart="Restart <small><i>(Restarts AwesomeWM.)</i></small>"
exit_wm="Exit <small><i>(Exits AwesomeWM and returns to LightDM<sup>1</sup>.)</i></small>"
lock="Lock <small><i>(Locks machine<sup>1</sup>.)</i></small>"
suspend_wm="Suspend <small><i>(Suspends machine<sup>1</sup>.)</i></small>"
reboot="Reboot <small><i>(Reboots machine<sup>2</sup>.)</i></small>"
shutdown="Shutdown <small><i>(Shutdown machine<sup>2</sup>.)</i></small>"

msg="<sup>1</sup> Requires password entry. <sup>2</sup> All current work will be lost!"

action="$(printf "%s|%s|%s|%s|%s|%s|%s" "$switch_user" "$restart" "$exit_wm" "$lock" "$suspend_wm" "$reboot" "$shutdown" | rofi -dmenu -i -sep '|' -p "Which action?" -mesg "$msg" -markup-rows | cut -d " " -f 1)"

case "$action" in
    "Switch") dm-tool switch-to-greeter ;;
    "Restart") awesome-client "awesome-restart" ;;
    "Exit") awesome-client "awesome-quit()" ;;
    "Lock") xautolock -locknow ;;
    "Suspend") systemctl suspend ;;
    "Reboot") systemctl reboot ;;
    "Shutdown") systemctl poweroff ;;
    "") ;;
esac
