-- Returns the globally set keybindings

-- Import Libraries
local gears = require("gears")
local awful = require("awful")
local naughty = require("naughty")
local deck = require("lib.deck")
-- Help for various keybindings
require("awful.hotkeys_popup.keys")

-- Modifier keys
local super   = "Mod4"
local shift   = "Shift"
local control = "Control"

-- Defaults
local mwf_increment = 0.05
local mwf_default = 0.5

-- Programs
local finder = rc.float_term_em .. "-A 0.75 -t Finder -g 140x45 -e " .. rc.exec_d .. "find-file.sh"
local _SYS_MON = rc.float_term_em .. "-A 0.75 -e gotop"

-- Functions

local hotkeys_popup = require("awful.hotkeys_popup")

local function create_prompt(question, action)
    awful.spawn.with_shell(rc.exec_d .. "rofi-prompt.sh " .. question .. " " .. action)
end

local global_keys = gears.table.join(
    -- Spawn specific programs
    awful.key({ super }, "Return", function () awful.spawn(rc.term_emu) end,
              { description = "Spawn a terminal", group = "Launch" }),

    awful.key({ super, shift }, "Return", function() awful.spawn.with_shell(rc.float_term_em) end,
              { description = "Create a floating terminal", group = "Launch"}),

    awful.key({ super }, "space", function () awful.spawn(rc.exec_d .. "rofi-tmux.sh") end,
              {description = "Create new tmux client", group = "Launch" }),

    awful.key({ super, shift }, "space", function () awful.spawn(rc.exec_d .. "rofi-tmuxp.sh") end,
              {description = "Create new tmuxp session", group = "Launch" }),

    awful.key({ super }, "p", function() awful.spawn.with_shell(rc.passwords) end,
              { description = "Open password vault", group = "Launch" }),

    awful.key({}, "XF86HomePage", function() awful.rase_or_spawn(rc.browser) end,
              { description = "Open or raise default browser", group = "Launch" }),

    awful.key({}, "XF86Mail", function() awful.rase_or_spawn(rc.email) end,
              { description = "Open or raise default email client", group = "Launch" }),

    awful.key({ super }, "d", function() awful.spawn.raise_or_spawn(rc.file_man) end,
              { description = "Open or raise default file manager", group = "Launch" }),

    awful.key({ super }, "y", function() awful.spawn.with_shell(_SYS_MON) end,
              { description = "Toggle System Monitor", group = "System" }),

    -- Spawn generic programs
    awful.key({ super }, "a", function() awful.spawn.with_shell(rc.launcher) end,
              { description = "Find program to run", group = "Launch" }),

    awful.key({ super }, ";", function() awful.screen.focused().promptbox:run() end,
              { description = "Find program to run", group = "Launch" }),

    -- Search for files
    awful.key({ super }, "f", function() awful.spawn.with_shell(finder) end,
              { description = "Search for files to open", group = "Launch" }),

    -- Screen controls
    awful.key({ super, "Control" }, "j", function () awful.screen.focus_relative( 1) end,
              {description = "Focus next screen", group = "Screen" }),

    awful.key({ super, "Control" }, "k", function () awful.screen.focus_relative(-1) end,
              {description = "Focus previous screen", group = "Screen" }),

    -- General tag controls
    awful.key({ super }, "0",
        function()
            for _,t in pairs(awful.screen.focused().tags) do
                if #t:clients() == 0 then
                    t.selected = false
                else
                    t.selected = true
                end
            end

            awful.client.focus.byidx(0)
        end,
        { description = "Select all tags with clients on them", group = "Tag" }),

    awful.key({ super, shift }, "0",
        function()
            local prev = client.focus
            awful.tag.viewnone()
            if prev then
                for _,t in pairs(prev:tags()) do
                    t.selected = true
                end
            end
        end,
        { description = "Select current client tags only", group = "Tag" }),

    awful.key({ super, control }, "0",
        function()
            for _,t in pairs(awful.screen.focused().tags) do
                awful.tag.viewtoggle(t)
            end
        end,
        { description = "Reverse toggle on all tags", group = "Tag" }),

    awful.key({ super,           }, "grave", awful.tag.history.restore,
              {description = "Restore previous tag(s)", group = "Tag" }),

    awful.key({ super, shift }, "grave", function() awful.tag.viewmore(awful.screen.focused().tags) end,
              { description = "Toggle all tags on", group = "Tag" }),

    awful.key({ super, control }, "grave", function() awful.tag.viewnone() end,
              { description = "Toggle all tags off", group = "Tag" }),

    -- Layout controls
    awful.key({ super }, "x",
        function()
            local t = awful.screen.focused().selected_tag

            t.layout = awful.layout.suit.max
        end,
        { description = "Switch to max layout", group = "Layouts" }),

    awful.key({ super }, "v",
        function ()
            local s = awful.client.focus.screen
            local curr = awful.layout.getname(awful.layout.get(s))
            local t = awful.screen.focused().selected_tag

            if curr == "deck" then
                t.layout = awful.layout.suit.tile
            else
                t.layout = deck
            end
        end,
        { description = "Switch to vertical deck layout", group = "Layouts" }),

    awful.key({ super, shift }, "v",
        function ()
            local t = awful.screen.focused().selected_tag

            t.layout = awful.layout.suit.tile
        end,
        { description = "Switch to vertical tile layout", group = "Layouts" }),

    awful.key({ super }, "z",
        function ()
            local s = awful.client.focus.screen
            local curr = awful.layout.getname(awful.layout.get(s))
            local t = awful.screen.focused().selected_tag

            if curr == "horideck" then
                t.layout = awful.layout.suit.tile.bottom
            else
                t.layout = deck.horizontal
            end
        end,
        { description = "Switch to horizontal deck layout", group = "Layouts" }),

    awful.key({ super, shift }, "z",
        function()
            local t = client.focus and client.focus.first_tag or nil

            t.layout = awful.layout.suit.tile.bottom
        end,
        { description = "Switch to horizontal tile layout", group = "Layouts" }),

    -- General window controls
    awful.key({ super, shift }, "n",
        function ()
            local c = awful.client.restore()
              -- Focus restored client
            if c then
                c:emit_signal("request::activate", "key.unminimize", {raise = true})
            end
        end,
        {description = "Restore last minimized", group = "Client"}),

    awful.key({ super, control }, "n",
        function ()
            for _, c in pairs(awful.screen.focused().hidden_clients) do
                c.minimized = false
            end
        end,
        { description = "Restore all minimized", group = "Client" }),

    -- Special focus changes
    awful.key({ super,           }, "Tab",
        function ()
            awful.client.focus.history.previous()
            if client.focus then
                client.focus:raise()
            end
        end,
        {description = "Focus previous client", group = "Client"}),

    awful.key({ super,           }, "u", function() awful.client.urgent.jumpto(true) end,
              {description = "Jump to urgent client", group = "Client"}),

    awful.key({ super, shift     }, "u", function() awful.client.urgent.jumpto() end,
              {description = "Jump to urgent client (active tag only)", group = "Client"}),

    awful.key({ super,           }, "s", function() awful.spawn.with_shell(rc.win_switcher) end,
              {description = "Switch window", group = "Client"}),

    -- Modify master width factor
    awful.key( { super }, "i", function() awful.tag.incmwfact(mwf_increment) end,
        { description = "Increase master width factor" , group = "Tag" }),

    awful.key( { super, shift }, "i", function() awful.tag.incmwfact(-mwf_increment) end,
        { description = "Decrease master width factor" , group = "Tag" }),

    -- Modify master count
    awful.key( { super, }, "o",
        function()
            local t = client.focus and client.focus.first_tag or nil
            local client_count = #screen[t.screen].tiled_clients
            if t.master_count < client_count - 1 then
                awful.tag.incnmaster(1, nil, true)
            end
        end,
        { description = "Increase number of master windows", group = "Tag"}),

    awful.key( { super, shift }, "o",
        function()
            local t = client.focus and client.focus.first_tag or nil
            if t.master_count > 1 then
                awful.tag.incnmaster(-1, nil, true)
            end
        end,
        { description = "Decrease number of master windows", group = "Tag"}),

    awful.key( { super, control }, "o",
        function()
            local t = client.focus and client.focus.first_tag or nil
            t.master_count = 1
        end,
        { description = "Reset number of master windows to default", group = "Tag"}),

    -- Media buttons
    awful.key({}, "XF86AudioMute", function() awful.spawn("pamixer --toggle-mute") end,
             { description = "Mute", group = "Music controls"}),

    awful.key({}, "XF86AudioLowerVolume", function() awful.spawn("pamixer --decrease 2") end,
             {description = "Lower Volume", group = "Music controls"}),

    awful.key({}, "XF86AudioRaiseVolume", function() awful.spawn("pamixer --increase 2") end,
             {description = "Raise Volume", group = "Music controls"}),

    awful.key({}, "XF86AudioPlay", function() awful.spawn("playerctl play-pause") end,
             {description = "Toggle playing", group = "Music control"}),

    awful.key({}, "XF86AudioPrev", function() awful.spawn("playerctl previous") end,
             {description = "Play previous song", group = "Music control"}),

    awful.key({}, "XF86AudioNext", function() awful.spawn("playerctl next") end,
             {description = "Play next song", group = "Music control"}),

    -- Screenshots
    awful.key({}, "Print", function() awful.spawn("flameshot gui") end,
              { description = "Take a screenshot of selected region", group = "Screenshots"}),

    awful.key({ "Shift" }, "Print", function() awful.spawn.with_shell("flameshot screen --path $HOME/imgs/screnshots") end,
              { description = "Take a screenshot of selected region", group = "Screenshots"}),

    awful.key({ "Control" }, "Print", function() awful.spawn("flameshot full --path $HOME/imgs/screenshots") end,
              { description = "Screenshot menu", group = "Screenshots"}),

    -- Insert Unicode character
    awful.key({ super }, "c", function() awful.spawn.with_shell(rc.exec_d .. "rofi-unicode.sh") end),

    awful.key({ super, shift }, "c", function() awful.spawn.with_shell(rc.exec_d .. "rofi-unicode.sh clipboard") end),

    -- System functions
    -- awful.key({ super }, "Escape", function() awful.spawn.with_shell(rc.exec_d .. "rofi-system.sh") end,
    --            {description = "Show system menu", group = "System"}),

    awful.key({ super }, "q", function() create_prompt("\"Quit AwesomeWM?\"", "awesome-client \"awesome.quit()\"") end,
              { description = "Quit Awesome", group = "System"}),

    -- awful.key({ super, shift }, "q", function() awful.spawn.with_shell(rc.exec_d .. "portable_poweroff.sh") end,
    --           { description = "Shutdown Computer", group = "System"}),

    -- awful.key({ super }, "r", function() create_prompt("\"Restart AwesomeWM?\"", "awesome-client \"awesome.restart()\"") end,
    --     { description = "Restart AwesomeWM", group = "System"}),

    -- awful.key({ super, shift }, "r", function () awful.spawn.with_shell(rc.exec_d .. "portable_reboot.sh") end ,
    --     { description = "Reboot", group = "System"}),

    awful.key({ super, "Control" }, "r", function() awesome.restart() end,
        { description = "Restarts AwesomeWM", group = "System"}),

    awful.key({ super }, "=",
        function()
            local status = awful.screen.focused().systray.visible
            awful.screen.focused().systray.visible = not status
            if status then
                naughty.notify { text = "System tray invisible" }
            else
                naughty.notify { text = "System tray visible" }
            end
        end,
        { description = "Toggle System Tray visiblity", group = "System"}),

    awful.key({ super, shift }, "d", function() awful.spawn.with_shell(rc.exec_d .. "rofi-removable.sh") end,
        { description = "Unmount mounted drives", group = "System"}),

    awful.key({ super, }, "F1", hotkeys_popup.show_help,
              { description = "Show keybindings", group = "System" })
)

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it work on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, 9 do
    global_keys = gears.table.join(global_keys,

        -- Toggle tag display
        awful.key({ super }, "#" .. i + 9,
                  function ()
                        local screen = awful.screen.focused()
                        local current = screen.selected_tags
                        local first = screen.selected_tag
                        local tag = screen.tags[i]

                        -- Do not toggle the last remaining tag
                        if tag and #current > 1 or tag ~= first then
                            awful.tag.viewtoggle(tag)
                        end
                        awful.client.focus.byidx(0)
                  end,
                  {description = "Toggle tag #"..i, group = "Tag"}),

        -- Toggle only viewing that tag.
        awful.key({ super, "Control" }, "#" .. i + 9,
                  function ()
                      local screen = awful.screen.focused()
                      local tag = screen.tags[i]
                      if tag then
                           tag:view_only()
                      end
                  end,
                  {description = "View only tag #" .. i, group = "Tag"}),

        -- Toggle tag on focused client.
        awful.key({ super, "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag = client.focus.screen.tags[i]
                          if tag then
                              client.focus:toggle_tag(tag)
                          end
                     end
                  end,
                  {description = "Toggle focused client to tag #"..i, group = "Tag"})
    )
end

return global_keys
