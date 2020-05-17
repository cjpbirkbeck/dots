-- Import Libraries
local gears = require("gears")
local awful = require("awful")
local beautiful = require("beautiful")
local naughty = require("naughty")
local clientkeys = require("lib.keys.client")

clientbuttons = gears.table.join(
    awful.button({ }, 1, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
    end),
    awful.button({ super }, 1, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
        awful.mouse.client.move(c)
    end),
    awful.button({ super }, 3, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
        awful.mouse.client.resize(c)
    end)
)

local rules = {
    -- Rules for all clients
    { rule = { },
      properties = { border_width = beautiful.border_width,
                     border_color = beautiful.border_normal,
                     focus = awful.client.focus.filter,
                     raise = true,
                     keys = clientkeys,
                     buttons = clientbuttons,
                     screen = awful.screen.preferred,
                     placement = awful.placement.no_overlap+awful.placement.no_offscreen
     }
    },

    -- Toggle floating (and center) any client that matches the following
    { rule_any = {
        instance = {
          "DTA",  -- Firefox addon DownThemAll.
          "copyq",  -- Includes session name in class.
          "pinentry",
        },
        class = {
          "Arandr",
          "Blueman-manager",
          "Gpick",
          "Kruler",
          "MessageWin",  -- kalarm.
          "Tor Browser", -- Needs a fixed window size to avoid fingerprinting by screen size.
          "Wpa_gui",
          "veromix",
          "xtightvncviewer",
          "alacritty-float",
          "st-float",
          "st-dialog"
        },

        -- Note that the name property shown in xprop might be set slightly after creation of the client
        -- and the name shown there might not match defined rules here.
        name = {
          "Event Tester",  -- xev.
        },
        role = {
          "AlarmWindow",  -- Thunderbird's calendar.
          "ConfigManager",  -- Thunderbird's about:config.
          "pop-up",       -- e.g. Google Chrome's (detached) Developer Tools.
        },
        type = { "dialog" }
      }, properties = { floating = true, placement = awful.placment.centered }},

    -- Assign applications to tags
    { rule_any = { class = { "Firefox", "Brave" } },
      properties = { tag = "Web" } },

    { rule_any = { class = { "Daily", "Thunderbird" } },
      properties = { tag = "Email" } },

    { rule = { class = "Zathura" },
      properties = { tag = "Documents" } },

    { rule_any = { class = { "kolourpaint", "Sxiv", "GIMP", "Inkscape" } },
      properties = { tag = "Images" } },

    { rule_any = { class = { "mpv" } },
      properties = { tag = "Video" } },

    { rule_any = { class = { "steam" } },
      properties = { tag = "Games" } },

    { rule_any = { class = { "VirtualBox" } },
      properties = { tag = "Virtual" } },

    -- Conky should be present in all windows
    { rule = { class = "Conky" },
      properties = { sticky = true,
                     skip_taskbar = true }},

    { rule = { class = "st-256color" },
      properties = { icon = "utilities-terminal"} },
}

return rules
