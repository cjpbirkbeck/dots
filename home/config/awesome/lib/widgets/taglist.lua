local gears = require("gears")
local awful = require("awful")
local wibox = require("wibox")

local tag_symbols = require("lib.vars.tags")

local taglist_buttons = gears.table.join(
    awful.button({ }, 1, awful.tag.viewtoggle),
    awful.button({ }, 3, function(t) t:view_only() end),
    awful.button({ super }, 3, function(t)
        if client.focus then
            client.focus:toggle_tag(t)
        end
    end))

local function screen_tags(s)
    local taglist = awful.widget.taglist {
            screen  = s,
            filter  = awful.widget.taglist.filter.all,
            buttons = taglist_buttons,
            widget_template = {
                id = "background_role",
                widget = wibox.container.background,
                {
                    left = 2,
                    right = 2,
                    widget = wibox.container.margin,
                    {
                        layout = wibox.layout.fixed.horizontal,
                        {
                            id = 'glyph_role',
                            text = "a",
                            widget = wibox.widget.textbox
                        },
                    },
                },
                create_callback = function(self, t, i, tags)
                    text = i .. " " .. tag_symbols[i][2]
                    if t.selected then text = '<b><span foreground="#000000">' .. text .. '</span></b>' end
                    self:get_children_by_id('glyph_role')[1].markup = text
                    local tt = awful.tooltip {
                        objects = { self },
                        timer_function = function() return t.name .. ", " .. #t:clients() .. ", " .. t.layout.name end
                    }
                end,
                update_callback = function(self, t, i, tags)
                    text = i .. " " .. tag_symbols[i][2]
                    if t.selected then text = '<b><span foreground="#000000">' .. text .. '</span></b>' end
                    self:get_children_by_id('glyph_role')[1].markup = text
                end
            }
        }

    return taglist
end

return screen_tags
