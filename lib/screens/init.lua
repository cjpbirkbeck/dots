local gears = require("gears")
local awful = require("awful")
local beautiful = require("beautiful")

local tag_symbols = require("lib.vars.tag_symbols")
local setup_status_bar = require("lib.bars.status")

local function set_wallpaper(s)
    -- Wallpaper
    if beautiful.wallpaper then
        local wallpaper = beautiful.wallpaper
        -- If wallpaper is a function, call it with the screen
        if type(wallpaper) == "function" then
            wallpaper = wallpaper(s)
        end
        gears.wallpaper.maximized(wallpaper, s, true)
    end
end

local function set_tags(s, tags)
    for i, tag in ipairs(tags) do
        awful.tag.add(
            tag[1], {
               screen = s,
               layout = awful.layout.layouts[1]
            }
        )
    end
end

-- Re-set wallpaper when a screen's geometry changes (e.g. different resolution)
screen.connect_signal("property::geometry", set_wallpaper)

awful.screen.connect_for_each_screen(
    function(s)
        set_wallpaper(s)
        set_tags(s, tag_symbols)
        awful.tag.viewtoggle(s.tags[1])
        setup_status_bar(s)
    end)
