-- Returns the globally set keybindings

-- Import Libraries
local gears = require("gears")
local awful = require("awful")
local beautiful = require("beautiful")
local naughty = require("naughty")
local deck = require("lib.layouts.deck")

-- Modifier keys
local super   = "Mod4"
local shift   = "Shift"
local control = "Control"

-- Defaults
local mwf_increment = 0.05
local mwf_default = 0.5

-- Functions
local function create_prompt(question, action)
    awful.spawn.with_shell(exec_d .. "./rofi-prompt.sh " .. question .. " " .. action)
end

local global_keys = gears.table.join(
    -- Spawn new programs or switch to existing programs, using rofi as a launcher
    awful.key({ super }, "f", function() awful.spawn.with_shell(launcher) end,
              { description = "Find program to run", group = "Launch"}),

    -- Spawn specific programs
    awful.key({ super }, "Return", function () awful.spawn(terminal) end,
              {description = "Spawn a terminal", group = "Launch"}),

    awful.key({ super, shift }, "Return", function () awful.spawn(exec_d .. "rofi-tmux.sh") end,
              {description = "Create new tmux client", group = "Launch"}),

    awful.key({ super, control }, "Return", function () awful.spawn(exec_d .. "rofi-tmuxp.sh") end,
              {description = "Create new tmuxp session", group = "Launch"}),

    awful.key({ super }, "\\", function() awful.spawn.with_shell("st -c st-float") end,
              { description = "Create a floating terminal", group = "Launch"}),

    awful.key({ super }, "p", function() awful.spawn.with_shell("rofi-pass --last-used") end,
              { description = "Open passwords", group = "Launch"}),

    -- Search for files
    awful.key({ super }, "s", function() awful.spawn.with_shell(terminal .. " -c st-dialog " .. " -t Directories" .. " -g 160x45 " .. " -e " .. exec_d .. "find-file.sh") end,
              { description = "Search for files to open", group = "Launch"}),

    awful.key({ super }, "d", function() awful.spawn(terminal .. " -c st-dialog " .. "-g 160x45 " .. " -t Finder " .. " -e " .. exec_d .. "find-dirs.sh") end,
       { description = "Find directories to open", group = "Launch"}),

    -- Screen controls
    awful.key({ super, "Control" }, "j", function () awful.screen.focus_relative( 1) end,
              {description = "Focus next screen", group = "Screen"}),

    awful.key({ super, "Control" }, "k", function () awful.screen.focus_relative(-1) end,
              {description = "Focus previous screen", group = "Screen"}),

    awful.key({ super, "Control" }, "h", function () client.focus:move_to_screen(-1) end,
              {description = "Move focused to previous screen", group = "Screen"}),

    awful.key({ super, "Control" }, "l", function () client.focus:move_to_screen() end,
              {description = "Move focused to next screen", group = "Screen"}),

    -- Tag controls
    awful.key({ super,           }, "grave", awful.tag.history.restore,
              {description = "Restore previous tag(s)", group = "tag"}),

    -- Layout controls
    awful.key({ super }, "x",
        function()
            local t = client.focus and client.focus.first_tag or nil

            t.layout = awful.layout.suit.max
        end),

    awful.key({ super }, "v",
        function ()
            local s = awful.client.focus.screen
            local curr = awful.layout.getname(awful.layout.get(s))
            local t = client.focus and client.focus.first_tag or nil

            if curr == "deck" then
                t.layout = awful.layout.suit.tile
            else
                t.layout = deck
            end
        end),

    awful.key({ super, shift }, "v",
        function ()
            local t = client.focus and client.focus.first_tag or nil

            t.layout = awful.layout.suit.tile
        end),

    awful.key({ super }, "z",
        function ()
            local s = awful.client.focus.screen
            local curr = awful.layout.getname(awful.layout.get(s))
            local t = client.focus and client.focus.first_tag or nil

            if curr == "horideck" then
                t.layout = awful.layout.suit.tile.bottom
            else
                t.layout = deck.horizontal
            end
        end),

    awful.key({ super, shift }, "z",
        function()
            local t = client.focus and client.focus.first_tag or nil

            t.layout = awful.layout.suit.tile.bottom
        end),

    -- awful.key({ super }, "space", function () awful.layout.inc( 1) end,
    --           {description = "Select next", group = "Layout"}),

    -- awful.key({ super, "Shift" }, "space", function () awful.layout.inc(-1) end,
    --           {description = "Select previous", group = "Layout"}),

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
        { description = "Restore all minimized", group = "Client"}),

    -- Tilled/stacked window controls
    awful.key({ super }, "h", function() awful.client.focus.byidx(0, awful.client.getmaster()) end,
        { description = "Focus first master", group = "Client" }),

    awful.key({ super, shift }, "h", function() client.focus:swap(awful.client.getmaster()) end,
        { description = "Swap with master", group = "Client"}),

    awful.key({ super }, "j", function () awful.client.focus.byidx( 1) end,
        { description = "Focus next by index", group = "Client"}),

    awful.key({ super, "Shift"   }, "j", function () awful.client.swap.byidx(1) end,
        { description = "Swap with next client by index", group = "Client"}),

    awful.key({ super }, "k", function () awful.client.focus.byidx(-1) end,
        { description = "Focus previous by index", group = "Client"}),

    awful.key({ super, "Shift"   }, "k", function () awful.client.swap.byidx( -1) end,
        { description = "Swap with previous client by index", group = "Client"}),

    awful.key({ super }, "l", function() awful.client.focus.byidx(1, awful.client.getmaster()) end,
        { description = "Focus first slave", group = "Client" }),

    awful.key({ super, shift }, "l", function() awful.client.focus.byidx(-1, awful.client.getmaster()) end,
        { description = "Focus last slave", group = "Client" }),

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

    awful.key({ super,           }, "u", function() awful.client.urgent.jumpto() end,
              {description = "Jump to urgent client", group = "Client"}),

    -- Modify master width factor
    awful.key( { super }, "i", function() awful.tag.incmwfact(mwf_increment) end,
        { description = "Increase master width factor" , group = "Tag" }),

    awful.key( { super, shift }, "i", function() awful.tag.incmwfact(-mwf_increment) end,
        { description = "Decrease master width factor" , group = "Tag" }),

    awful.key( { super, control }, "i", function() client.focus.first_tag.master_width_factor = mwf_default end,
        {description = "Reset default master width factor" , group = "Tag"}),

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
    awful.key({ "Shift" }, "Print", function() awful.spawn.with_shell(exec_d .. "rofi-screenshot.sh select") end,
              { description = "Take a screenshot of selected region", group = "Screenshots"}),

    awful.key({ "Control" }, "Print", function() awful.spawn.with_shell(exec_d .. "rofi-screenshot.sh") end,
              { description = "Screenshot menu", group = "Screenshots"}),

    -- Miscellaneous
    awful.key({ super, "Control" }, "c",  function () year_calendar:toggle() end,
               { description = "Show yearly calendar", group = "Miscellaneous"}),

    -- awful.key({ super, control   }, "s",      hotkeys_popup.show_help,
    --           {description="Show shortcuts", group="awesome"}),

    -- System functions
    awful.key({ super }, "Escape", function() awful.spawn.with_shell(exec_d .. "rofi-system.sh") end,
               {description = "Show system menu", group = "System"}),

    awful.key({ super }, "q", function() create_prompt("\"Quit AwesomeWM?\"", "awesome-client \"awesome.quit()\"") end,
        { description = "Quit Awesome", group = "System"}),

    awful.key({ super, shift }, "q", function() create_prompt("\"Shutdown your system?\"", "systemctl poweroff") end,
        { description = "Shutdown Computer", group = "System"}),

    awful.key({ super }, "r", function() create_prompt("\"Restart AwesomeWM?\"", "awesome-client \"awesome.restart()\"") end,
        { description = "Restart AwesomeWM", group = "System"}),

    awful.key({ super, shift }, "r", function() create_prompt("\"Restart your system?\"", "systemctl reboot") end,
        { description = "Restart AwesomeWM", group = "System"}),

    awful.key({ super, "Control" }, "r",
        function()
            awful.spawn.with_line_callback("awesome -k",
            {
                exit = function(e, code)
                    if code == 0 then
                        awesome.restart()
                    else
                        naughty.notify({title = "Error", text = "Configuration contains an error."})
                    end
                end,
            })
        end,
        { description = "Restarts AwesomeWM", group = "System"}),

    awful.key({ super }, "y",
        function()
            for _,c in ipairs(client.get()) do
                if c.class == "Conky" then
                    c.ontop = not c.ontop
                    return
                end
            end
        end,
        {description = "Toggle System Monitor", group = "System"}),

    awful.key({ super, shift }, "d",
        function()
            awful.spawn.with_shell(exec_d .. "rofi-removable.sh")
        end,
        { description = "Unmount mounted drives", group = "System"})
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
        -- Move client to tag.
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
        -- Toggle tag on focused client.
    )
end

return global_keys
