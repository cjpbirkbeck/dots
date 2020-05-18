-- Import Libraries
local gears = require("gears")
local awful = require("awful")
local beautiful = require("beautiful")
local naughty = require("naughty")

-- Modifier keys
super   = "Mod4"
shift   = "Shift"
control = "Control"

local clientkeys = gears.table.join(
    -- General window commands
    awful.key({ super, shift }, "f",
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
    awful.key({ super, "Control" }, "space",  awful.client.floating.toggle,
              {description = "toggle floating", group = "Client"}),

    awful.key({ super }, "c",  awful.placement.centered,
               { description = "Center floating window", group = "Floating"} ),

    awful.key({ super }, "x",
        function(c)
            if c.floating == true then
                float_controls:show({ coords = { x = c.x, y = c.y } })
            end
        end,
        {description = "Opening floating control menu", group = "floating"}),

    awful.key({ super,           }, "t", function(c) if c.floating == true then c.ontop = not c.ontop end end,
      {description = "toggle keep on top", group = "Client"}),

    awful.key({super, shift }, "t", function(c) if c.floating == true then awful.titlebar.toggle(c) end end,
    { description = "Show/Hide Titlebars", group = "Client"} ),

    awful.key({ super,           }, "m",
        function (c)
            c.maximized = not c.maximized
            c:raise()
        end ,
        {description = "(un)maximize", group = "Client"})
)

return clientkeys
