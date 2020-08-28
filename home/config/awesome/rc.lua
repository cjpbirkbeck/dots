-- Main AwesomeWM configuration file

-- Libraries
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

-- Error handling
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

-- Global Variables
-- These don't seem to travel to other files, might have to delete theme.

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

-- Loads programs automatically at startup.
awful.spawn.with_shell(exec_d .. "autoexec.sh")

-- Set screens, includin the status bar
require("lib.screens")

-- Mouse bindings
-- Active only clicking on the root window (areas without any clients)
root.buttons(require("lib.keys.mouse"))

-- Global keybindings
root.keys(require("lib.keys.global"))

-- Rules
awful.rules.rules = require("lib.rules.lua")

-- Signals
require("lib.signals")
