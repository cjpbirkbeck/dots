-- Main AwesomeWM configuration file

-- Libraries
-- If LuaRocks is installed, make sure that packages installed through it are
-- found (e.g. lgi). If LuaRocks is not installed, do nothing.
pcall(require, "luarocks.loader")

-- Standard awesome library
local gears = require("gears")
local awful = require("awful")

-- Theme handling library
local beautiful = require("beautiful")

-- Error handling
require("lib.error-handling")

-- Global Variables
-- Store in a single table, to better track them.
rc = {}

-- Directories
rc.home_d   = os.getenv("HOME")
rc.config_d = gears.filesystem.get_dir("config")
rc.exec_d   = rc.config_d .. "bin/"
rc.theme_d  = rc.config_d .. "theme/"

-- Themes define colours, icons, font and wallpapers.
beautiful.init(rc.theme_d .. "/theme.lua")
beautiful.gap_single_client = false

-- Set layouts
require("main.layouts")

-- Loads programs automatically at startup.
awful.spawn.with_shell(rc.exec_d .. "autoexec.sh")

-- Set screens, including the status bar.
require("main.screens")

-- Set keybindings and mouse bindings
-- Mouse bindings active only on the root window (area without any clients)
root.buttons(require("main.keys.mouse"))
root.keys(require("main.keys.global"))

-- Window placement rules
require("main.rules")

-- Signals
require("main.signals")
