-- Returns a function creating a status bar at the top of the screen.

local gears = require("gears")
local awful = require("awful")
local wibox = require("wibox")

local layoutbox  = require("lib.widgets.layout")
local taglist    = require("lib.widgets.taglist")
local clientlist = require("lib.widgets.tasklist")
local removable  = require("lib.widgets.removable_media")
local volume     = require("lib.widgets.volume")
local keyboard   = require("lib.widgets.keyboard")
local weather    = require("lib.widgets.weather")
local time       = require("lib.widgets.clock-calendar")

function setup_bar_for_screen(s)
    local bar = awful.wibar({ position = "top", screen = s })

    s.systray = wibox.widget.systray()
    s.taglist = taglist
    s.systray.visible = false
    s.promptbox = awful.widget.prompt({
        prompt = "> "
    })

    bar:setup {
        layout = wibox.layout.align.horizontal,
        {
            layout = wibox.layout.fixed.horizontal,
            layoutbox(s),
            s.taglist(s),
            s.promptbox
        },
        clientlist(s),
        {
            layout  = wibox.layout.fixed.horizontal,
            s.systray,
            removable,
            keyboard,
            volume,
            weather,
            time
        }
    }

    return bar
end

return setup_bar_for_screen
