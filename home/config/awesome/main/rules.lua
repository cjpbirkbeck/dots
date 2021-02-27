-- Returns the rules that all matching clients follow.
-- Note that it does not stop them from being changed or moved after placement.

-- Import Libraries
local gears = require("gears")
local awful = require("awful")
local beautiful = require("beautiful")
local naughty = require("naughty")
local clientkeys = require("main.keys.client")

-- Mouse keybindings
local clientbuttons = gears.table.join(
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

-- Set rules for clients
awful.rules.rules = {
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
          "Yubico Authenticator",
          "Gnome-disks",
          "Cheese",
          "asunder",
          "alacritty-float",
          "st-float",
          "st-dialog",
          "flameshot",
          "Qalculate-gtk"
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
      }, properties = { floating = true, placement = awful.placement.centered } },

    -- Assign applications to tags

    { rule_any = { class = { "pcmanfm-qt", "pcmanfm", "dolphin", "Gnome-disks", "ark", "Qalculate-gtk" } },
      properties = { tag = "Home" } },

    { rule_any = { class = { "qutebrowser", "Firefox", "Brave", "Tor Browser", "Vimb", } },
      properties = { tag = "Web" } },

    { rule_any = { class = { "Daily", "Thunderbird", "nheko", "qTox", "zoom" } },
      properties = { tag = "Email" } },

    { rule_any = { class = { "Zathura", "okular", "libreoffice", "libreoffice-writer", "libreoffice-calc",
                         "libreoffice-impress", "libreoffice-draw", "libreoffice-base" } },
      properties = { tag = "Documents" } },

    { rule_any = { class = { "kolourpaint", "Sxiv", "GIMP", "Inkscape", "gwenview" } },
      properties = { tag = "Images" } },

    { rule_any = { class = { "Audacity", "Asunder", "Gbh", ".brasero-wrapped_", "brasero", "Cheese" } },
      properties = { tag = "Multimedia" } },

    { rule_any = { class = { "Gnome-mines", "Steam", "Rftg", "ksudoku" } },
      properties = { tag = "Games" } },

    { rule_any = { class = { "VirtualBox Manager", "VirtualBox Machine" } },
      properties = { tag = "Virtual" } },

    { rule = { class = "mpv" },
      properties = { tag = "Multimedia",
                     floating = true,
                     placement = awful.placement.centered,
                     ontop = true } }
}
