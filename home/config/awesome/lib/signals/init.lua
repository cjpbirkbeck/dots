--[[
    Set signals for various requests, including adding titlebars.
--]]

local gears = require("gears")
local awful = require("awful")
local menubar = require("menubar")
local beautiful = require("beautiful")

local titlebars = require("lib.bars.title")

-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c)
    -- Set the windows at the slave,
    -- i.e. put it at the end of others instead of setting it master.
    -- if not awesome.startup then awful.client.setslave(c) end

    if awesome.startup
      and not c.size_hints.user_position
      and not c.size_hints.program_position then
        -- Prevent clients from being unreachable after screen count changes.
        awful.placement.no_offscreen(c)
    end
end)

-- When toggling floating mode, force clients to have a titlebar.
client.connect_signal("property::floating",
    function(c)
        if c.floating and c.type == 'dialog' then
            awful.titlebar.show(c)
        else
            awful.titlebar.hide(c)
        end
    end
)

-- Add a titlebar if titlebars_enabled is set to true in the rules.
client.connect_signal("request::titlebars", function(c) titlebars(c) end)

-- Enable sloppy focus, so that focus follows mouse.
client.connect_signal("mouse::enter",
    function(c)
        c:emit_signal("request::activate", "mouse_enter", {raise = false})
    end)

-- No borders with the max layout or if there is only a single tile client.
-- Floating clients should have a border unless it is a dialog box.
screen.connect_signal("arrange",
    function (s)
        local selected = s.selected_tags
        if #selected > 0 then
            local t = s.selected_tag
            local l = t.layout

            for _, c in pairs(s.clients) do
                if #s.tiled_clients == 1 or l == awful.layout.suit.max then
                    if c.floating and c.type ~= 'dialog' then
                        c.border_width = beautiful.border_width
                    else
                        c.border_width = 0
                    end
                else
                    c.border_width = beautiful.border_width
                end
            end
        end
    end)

-- Add icons for st terminals.
client.connect_signal("manage", function(c)
    if c.class == "st-256color" or c.class == "st-dialog" or c.class == "st-float" then
        local new_icon = gears.surface(menubar.utils.lookup_icon(theme_d .. "st.svg"))
        c.icon = new_icon._native
    end
end)

client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
