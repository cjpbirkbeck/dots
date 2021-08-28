#!/usr/bin/env bash
# Print a summary of my taskwarrior task.

printf "\e[30;47mTasks and Todo summary:\e[m\n\n"

# Various tasks
total_count="$(task count)"
active_count="$(task +ACTIVE count)"
blocked_count="$(task +BLOCKED count)"
completed_count="$(task +COMPLETED count)"
outstanding_count="$(( total_count - active_count ))"
today_count="$(task +TODAY count)"
week_count="$(task +WEEK count)"
month_count="$(task +MONTH count)"

printf "\e[34mGeneral:\e[m\n"
printf "There are %s tasks, of which %s are still outstanding.\n" "$total_count" "$outstanding_count"
printf "Currently, %s are active and %s are blocked.\n" "$active_count" "$blocked_count"
printf "There are %s tasks done.\n" "$completed_count"
printf "Today, %s are due, this week %s are due and this month %s are due.\n" "$today_count" "$week_count" "$month_count"

printf "\n\e[34mProject summary:\e[m\n"
task summary
