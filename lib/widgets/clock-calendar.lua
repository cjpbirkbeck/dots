local gears = require("gears")
local awful = require("awful")

-- Calendar widget
-- When hovered, given a calendar of the current month with the current day highlighted.
-- Right clicking shows a year calendar.
local clock = wibox.widget.textclock("  %I:%M:%S %p", 1)
clock.font = "sans bold 10"

local month_calendar = awful.widget.calendar_popup.month({
    start_sunday = true,
    week_number = true
})

local year_calendar = awful.widget.calendar_popup.year({
    start_sunday = true,
    week_number = true
})

month_calendar:attach(clock, "tr")
clock:connect_signal("button::press", function() year_calendar:toggle() end)

return clock
