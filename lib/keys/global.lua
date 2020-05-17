-- Import Libraries
local gears = require("gears")
local awful = require("awful")
local beautiful = require("beautiful")
local naughty = require("naughty")

-- Directories
local home_d   = os.getenv("HOME")
local config_d = gears.filesystem.get_dir("config")
local exec_d   = config_d .. "bin/"
local lib_d    = config_d .. "lib/"
local theme_d  = config_d .. "theme/"

-- Programs
local terminal = "st"
local launcher = "rofi -show combi window drun run -combi-modi \"window,drun,run\""

-- Defaults
local mwf_increment = 0.05
local mwf_default = 0.5

-- Functions
local function create_prompt(question, action)
    awful.spawn.with_shell(exec_d .. "./rofi-prompt.sh " .. question .. " " .. action)
end

global_keys = gears.table.join(
    -- Spawn new programs or switch to existing programs, using rofi as a launcher
    awful.key({ super }, "f", function() awful.spawn.with_shell("export XDG_CURRENT_DESKTOP=kde && " .. launcher) end,
              { description = "Find program to run", group = "Launch"}),

    -- awful.key({ super, shift }, "f", awful.spawn.with_shell("export XDG_CURRENT_DESKTOP=kde && " .. "rofi -show combi window drun run -combi-modi \"window,run\""),
    --           { description = "Find any program to run", group = "Launch"}),

    -- Spawn specific programs
    awful.key({ super }, "Return", function () awful.spawn(terminal) end,
              {description = "Spawn a terminal", group = "Launch"}),

    awful.key({ super, shift }, "Return", function () awful.spawn(exec_d .. "rofi-tmux.sh") end,
              {description = "Attach to tmux session in new terminal", group = "Launch"}),

    -- awful.key({ super }, "w", function() awful.spawn.raise_or_spawn(browser) end,
    --           { description = "Open web browser", group = "Launch"}),

    -- awful.key({ super }, "e", function() awful.spawn.raise_or_spawn(email) end,
    --           { description = "Open email", group = "Launch"}),

    awful.key({ super }, "p", function() awful.spawn.with_shell("rofi-pass --last-used") end,
              { description = "Open passwords", group = "Launch"}),

    -- Search for files
    awful.key({ super }, "s", function() awful.spawn.with_shell(terminal .. " -c st-dialog " .. " -t Directories" .. " -g 160x45 " .. " -e " .. exec_d .. "find-dirs.sh") end,
              { description = "Search for files to open", group = "Launch"}),

    awful.key({ super }, "d", function() awful.spawn(terminal .. " -c st-dialog " .. "-g 160x45 " .. " -t Finder " .. " -e " .. exec_d .. "find-file.sh") end,
       { description = "Find directories to open", group = "Launch"}),

    -- awful.key({ super }, "F1", lookfor_manpages,
    --    { description = "Find manpages to open", group = "Launch"}),

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
    awful.key({ super }, "space", function () awful.layout.inc( 1) end,
              {description = "Select next", group = "Layout"}),

    awful.key({ super, "Shift" }, "space", function () awful.layout.inc(-1) end,
              {description = "Select previous", group = "Layout"}),

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

    awful.key({ super,           }, "u", function() awful.client.urgent.jumpto() end,
              {description = "Jump to urgent client", group = "Client"}),

    -- Modify master width factor
    awful.key( { super }, "i", function() awful.tag.incmwfact(mwf_increment) end,
        { description = "Increase master width factor" , group = "Tag" }),

    awful.key( { super, shift }, "i", function() awful.tag.incmwfact(mwf_increment) end,
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

return global_keys
