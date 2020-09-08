-- Returns client specific keybindings.
-- In general, these are mostly for floating windows.
-- Also holds the menus for floating window placement and sizing.

-- Import Libraries
local gears = require("gears")
local awful = require("awful")
local beautiful = require("beautiful")
local naughty = require("naughty")

position_menu = require("lib.menus.position")
size_menu = require("lib.menus.sizes")

-- Modifier keys
super   = "Mod4"
shift   = "Shift"
control = "Control"

-- Options
local reposition_inc = 5
local resize_inc = 5
local min_width = 12
local min_height = 20

-- Functions
-- TODO: These functions should be push into their own file, and refactored to be more concise.
local function focus_tiled_master(c)
    local s = c.screen
    local tiled = s:get_tiled_clients(false)
    local first_tiled = tiled[1]

    awful.client.focus.byidx(0, first_tiled)
end

local function focus_next_tiled(c)
    local s = c.screen
    local tiled = s:get_tiled_clients(false)
    if #tiled > 1 then
        local n = awful.client.next(1)
        while true do
            if not n.floating then break end
            n = awful.client.next(1, n)
        end
        awful.client.focus.byidx(0, n)
    end
end

local function focus_prev_tiled(c)
    local s = c.screen
    local tiled = s:get_tiled_clients(false)
    if #tiled > 1 then
        local p = awful.client.next(-1)
        while true do
            if not p.floating then break end
            p = awful.client.next(1, p)
        end
        awful.client.focus.byidx(0, p)
    end
end

local function swap_tiled_master(c)
    local s = c.screen
    local tiled = s:get_tiled_clients(false)
    local first_tiled = tiled[1]

    c:swap(first_tiled)
end

local function swap_next_tiled(c)
    local s = c.screen
    local tiled = s:get_tiled_clients(false)
    if #tiled > 1 then
        local n = awful.client.next(1)
        while true do
            if not n.floating then break end
            n = awful.client.next(1, n)
        end
        c:swap(n)
    end
end

local function swap_prev_tiled(c)
    local s = c.screen
    local tiled = s:get_tiled_clients(false)
    if #tiled > 1 then
        local p = awful.client.next(-1)
        while true do
            if not p.floating then break end
            p = awful.client.next(1, p)
        end
        c:swap(p)
    end
end

local function focus_next_floating(c)
    if c.floating then
        local s = c.screen
        local other = not c.floating
        local cls = s.clients
        if #cls > 1 then
            local n = awful.client.next(1)
            for i = 1,#cls,1 do
                if n.floating then break end
                n = awful.client.next(1, n)
            end
            awful.client.focus.byidx(0, n)
        end
    end
end

local function swap_next_floating(c)
    if c.floating then
        local s = c.screen
        local other = not c.floating
        local cls = s.clients
        if #cls > 1 then
            local n = awful.client.next(1)
            for i = 1,#cls,1 do
                if n.floating then break end
                n = awful.client.next(1, n)
            end
            c:swap(n)
        end
    end
end

local function focus_prev_floating(c)
    if c.floating then
        local s = c.screen
        local other = not c.floating
        local cls = s.clients
        if #cls > 1 then
            local n = awful.client.next(-1)
            for i = 1,#cls,1 do
                if n.floating then break end
                n = awful.client.next(-1, n)
            end
            awful.client.focus.byidx(0, n)
        end
    end
end

local function swap_prev_floating(c)
    if c.floating then
        local s = c.screen
        local other = not c.floating
        local cls = s.clients
        if #cls > 1 then
            local n = awful.client.next(-1)
            for i = 1,#cls,1 do
                if n.floating then break end
                n = awful.client.next(-1, n)
            end
            c:swap(n)
        end
    end
end

local function move_floating_left(c)
    c.x = c.x - reposition_inc
    awful.placement.no_offscreen(c)
end

local function move_floating_down(c)
    c.y = c.y + reposition_inc
    awful.placement.no_offscreen(c)
end

local function move_floating_up(c)
    c.y = c.y - reposition_inc
    awful.placement.no_offscreen(c)
end

local function move_floating_right(c)
    c.x = c.x + reposition_inc
    awful.placement.no_offscreen(c)
end

local function shrink_floating_left(c)
    local max_width = c.screen.geometry.width
    local new = c.width - resize_inc

    if c.floating and new >= min_width and new <= max_width then c.width = new end
end

local function grow_floating_down(c)
    local max_height = c.screen.geometry.height
    local new = c.height + resize_inc

    if c.floating and new >= min_height and new <= max_height then c.height = new end
end

local function shrink_floating_up(c)
    local max_height = c.screen.geometry.height
    local new = c.height - resize_inc

    if c.floating and new >= min_height and new <= max_height then c.height = new end
end

local function grow_floating_right(c)
    local max_width = c.screen.geometry.width
    local new = c.width + resize_inc

    if c.floating and new >= min_width and new <= max_width then c.width = new end
end

local function focus_next_floating(c)
    local s = c.screen
    local cls = s.clients
    if #cls > 1 then
        local n = awful.client.next(1)
        for i = 1,#cls,1 do
            n = awful.client.next(1, n)
            if n.floating then break end
        end
        awful.client.focus.byidx(0, n)
    end
end

local function grow_floating(c)
    local max_width = c.screen.geometry.width
    local max_height = c.screen.geometry.height
    local new_width = c.width + resize_inc
    local new_height = c.height + resize_inc

    if c.floating and new_width >= min_width and new_width <= max_width and
        new_height >= min_height and new_height <= max_height
        then
        c.width = new_width
        c.height = new_height
    end
end

local function shrink_floating(c)
    local max_width = c.screen.geometry.width
    local max_height = c.screen.geometry.height
    local new_width = c.width - resize_inc
    local new_height = c.height - resize_inc

    if c.floating and new_width >= min_width and new_width <= max_width and
        new_height >= min_height and new_height <= max_height
        then
        c.width = new_width
        c.height = new_height
    end
end

-- Floating client controls
awful.keygrabber {
    stop_key = { "q", "Return", "Escape" },
    stop_event = "press",
    keybindings = {
        { {}, "h", function() move_floating_left(client.focus) end },
        { {}, "j", function() move_floating_down(client.focus) end },
        { {}, "k", function() move_floating_up(client.focus) end },
        { {}, "l", function() move_floating_right(client.focus) end },
        { { control }, "h", function() shrink_floating_left(client.focus) end },
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

local clientkeys = gears.table.join(
    -- Tilled/stacked window controls with the vi direction keys of hjkl
    awful.key({ super }, "h", function(c) if not c.floating then focus_tiled_master(c) end end,
        { description = "Focus tiled master", group = "Client" }),

    awful.key({ super, shift }, "h", function(c) if not c.floating then swap_tiled_master(c) end end,
        { description = "Swap with tiled master", group = "Client"}),

    awful.key({ super }, "j", function(c) if not c.floating then focus_next_tiled(c) end end,
        { description = "Focus next by index", group = "Client"}),

    awful.key({ super, shift }, "j", function(c) if not c.floating then swap_next_tiled(c) end end,
        { description = "Focus next by index", group = "Client"}),

    awful.key({ super }, "k", function(c) if not c.floating then focus_prev_tiled(c) end end,
        { description = "Focus previous by index", group = "Client"}),

    awful.key({ super, shift }, "k", function(c) if not c.floating then swap_prev_tiled(c) end end,
        { description = "Focus previous by index", group = "Client"}),

    awful.key({ super }, "l", function(c) if not c.floating then focus_next_floating(c) end end,
        { description = "Focus next floating client", group = "Client" }),

    awful.key({ super, shift }, "l", awful.client.floating.toggle,
        { description = "Toggle floating", group = "Client" }),

    -- Directional keys left, up, down and right moves floating clients
    -- with shift, resizes floating clients.
    awful.key({ super }, "Left", function(c) if c.floating then move_floating_left(c) end end,
        { description = "Focus first master", group = "Client" }),

    awful.key({ super, shift }, "Left", function(c) if c.floating then shrink_floating_left(c) end end,
        { description = "Swap with master", group = "Client"}),

    awful.key({ super }, "Down", function(c) if c.floating then move_floating_down(c) end end,
        { description = "Focus next by index", group = "Client"}),

    awful.key({ super, shift }, "Down", function(c) if c.floating then grow_floating_down(c) end end,
        { description = "Focus next by index", group = "Client"}),

    awful.key({ super }, "Up", function(c) if c.floating then move_floating_up(c) end end,
        { description = "Focus previous by index", group = "Client"}),

    awful.key({ super, shift }, "Up", function(c) if c.floating then shrink_floating_up(c) end end,
        { description = "Focus previous by index", group = "Client"}),

    awful.key({ super }, "Right", function(c) if c.floating then move_floating_right(c) end end,
        { description = "Focus last slave", group = "Client" }),

    awful.key({ super, shift }, "Right", function(c) if c.floating then grow_floating_right(c) end end,
        { description = "Focus first slave", group = "Client" }),

    -- Absolute keys; these operate on the whole current client list,
    -- regardless of floating status.
    awful.key({ super }, "m", function(c) awful.client.focus.byidx(0, awful.client.getmaster()) end,
        { description = "Swap with master", group = "Client"}),

    awful.key({ super, shift }, "m", function(c) c:swap(awful.client.getmaster()) end,
        { description = "Swap with master", group = "Client"}),

    awful.key({ super }, "[", function (c) awful.client.focus.byidx(-1) end,
        { description = "Focus next by index", group = "Client"}),

    awful.key({ super, "Shift"   }, "[", function (c) awful.client.swap.byidx(-1) end,
        { description = "Swap with next client by index", group = "Client"}),

    awful.key({ super }, "]", function (c) awful.client.focus.byidx(1) end,
        { description = "Focus previous by index", group = "Client"}),

    awful.key({ super, "Shift"   }, "]", function (c) awful.client.swap.byidx(1) end,
        { description = "Swap with previous client by index", group = "Client"}),

    -- General window commands
    awful.key({ super, shift }, "x",
        function (c)
            c.fullscreen = not c.fullscreen
            c:raise()
        end,
        { description = "Toggle fullscreen", group = "Screen"}),

    awful.key({ super }, "n", function (c) c.minimized = true end ,
        { description = "Minimize", group = "Client"}),

    -- Kill Window
    awful.key({ super }, "BackSpace", function (c) c:kill() end,
              {description = "Close", group = "Client"}),

    -- Floating window controls
    -- awful.key({ super }, "Prior", function(c) focus_prev_floating(c) end),

    -- awful.key({ super, shift }, "Prior", function(c) swap_prev_tiled(c) end),

    -- awful.key({ super }, "Next", function(c) focus_next_floating(c) end),

    -- awful.key({ super, shift }, "Next", function(c) swap_next_floating(c) end),

    awful.key({ super }, "t", function(c) if c.floating then c.ontop = not c.ontop end end,
      {description = "Toggle keep on top", group = "Client"}),

    awful.key({ super, shift }, "t", function(c) if c.floating then c.sticky = not c.sticky end end,
      { description = "Toggle sticky mode", group = "Client" }),

    awful.key({ super, control }, "m",
        function (c)
            c.maximized = not c.maximized
            c:raise()
        end ,
        {description = "(un)maximize", group = "client"})

)

return clientkeys
