local gears = require("gears")
local awful = require("awful")

-- MPD widget
local mpdstatus = awful.widget.watch(exec_d .. 'mpd-report.sh', 1)

mpdstatus.font = "fontawesome bold 10"
mpdstatus_t = awful.tooltip {
    objects = { mpdstatus },
    timer_function = function() awful.spawn.easy_async_with_shell("mpc status", function(out) m_text = out end) return m_text end
}

return mpdstatus
