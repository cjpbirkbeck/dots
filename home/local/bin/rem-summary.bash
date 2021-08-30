#!/usr/bin/env bash
# Print out any events from rem(1) for today, next week (i.e. next 7 days) and
# next month (i.e. next 28 days).

printf "\e[30;47mAppointment and Event Agenda:\e[m\n\n"
printf "\e[34mReminders for today (%s):\e[m\n" "$(date '+%d %B %Y')"
rem
printf "\n"

# Print reminders for next week (i.e. tomorrow and the next 6 days).
printf "\e[34mReminders for next week:\e[m\n"
tomorrow="$(( "$(date '+%s')" + 86400 ))" # Add a day to today
# Print all events from tomorrow and the next 6 days.
rem "$(date --date=@${tomorrow} '+%F')" "*6" | grep -v "No reminders."
printf "\n"

# Print reminders for the next month (i.e. from the next 7 days and 23 days).
printf "\e[34mReminders for next month:\e[m\n"
next_week="$(( "$(date '+%s')" + 518400 ))" # Add 7 days to today
# Print all events from the day next week and the next 3 weeks.
rem "$(date --date=@${next_week} '+%F')" "*24" | grep -v "No reminders."
