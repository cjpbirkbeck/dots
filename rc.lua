-- AwesomeWM configuration file

-- Libraries {{{
-- If LuaRocks is installed, make sure that packages installed through it are
-- found (e.g. lgi). If LuaRocks is not installed, do nothing.
pcall(require, "luarocks.loader")

-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
require("awful.autofocus")
require("awful.keygrabber")
-- Widget and layout library
local wibox = require("wibox")
-- Theme handling library
local beautiful = require("beautiful")
-- Notification library
local naughty = require("naughty")
local menubar = require("menubar")
local hotkeys_popup = require("awful.hotkeys_popup")
-- Enable hotkeys help widget for VIM and other apps
-- when client with a matching name is opened:
require("awful.hotkeys_popup.keys")

-- Load custom libraries
local deck = require("lib.layouts.deck")
local keys = require("lib.keys.global")
local rules = require("lib.rules.lua")
local titlebars = require("lib.bars.title")

-- }}}

-- {{{ Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
    naughty.notify({ preset = naughty.config.presets.critical,
                     title = "Oops, there were errors during startup!",
                     text = awesome.startup_errors })
end

-- Handle runtime errors after startup
do
    local in_error = false
    awesome.connect_signal("debug::error", function (err)
        -- Make sure we don't go into an endless error loop
        if in_error then return end
        in_error = true

        naughty.notify({ preset = naughty.config.presets.critical,
                         title = "Oops, an error happened!",
                         text = tostring(err) })
        in_error = false
    end)
end
-- }}}

-- {{{ Variables

-- Directories
home_d   = os.getenv("HOME")
config_d = gears.filesystem.get_dir("config")
exec_d   = config_d .. "bin/"
lib_d    = config_d .. "lib/"
theme_d  = config_d .. "theme/"

-- Themes define colours, icons, font and wallpapers.
beautiful.init(theme_d .. "/theme.lua")

beautiful.gap_single_client = false

-- Table of layouts to cover with awful.layout.inc, order matters.
awful.layout.layouts = {
    awful.layout.suit.max,
    deck,
    awful.layout.suit.tile,
    deck.horizontal,
    awful.layout.suit.tile.bottom
}

fwin_menu = {
    position = {
        { "Centered", awful.placement.centered },
        { "Bottom Right", awful.placement.bottom_right },
        { "Top Left", awful.placement.top_left },
        { "Left", awful.placement.left },
        { "Right", awful.placement.right },
        { "Bottom Left", awful.placement.bottom_left },
        { "Bottom", awful.placement.bottom_right }
    },
    sizes = {
        { "256x144  [16:9]", 256, 144 },
        { "640x360  [16:9]", 640, 360 },
        { "960x560  [16:9]", 960, 560 },
        { "1280x720 [16:9]", 1280, 720 },
        { "640x480  [4:3]", 640, 480 },
        { "800x600  [4:3]", 800, 600 },
        { "960x720  [4:3]", 960, 720 },
        { "1024x768 [4:3]", 1024, 768 },
        { "1024x576 [16:10]", 1024, 576 },
        { "1152x648 [16:10]", 1152, 648 },
        { "1280x800 [16:10]", 1280, 800 },
        { "1024x576 [16:10]", 1024, 576 },
    }
}

-- }}}

-- Autoloads {{{

-- Loads programs automatically at startup.
awful.spawn.with_shell(exec_d .. "autoexec.sh")

-- }}}

-- {{{ Menus

pos_items = {
    { "Centered",
        function()
            local c = client.focus
            awful.placement.centered(c)
        end
    },
    { "Bottom Right",
        function()
            local c = client.focus
            awful.placement.bottom_right(c)
        end
    },
    { "Top Left",
        function()
            local c = client.focus
            awful.placement.top_left(C)
        end
    },
    { "Left",
        function()
            local c = client.focus
            awful.placement.left(C)
        end
    },
    { "Top Right",
        function()
            local c = client.focus
            awful.placement.top_right(C)
        end
    },
    { "Left",
        function()
            local c = client.focus
            awful.placement.left(C)
        end
    },
    { "Right",
        function()
            local c = client.focus
            awful.placement.right(C)
        end
    },
    { "Bottom Left",
        function()
            local c = client.focus
            awful.placement.bottom_left(C)
        end
    },
    { "Bottom",
        function()
            local c = client.focus
            awful.placement.bottom_right(C)
        end
    },
}

size_items = {
    { "16:9 256x144",
        function()
            local c = client.focus
            c.height = 144
            c.width = 256
        end
    },
    { "16:9 640x360",
        function()
            local c = client.focus
            c.height = 360
            c.width = 640
        end
    },
    { "16:9 960x560",
        function()
            local c = client.focus
            c.height = 560
            c.width = 960
        end
    },
    { "16:9 1280x720",
        function()
            local c = client.focus
            c.height = 720
            c.width = 1280
        end
    },
    { "4:3 640x480",
        function()
            local c = client.focus
            c.height = 480
            c.width = 640
        end
    },
    { "4:3 800x600",
        function()
            local c = client.focus
            c.height = 600
            c.width = 800
        end
    },
    { "4:3 960x720",
        function()
            local c = client.focus
            c.height = 720
            c.width = 960
        end
    },
    { "4:3 1024x768",
        function()
            local c = client.focus
            c.height = 768
            c.width = 1024
        end
    },
    { "16:10 1024x576",
        function()
            local c = client.focus
            c.height = 576
            c.width = 1024
        end
    },
    { "16:10 1152x648",
        function()
            local c = client.focus
            c.height = 648
            c.width = 1152
        end
    },
    { "16:10 1280x800",
        function()
            local c = client.focus
            c.height = 800
            c.width = 1280
        end
    },
    { "16:10 1024x576",
        function()
            local c = client.focus
            c.height = 576
            c.width = 1024
        end
    },
}

function create_pos_menu(items)
    local menu = awful.menu({})

    for _, e in pairs(items) do
        menu.add({e[1],
            function()
                local c = client.focus
                e[2](c)
            end
        })
    end

    return menu
end

function create_size_menu(items)
    local menu = awful.menu({})

    for _, e in pairs(items) do
        menu.add({e[1],
            function()
                local c = client.focus
                c.height = e[3]
                c.width = e[2]
            end
        })
    end

    return menu
end

float_controls = awful.menu({
    items = {
        { "Position", create_pos_menu(fwin_menu.position) },
        { "Size", create_size_menu(fwin_menu.sizes) }
    }
})

-- }}}

-- {{{ Wibar
require("lib.screens")
-- }}}

-- {{{ Mouse bindings

root.buttons(gears.table.join(
    awful.button({}, 1, function() awful.spawn("st") end),
    awful.button({ }, 3, function () awful.spawn.with_shell("export XDG_CURRENT_DESKTOP=kde && rofi -show combi window drun run -combi-modi \"window,drun,run\"") end)
))

-- }}}

-- {{{ Key bindings

-- Set keys
root.keys(keys)
-- }}}

-- {{{ Rules
-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules = rules
-- }}}

-- {{{ Signals
require("lib.signals")
-- }}}
