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

local clientkeys = gears.table.join(
    -- General window commands
    awful.key({ super, shift }, "x",
        function (c)
            c.fullscreen = not c.fullscreen
            c:raise()
        end,
        { description = "Toggle fullscreen", group = "Screen"}),

    awful.key({ super }, "n", function (c) c.minimized = true end ,
        { description = "Minimize", group = "Client"}),

    awful.key({ super }, "h",
        function(c)
            local s = c.screen
            local tiled = s:get_tiled_clients(false)
            local first_tiled = tiled[1]

            -- naughty.notify { text = tostring(#tiled) .. " " .. first_tiled.name }

            awful.client.focus.byidx(0, first_tiled)
        end,
        { description = "Focus first master", group = "Client" }),

    -- Kill Window
    awful.key({ super }, "BackSpace", function (c) c:kill() end,
              {description = "Close", group = "Client"}),

    -- Floating windows controls
    awful.key({ super, "Control" }, "space",  awful.client.floating.toggle,
              {description = "toggle floating", group = "Client"}),

    awful.key({ super }, "c",  awful.placement.centered,
               { description = "Center floating window", group = "Floating"} ),

    awful.key({ super }, "b",  function(c) if c.floating then c.below = not c.below end end,
               { description = "Center floating window", group = "Floating"} ),

    awful.key({ super }, "Right",
        function(c)
            if c.floating then c.x = c.x + reposition_inc end

            awful.placement.no_offscreen(c)
        end),

    awful.key({ super }, "Left",
        function(c)
            if c.floating then c.x = c.x - reposition_inc end

            awful.placement.no_offscreen(c)
        end),

    awful.key({ super }, "Down",
        function(c)
            if c.floating then c.y = c.y + reposition_inc end

            awful.placement.no_offscreen(c)
        end),

    awful.key({ super }, "Up",
        function(c)
            if c.floating then c.y = c.y - reposition_inc end

            awful.placement.no_offscreen(c)
        end),

    awful.key({ super, shift }, "Right",
        function(c)
            local max_width = c.screen.geometry.width
            local new = c.width + resize_inc

            if c.floating and new >= min_width and new <= max_width then c.width = new end
        end),

    awful.key({ super, shift }, "Left",
        function(c)
            local max_width = c.screen.geometry.width
            local new = c.width - resize_inc

            if c.floating and new >= min_width and new <= max_width then c.width = new end
        end),

    awful.key({ super, shift }, "Down",
        function(c)
            local max_height = c.screen.geometry.height
            local new = c.height + resize_inc

            if c.floating and new >= min_height and new <= max_height then c.height = new end
        end),

    awful.key({ super, shift }, "Up",
        function(c)
            local max_height = c.screen.geometry.height
            local new = c.height - resize_inc

            if c.floating and new >= min_height and new <= max_height then c.height = new end
        end),

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
