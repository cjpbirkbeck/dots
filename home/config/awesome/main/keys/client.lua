-- Returns client specific keybindings.
-- In general, these are mostly for floating windows.
-- Also holds the menus for floating window placement and sizing.

-- Import Libraries
local gears = require("gears")
local awful = require("awful")
local beautiful = require("beautiful")
local naughty = require("naughty")

local fltfn = require("lib.func.floating")
local tldfn = require("lib.func.tiled")

-- Modifier keys
super   = "Mod4"
shift   = "Shift"
control = "Control"

-- Functions
-- TODO: These functions should be push into their own file, and refactored to be more concise.

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

local clientkeys = gears.table.join(
    -- Tilled/stacked window controls with the vi direction keys of hjkl
    awful.key({ super }, "h", function(c) if not c.floating then tldfn.focus_master(c) end end,
        { description = "Focus tiled master", group = "Client" }),

    awful.key({ super, shift }, "h", function(c) if not c.floating then tldfn.swap_master(c) end end,
        { description = "Swap with tiled master", group = "Client"}),

    awful.key({ super }, "j", function(c) if not c.floating then tldfn.focus_next(c) end end,
        { description = "Focus next by index", group = "Client"}),

    awful.key({ super, shift }, "j", function(c) if not c.floating then tldfn.swap_next(c) end end,
        { description = "Focus next by index", group = "Client"}),

    awful.key({ super }, "k", function(c) if not c.floating then tldfn.focus_prev(c) end end,
        { description = "Focus previous by index", group = "Client"}),

    awful.key({ super, shift }, "k", function(c) if not c.floating then tldfn.swap_prev(c) end end,
        { description = "Focus previous by index", group = "Client"}),

    awful.key({ super }, "l", function(c) if not c.floating then focus_next_floating(c) end end,
        { description = "Focus next floating client", group = "Client" }),

    awful.key({ super, shift }, "l", awful.client.floating.toggle,
        { description = "Toggle floating", group = "Client" }),

    -- Directional keys left, up, down and right moves floating clients
    -- with shift, resizes floating clients.
    awful.key({ super }, "Left", function(c) if c.floating then fltfn.move_left(c) end end,
        { description = "Focus first master", group = "Client" }),

    awful.key({ super, shift }, "Left", function(c) if c.floating then fltfn.shrink_left(c) end end,
        { description = "Swap with master", group = "Client"}),

    awful.key({ super }, "Down", function(c) if c.floating then fltfn.move_down(c) end end,
        { description = "Focus next by index", group = "Client"}),

    awful.key({ super, shift }, "Down", function(c) if c.floating then fltfn.grow_down(c) end end,
        { description = "Focus next by index", group = "Client"}),

    awful.key({ super }, "Up", function(c) if c.floating then fltfn.move_up(c) end end,
        { description = "Focus previous by index", group = "Client"}),

    awful.key({ super, shift }, "Up", function(c) if c.floating then fltfn.shrink_up(c) end end,
        { description = "Focus previous by index", group = "Client"}),

    awful.key({ super }, "Right", function(c) if c.floating then fltfn.move_right(c) end end,
        { description = "Focus last slave", group = "Client" }),

    awful.key({ super, shift }, "Right", function(c) if c.floating then fltfn.grow_right(c) end end,
        { description = "Focus first slave", group = "Client" }),

    awful.key({ super }, "e", function(c) if c.floating then awful.placement.centered() end end,
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
    awful.key({ super, "Control" }, "h", function (c) c:move_to_screen() end,
              {description = "Move focused to previous screen", group = "Screen"}),

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
