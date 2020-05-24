-- Returns client specific keybindings.
-- In general, these are mostly for floating windows.
-- Also holds the menus for floating window placement and sizing.

-- Import Libraries
local gears = require("gears")
local awful = require("awful")
local beautiful = require("beautiful")
local naughty = require("naughty")

-- Modifier keys
super   = "Mod4"
shift   = "Shift"
control = "Control"

-- Options
local reposition_inc = 5
local resize_inc = 5
local min_width = 12
local min_height = 20

local fwin_menu = {
    position = {
        { "Centered", awful.placement.centered },
        { "Bottom Right", awful.placement.bottom_right },
        { "Top Left", awful.placement.top_left },
        { "Left", awful.placement.left },
        { "Right", awful.placement.right },
        { "Bottom Left", awful.placement.bottom_left },
        { "Bottom", awful.placement.bottom_right }
    },
    sizes = {
        { "256x144  [16:9]", 256, 144 },
        { "640x360  [16:9]", 640, 360 },
        { "960x560  [16:9]", 960, 560 },
        { "1280x720 [16:9]", 1280, 720 },
        { "640x480  [4:3]", 640, 480 },
        { "800x600  [4:3]", 800, 600 },
        { "960x720  [4:3]", 960, 720 },
        { "1024x768 [4:3]", 1024, 768 },
        { "1024x576 [16:10]", 1024, 576 },
        { "1152x648 [16:10]", 1152, 648 },
        { "1280x800 [16:10]", 1280, 800 },
        { "1024x576 [16:10]", 1024, 576 },
    }
}

local function create_pos_menu(items)
    elements = {}

    for i, e in pairs(items) do
        elements[i] = { e[1],
            function()
                local c = client.focus
                e[2](c)
            end
        }
    end

    return awful.menu(elements)
end

local function create_size_menu(items)
    elements = {}

    for i, e in pairs(items) do
        elements[i] = { e[1],
            function()
                local c = client.focus
                c.height = e[3]
                c.width = e[2]
            end
        }
    end

    return awful.menu(elements)
end

local size_controls = create_size_menu(fwin_menu.sizes)
local pos_controls = create_pos_menu(fwin_menu.position)

local function h_key(c)
    if c.floating then
        c.x = c.x - reposition_inc
        awful.placement.no_offscreen(c)
    else
        local s = c.screen
        local tiled = s:get_tiled_clients(false)
        local first_tiled = tiled[1]

        awful.client.focus.byidx(0, first_tiled)
    end
end

local function j_key(c)
    if c.floating then
        c.y = c.y + reposition_inc
        awful.placement.no_offscreen(c)
    else
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
end

local function k_key(c)
    if c.floating then
        c.y = c.y - reposition_inc
        awful.placement.no_offscreen(c)
    else
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
end

local function l_key(c)
    if c.floating then
        if c.floating then c.x = c.x + reposition_inc end

        awful.placement.no_offscreen(c)
    else
        local s = c.screen
        local tiled = s:get_tiled_clients(false)
        if #tiled > 1 then
            local next_tiled = tiled[2]
            awful.client.focus.byidx(0, next_tiled)
        end
    end
end

local function h_shift_key(c)
    if c.floating then
        local max_width = c.screen.geometry.width
        local new = c.width - resize_inc

        if c.floating and new >= min_width and new <= max_width then c.width = new end
    else
        local s = c.screen
        local tiled = s:get_tiled_clients(false)
        local first_tiled = tiled[1]

        c:swap(first_tiled)
    end
end

local function j_shift_key(c)
    if c.floating then
        local max_height = c.screen.geometry.height
        local new = c.height + resize_inc

        if c.floating and new >= min_height and new <= max_height then c.height = new end
    else
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
end

local function k_shift_key(c)
    if c.floating then
        local max_height = c.screen.geometry.height
        local new = c.height - resize_inc

        if c.floating and new >= min_height and new <= max_height then c.height = new end
    else
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
end

local function l_shift_key(c)
    if c.floating then
        local max_width = c.screen.geometry.width
        local new = c.width + resize_inc

        if c.floating and new >= min_width and new <= max_width then c.width = new end
    else
        local s = c.screen
        local tiled = s:get_tiled_clients(false)
        if #tiled > 1 then
            local last_tiled = tiled[#tiled]
            awful.client.focus.byidx(0, last_tiled)
        end
    end
end

local clientkeys = gears.table.join(
    -- Tilled/stacked window controls
    -- Relative controls; key will act different depending on the floating context.
    -- Covers both the vim direction keys of hjkl and standard left, up, down and right.
    awful.key({ super }, "h", function(c) h_key(c) end,
        { description = "Focus first master", group = "Client" }),

    awful.key({ super, shift }, "h", function(c) h_shift_key(c) end,
        { description = "Swap with master", group = "Client"}),

    awful.key({ super }, "j", function(c) j_key(c) end,
        { description = "Focus next by index", group = "Client"}),

    awful.key({ super, shift }, "j", function(c) j_shift_key(c) end,
        { description = "Focus next by index", group = "Client"}),

    awful.key({ super }, "k", function(c) k_key(c) end,
        { description = "Focus previous by index", group = "Client"}),

    awful.key({ super, shift }, "k", function(c) k_shift_key(c) end,
        { description = "Focus previous by index", group = "Client"}),

    awful.key({ super }, "l", function(c) l_key(c) end,
        { description = "Focus last slave", group = "Client" }),

    awful.key({ super, shift }, "l", function(c) l_shift_key(c) end,
        { description = "Focus first slave", group = "Client" }),

    awful.key({ super }, "Left", function(c) h_key(c) end,
        { description = "Focus first master", group = "Client" }),

    awful.key({ super, shift }, "Left", function(c) h_shift_key(c) end,
        { description = "Swap with master", group = "Client"}),

    awful.key({ super }, "Down", function(c) j_key(c) end,
        { description = "Focus next by index", group = "Client"}),

    awful.key({ super, shift }, "Down", function(c) j_shift_key(c) end,
        { description = "Focus next by index", group = "Client"}),

    awful.key({ super }, "Up", function(c) k_key(c) end,
        { description = "Focus previous by index", group = "Client"}),

    awful.key({ super, shift }, "Up", function(c) k_shift_key(c) end,
        { description = "Focus previous by index", group = "Client"}),

    awful.key({ super }, "Right", function(c) l_key(c) end,
        { description = "Focus last slave", group = "Client" }),

    awful.key({ super, shift }, "Right", function(c) l_shift_key(c) end,
        { description = "Focus first slave", group = "Client" }),

    -- Absolute keys; these operate on the whole current client list,
    -- regardless of floating status.
    awful.key({ super }, "m", function(c) awful.client.focus.byidx(0, awful.client.getmaster()) end,
        { description = "Swap with master", group = "Client"}),

    awful.key({ super, shift }, "m", function(c) c:swap(awful.client.getmaster()) end,
        { description = "Swap with master", group = "Client"}),

    awful.key({ super }, "[", function (c) awful.client.focus.byidx( 1) end,
        { description = "Focus next by index", group = "Client"}),

    awful.key({ super, "Shift"   }, "[", function (c) awful.client.swap.byidx(1) end,
        { description = "Swap with next client by index", group = "Client"}),

    awful.key({ super }, "]", function (c) awful.client.focus.byidx(-1) end,
        { description = "Focus previous by index", group = "Client"}),

    awful.key({ super, "Shift"   }, "]", function (c) awful.client.swap.byidx( -1) end,
        { description = "Swap with previous client by index", group = "Client"}),

    -- General window commands
    awful.key({ super, shift }, "x",
        function (c)
            c.fullscreen = not c.fullscreen
            c:raise()
        end,
        { description = "Toggle fullscreen", group = "Screen"}),

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

    -- Floating windows controls
    awful.key({ super }, "space",
        function(c)
            local s = c.screen
            local other = not c.floating
            local cls = s.clients
            if #cls > 1 then
                local n = awful.client.next(1)
                for i = 1,#cls,1 do
                    n = awful.client.next(1, n)
                    if n.floating == other then break end
                end
                awful.client.focus.byidx(0, n)
            end
        end,
              {description = "toggle floating", group = "Client"}),

    awful.key({ super, "Control" }, "space",  awful.client.floating.toggle,
              {description = "Toggle floating", group = "Client"}),

    awful.key({ super }, "[",
        function(c)
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
        end),

    awful.key({ super }, "]",
        function(c)
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
        end),

    awful.key({ super, control }, "c",  awful.placement.centered,
               { description = "Center floating window", group = "Floating"} ),

    awful.key({ super }, "b",  function(c) if c.floating then c.below = not c.below end end,
               { description = "Center floating window", group = "Floating"} ),

    awful.key({ super }, "w",
        function(c)
            if c.floating == true then
                size_controls:show({ coords = { x = c.x, y = c.y } })
            end
        end,
        { description = "Opening size menu", group = "Floating"}),

    awful.key({ super, shift }, "w",
        function(c)
            if c.floating == true then
                pos_controls:show({ coords = { x = c.x, y = c.y } })
            end
        end,
        {description = "Opening position menu", group = "Floating"}),

    awful.key({ super,           }, "t", function(c) if c.floating == true then c.ontop = not c.ontop end end,
      {description = "Toggle keep on top", group = "Client"}),

    awful.key({ super, shift }, "t", function(c) c.sticky = not c.sticky end)

    -- awful.key({super, shift }, "t", function(c) if c.floating == true then awful.titlebar.toggle(c) end end,
    -- { description = "Show/Hide Titlebars", group = "Client"} )

)

return clientkeys
