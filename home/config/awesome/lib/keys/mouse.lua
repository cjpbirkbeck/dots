local gears = require("gears")
local awful = require("awful")
local beautiful = require("beautiful")

-- Themes define colours, icons, font and wallpapers.
beautiful.init(theme_d .. "/theme.lua")
beautiful.gap_single_client = false

-- Directories
home_d   = os.getenv("HOME")
config_d = gears.filesystem.get_dir("config")
exec_d   = config_d .. "bin/"
lib_d    = config_d .. "lib/"
theme_d  = config_d .. "theme/"

-- Menu
local mouse_menu = awful.menu({
    items = {
        { "Terminal", function() awful.spawn("st") end },
        { "Tmux", function() awful.spawn.with_shell("st -e tmux") end },
        { "Browser", function() awful.spawn("firefox") end },
        { "Email", function() awful.spawn("thunderbird") end },
        { "Other Applications", function() awful.spawn.with_shell("rofi -show-icons -show drun") end },
        { "Restart", awesome.restart },
        { "Quit", function() awesome.quit() end },
        { "Reboot", function() awful.spawn.with_shell(exec_d .. "portable_reboot.sh") end },
        { "Shutdown", function() awful.spawn.with_shell(exec_d .. "portable_poweroff.sh") end },
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
