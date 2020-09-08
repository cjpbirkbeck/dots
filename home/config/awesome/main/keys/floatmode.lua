-- Special mode for controlling floating windows.

local awful = require('awful')
local naughty = require('naughty')

local fn = require('lib.func.floating')
local position_menu = require("lib.menus.position")
local size_menu = require("lib.menus.sizes")

local super = rc.super
local control = rc.control

awful.keygrabber {
    stop_key = { "q", "Return", "Escape" },
    stop_event = "press",
    keybindings = {
        { {}, "h", function() fn.move_left(client.focus) end },
        { {}, "j", function() fn.move_down(client.focus) end },
        { {}, "k", function() fn.move_up(client.focus) end },
        { {}, "l", function() fn.move_right(client.focus) end },
        { { control }, "h", function() fn.shrink_left(client.focus) end },
        { { control }, "j", function() fn.grow_down(client.focus) end },
        { { control }, "k", function() fn.shrink_up(client.focus) end },
        { { control }, "l", function() fn.grow_right(client.focus) end },
        { {}, "n", function() fn.grow(client.focus) end },
        { {}, "p", function() fn.shrink(client.focus) end },
        { {}, "s", function() position_menu:show() end },
        { {}, "e", function() awful.placement.centered() end },
        { {}, "z", function() size_menu:show() end },
    },
    start_callback = function(_,_,_,_)
        naughty.notify{ text="Starting floating controls" }
    end,
    stop_callback = function(_,_,_,_)
        naughty.notify{ text="Ending floating controls" }
    end,
    root_keybindings = {
        { { super, control }, "l",
        function(self)
            if client.focus and not client.focus.floating then
                root.fake_input('key_press', 'q')
                root.fake_input('key_release', 'q')
            end
        end }
    }
}

