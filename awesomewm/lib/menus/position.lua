local awful = require("awful")
local beautiful = require("beautiful")

local position = awful.menu({
    items = {
        { "Top Left", function() awful.placement.top_left(client.focus) end },
        { "Top", function() awful.placement.top(client.focus) end },
        { "Top Right", function() awful.placement.top_right(client.focus) end },
        { "Left", function() awful.placement.left(client.focus) end },
        { "Centered", function() awful.placement.centered(client.focus) end },
        { "Right", function() awful.placement.right(client.focus) end },
        { "Bottom Left", function() awful.placement.bottom_left(client.focus) end },
        { "Bottom", function() awful.placement.bottom_right(client.focus) end },
        { "Bottom Right", function() awful.placement.bottom_right(client.focus) end },
    },
    theme = {
        bg_focus = "#FFFFFF",
        fg_focus = "#000000"
    }
})

return position
