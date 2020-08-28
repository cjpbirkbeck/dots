-- Returns a function creating a status bar at the top of the screen.

local gears = require("gears")
local awful = require("awful")
local wibox = require("wibox")

local setup_layoutbox  = require("lib.widgets.layout")
local setup_taglist    = require("lib.widgets.taglist")
local setup_clientlist = require("lib.widgets.tasklist")
local removable        = require("lib.widgets.removable_media")
local networking       = require("lib.widgets.networking")
local volume           = require("lib.widgets.volume")
local mpd              = require("lib.widgets.mpd")
local weather          = require("lib.widgets.weather")
local time             = require("lib.widgets.clock-calendar")

function setup_bar_for_screen(s)
    local bar = awful.wibar({ position = "top", screen = s })

    s.systray = wibox.widget.systray()
    s.systray.visible = false
    s.promptbox = awful.widget.prompt()

    bar:setup {
        layout = wibox.layout.align.horizontal,
        {
            layout = wibox.layout.fixed.horizontal,
            setup_layoutbox(s),
            setup_taglist(s),
            s.promptbox
        },
        setup_clientlist(s),
        {
            layout  = wibox.layout.fixed.horizontal,
            s.systray,
            removable,
            networking,
            volume,
            -- mpd,
            -- weather,
            time
        }
    }

    return bar
end

return setup_bar_for_screen
