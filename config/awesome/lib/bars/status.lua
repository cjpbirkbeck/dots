-- Returns a function creating a status bar at the top of the screen.

local gears = require("gears")
local awful = require("awful")
local wibox = require("wibox")

local setup_layoutbox = require("lib.widgets.layout")
local setup_taglist = require("lib.widgets.taglist")
local setup_clientlist = require("lib.widgets.tasklist")
local removable = require("lib.widgets.removable_media")
local networking = require("lib.widgets.networking")
local volume = require("lib.widgets.volume")
local mpd = require("lib.widgets.mpd")
local weather = require("lib.widgets.weather")
local time = require("lib.widgets.clock-calendar")

function setup_bar_for_screen(s)
    local bar = awful.wibar({ position = "top", screen = s })

    local screen_layout = setup_layoutbox(s)
    local screen_tags = setup_taglist(s)
    local screen_tasks = setup_clientlist(s)

    bar:setup {
        layout = wibox.layout.align.horizontal,
        {
            layout = wibox.layout.fixed.horizontal,
            screen_layout,
            screen_tags
        },
        screen_tasks,
        {
            layout  = wibox.layout.fixed.horizontal,
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
