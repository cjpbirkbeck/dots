#!/usr/bin/env bash
# Print out events and todos for today, this week and this months.

printf "\e[34mReminders for today (%s):\e[m\n" "$(date '+%d %B %Y')"
rem
printf "There are %s tasks due today." "$(task +TODAY count)"
printf "\n"

# Print reminders for next week (i.e. tomorrow and the next 6 days).
printf "\e[34mReminders for next week:\e[m\n"
tomorrow="$(( "$(date '+%s')" + 86400 ))" # Add a day to today
# Print all events from tomorrow and the next 6 days.
rem "$(date --date=@${tomorrow} '+%F')" "*6" | grep -v "No reminders."
printf "There are %s tasks due for next week." "$(task +WEEK count)"
printf "\n"

# Print reminders for the next month (i.e. from the next 7 days and 23 days).
printf "\e[34mReminders for next month:\e[m\n"
next_week="$(( "$(date '+%s')" + 518400 ))" # Add 7 days to today
# Print all events from the day next week and the next 3 weeks.
rem "$(date --date=@${next_week} '+%F')" "*24" | grep -v "No reminders."
printf "There are %s tasks due for next month." "$(task +MONTH count)"
printf "\n"

total_count="$(task count)"
active_count="$(task +ACTIVE count)"
blocked_count="$(task +BLOCKED count)"
completed_count="$(task +COMPLETED count)"
outstanding_count="$(( total_count - completed_count ))"

printf "\n\e[34mTodo summary:\e[m\n"
printf "There are %s tasks, of which %s are still outstanding.\n" "$total_count" "$outstanding_count"
printf "Currently, %s are active and %s are blocked.\n" "$active_count" "$blocked_count"
printf "There are %s tasks done.\n" "$completed_count"

printf "\n\e[34mProject summary:\e[m\n"
task summary
