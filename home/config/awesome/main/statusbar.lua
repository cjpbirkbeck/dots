-- Returns a function creating a status bar at the top of the screen.

local gears = require("gears")
local awful = require("awful")
local wibox = require("wibox")

local layoutbox  = require("main.widgets.layout")
local taglist    = require("main.widgets.taglist")
local clientlist = require("main.widgets.tasklist")
local removable  = require("main.widgets.removable_media")
local volume     = require("main.widgets.volume")
local keyboard   = require("main.widgets.keyboard")
local weather    = require("main.widgets.weather")
local time       = require("main.widgets.clock-calendar")
local mytemp     = lain.widget.temp()
-- local fs_widget = require("awesome-wm-widgets.fs-widget.fs-widget")

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
            mytemp,
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
