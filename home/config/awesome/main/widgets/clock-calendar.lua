local gears = require("gears")
local awful = require("awful")
local wibox = require("wibox")

-- Calendar widget
-- When hovered, given a calendar of the current month with the current day highlighted.
-- Right clicking shows a year calendar.
local clock = wibox.widget.textclock("  %I:%M:%S %p", 1)
clock.font = "sans bold 10"

local month_calendar = awful.widget.calendar_popup.month({
    position = "tr",
    screen = awful.screen.focused({}),
    start_sunday = true,
    week_numbers = true
})

local year_calendar = awful.widget.calendar_popup.year({
    start_sunday = true,
    week_numbers = true
})

clock:connect_signal("mouse::enter", function() month_calendar:call_calendar(0, "tr", awful.screen.focused()):toggle() end)
clock:connect_signal("mouse::leave", function() month_calendar:call_calendar(0, "tr", awful.screen.focused()):toggle() end)
clock:connect_signal("button::press", function() year_calendar:call_calendar(0, "cc", awful.screen.focused()):toggle() end)

return clock
