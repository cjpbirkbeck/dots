local gears = require("gears")
local awful = require("awful")
local wibox = require("wibox")

local task_buttons = gears.table.join(
    awful.button({ }, 1, function (c)
        if c == client.focus then
            c.minimized = true
        else
            c:emit_signal(
            "request::activate",
            "tasklist",
            {raise = true}
            )
        end
    end),
    awful.button({ }, 3, function () awful.menu.client_list({ theme = { width = 250 } }, _, function (c) return not c.skip_taskbar end) end))

local function screen_tasks(s)
    local tasklist = awful.widget.tasklist {
            screen   = s,
            filter   = awful.widget.tasklist.filter.currenttags,
            buttons  = task_buttons,
            style    = {
                shape_border_width = 1,
                shape_border_color = '#777777',
                shape  = gears.shape.rounded_bar,
            },
            layout   = {
                spacing = 5,
                layout  = wibox.layout.flex.horizontal
            },
            -- Notice that there is *NO* wibox.wibox prefix, it is a template,
            -- not a widget instance.
            widget_template = {
                {
                    {
                        {
                            {
                                id     = 'icon_role',
                                widget = wibox.widget.imagebox,
                            },
                            margins = 2,
                            widget  = wibox.container.margin,
                        },
                        {
                            id     = 'text_role',
                            widget = wibox.widget.textbox,
                        },
                        layout = wibox.layout.fixed.horizontal,
                    },
                    left  = 10,
                    right = 10,
                    widget = wibox.container.margin
                },
                id     = 'background_role',
                widget = wibox.container.background,
                create_callback = function(self, c, _, _)
                    awful.tooltip {
                        objects = { self },
                        timer_function = function() return c.name end
                    }
                end,
            }
        }

    return tasklist
end

return screen_tasks
