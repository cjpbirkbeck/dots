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
        { {}, "e", function() awful.placement.centered() end },
        { {}, "s",
            function()
                local c = client.focus
                position_menu:show({coords = { x = c.x, y = c.y }})
            end },
        { {}, "z",
            function()
                local c = client.focus
                size_menu:show({coords = { x = c.x, y = c.y }})
            end },
    },
    start_callback = function(_,_,_,_)
        if client.focus and client.focus.floating then
            naughty.notify{ text="Entering floating window mode" }
        end
    end,
    stop_callback = function(_,_,_,_)
        if client.focus and client.focus.floating then
            naughty.notify{ text="Quitting floating window mode" }
        end
    end,
    -- Make sure that the mode only occurs with floating clients
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

