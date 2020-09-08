-- Special "mode" for floating windows
local awful = require('awful')
local f = require('lib.func.floating')
local i = 5

-- Floating client controls
awful.keygrabber {
    stop_key = { "q", "Return", "Escape" },
    stop_event = "press",
    keybindings = {
        { {}, "h", function() f.move_floating_client(client.focus, client.focus.x, -i) end },
        { {}, "j", function() f.move_floating_client(client.focus, client.focus.x, i) end },
        { {}, "k", function() f.move_floating_client(client.focus, client.focus.x, -i) end },
        { {}, "l", function() f.move_floating_client(client.focus, client.focus.y, i) end },
        { { control }, "h", function() change_floating_height(client.focus) end },
        { { control }, "j", function() grow_floating_down(client.focus) end },
        { { control }, "k", function() shrink_floating_up(client.focus) end },
        { { control }, "l", function() grow_floating_right(client.focus) end },
        { {}, "n", function() grow_floating(client.focus) end },
        { {}, "p", function() shrink_floating(client.focus) end },
        { {}, "s", function() position_menu:show() end },
        { {}, "z", function() size_menu:show() end },
    },
    start_callback = function(_,_,_,_)
        naughty.notify{ text="Start floating controls" }
    end,
    stop_callback = function(_,_,_,_)
        naughty.notify{ text="End floating controls" }
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

