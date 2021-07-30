--[[
    Main AwesomeWM configuration file
--]]

-- Libraries --

-- If LuaRocks is installed, make sure that packages installed through it are
-- found (e.g. lgi). If LuaRocks is not installed, do nothing.
pcall(require, "luarocks.loader")

-- Standard awesome libraries
local gears = require("gears")
local awful = require("awful")

-- Theme handling library
local beautiful = require("beautiful")

-- Error handling library
require("lib.error-handling")

-- Autofocus library
require("awful.autofocus")

-- Global Variables --

-- Store in a single table, to better keep track them.
rc = {}

-- Directories
rc.home_d   = os.getenv("HOME")
rc.config_d = gears.filesystem.get_dir("config")
rc.exec_d   = rc.config_d .. "bin/"
rc.theme_d  = rc.config_d .. "theme/"

-- Modkey definitions
rc.super   = "Mod4"
rc.alt     = "Mod1"
rc.shift   = "Shift"
rc.control = "Control"

-- Program defaults
rc.launcher     = "rofi -show-icons -show drun"
rc.win_switcher = "rofi -show window"

rc.term_emu      = "st"
rc.float_term_em = "st -c stfloat "
rc.browser       = os.getenv("BROWSER")
rc.email         = "thunderbird"
rc.file_man      = "pcmanfm-qt"
rc.passwords     = "rofi-pass --last-used"

-- Setup the windows manager --

-- Configure the appearance
beautiful.init(rc.theme_d .. "/theme.lua")
beautiful.gap_single_client = false

-- Set layouts
require("main.layouts")

-- Loads programs automatically at startup.
awful.spawn.with_shell(rc.exec_d .. "autoexec.sh")

-- Setup screens, including the status bar.
require("main.screens")

-- Set keybindings and mouse bindings
-- Mouse bindings active only on the root window (area without any clients)
-- root.buttons(require("main.keys.mouse"))
root.keys(require("main.keys.global"))
require("main.keys.floatmode")

-- Window placement rules
require("main.rules")

-- Signals
require("main.signals")
