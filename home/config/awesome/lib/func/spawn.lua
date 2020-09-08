-- Holds functions for spawning external programs

local awful = require("awful")
local spawn = require("awful.spawn")

local terminal = [[
    if command -v st; then
        st
    else
        xterm
    fi
]]

local float_term = [[
    if command -v st; then
        st -c st-float
    else
        xterm -class xterm-float
    fi
]]

local multiplexer = [[
    tmux new-session -d -s main
]]

local t = {}

t.launcher = function() spawn("rofi -show-icons -show drun") end
t.switcher = function() spawn("rofi -show-icons -show window") end

t.term_emu = function() spawn.with_shell(terminal) end
t.float_term = function() spawn.with_shell(float_term) end
t.term_mplex = function() spawn.with_shell(multiplexer) end

t.browser = function() spawn.with_shell("qutebrowser") end
t.email = function() spawn("thunderbird") end
t.file_man = function() spawn("pcmanfm-qt") end
t.sys_mon = function() spawn("st -e gotop") end
