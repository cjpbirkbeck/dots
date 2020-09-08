-- Hold definitions that should available throughout these configuration files.

local gears = require("gears")

-- Directories
home_d   = os.getenv("HOME")
config_d = gears.filesystem.get_dir("config")
exec_d   = config_d .. "bin/"
lib_d    = config_d .. "lib/"
theme_d  = config_d .. "theme/"

-- Modifier keys
super   = "Mod4"
shift   = "Shift"
control = "Control"
alt     = "Mod1"

