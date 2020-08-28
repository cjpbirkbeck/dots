local gears = require("gears")
local awful = require("awful")
local beautiful = require("beautiful")

-- Themes define colours, icons, font and wallpapers.
beautiful.init(theme_d .. "/theme.lua")
beautiful.gap_single_client = false

-- Menu
local mouse_menu = awful.menu({
    items = {
        { "Terminal", function() awful.spawn("st") end },
        { "Tmux", function() awful.spawn.with_shell("st -e tmux") end },
        { "Browser", function() awful.spawn("firefox") end },
        { "Email", function() awful.spawn("thunderbird") end },
        { "Other Applications", function() awful.spawn.with_shell("rofi -show drun") end },
        { "Restart", awesome.restart },
        { "Quit", function() awesome.quit() end },
    }
})

-- Left click should bring up menu off all clients,
-- Right click should toggle a menu with selected applications
local mousebinds = gears.table.join(
    awful.button({ }, 1,
        function()
            awful.menu.client_list({ theme = { width = 250 } }, _,
            function (c) return not c.skip_taskbar end)
        end),
    awful.button({ }, 3, function() mouse_menu:toggle() end)
)

return mousebinds
