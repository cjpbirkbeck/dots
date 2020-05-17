-- AwesomeWM configuration file

-- Libraries {{{
-- If LuaRocks is installed, make sure that packages installed through it are
-- found (e.g. lgi). If LuaRocks is not installed, do nothing.
pcall(require, "luarocks.loader")

-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
require("awful.autofocus")
require("awful.keygrabber")
-- Widget and layout library
local wibox = require("wibox")
-- Theme handling library
local beautiful = require("beautiful")
-- Notification library
local naughty = require("naughty")
local menubar = require("menubar")
local hotkeys_popup = require("awful.hotkeys_popup")
-- Enable hotkeys help widget for VIM and other apps
-- when client with a matching name is opened:
require("awful.hotkeys_popup.keys")

local deck = require("lib.deck.lua")
local gk = require("lib.keys.global")
local ck = require("lib.keys.client")

-- }}}

-- {{{ Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
    naughty.notify({ preset = naughty.config.presets.critical,
                     title = "Oops, there were errors during startup!",
                     text = awesome.startup_errors })
end

-- Handle runtime errors after startup
do
    local in_error = false
    awesome.connect_signal("debug::error", function (err)
        -- Make sure we don't go into an endless error loop
        if in_error then return end
        in_error = true

        naughty.notify({ preset = naughty.config.presets.critical,
                         title = "Oops, an error happened!",
                         text = tostring(err) })
        in_error = false
    end)
end
-- }}}

-- {{{ Variables

-- Directories
home_d   = os.getenv("HOME")
config_d = gears.filesystem.get_dir("config")
exec_d   = config_d .. "bin/"
lib_d    = config_d .. "lib/"
theme_d  = config_d .. "theme/"

-- Applications
terminal     = "st"
editor       = terminal .. " -e nvim"
launcher     = "rofi -show combi window drun run -combi-modi \"window,drun,run\""
browser      = "firefox"
email        = "thunderbird"
image_viewer = "sxiv -a"
doc_viewer   = "zathura"

-- Modifier keys
super   = "Mod4"
shift   = "Shift"
control = "Control"

-- Locale
location = "cyul"
weather_page = " https://weather.gc.ca/city/pages/qc-147_metric_e.html"

-- Themes define colours, icons, font and wallpapers.
beautiful.init(theme_d .. "/theme.lua")

beautiful.gap_single_client = false

-- Table of layouts to cover with awful.layout.inc, order matters.
awful.layout.layouts = {
    awful.layout.suit.max,
    deck,
    awful.layout.suit.tile,
    deck.horizontal,
    awful.layout.suit.tile.bottom
}

-- List of tags, and any extra properties they may have.
tag_symbols = {
    { "Home", "" },
    { "Web", "" },
    { "Email", "" },
    { "Documents", "" },
    { "Images", "" },
    { "Multimedia", "" },
    { "Games", ""},
    { "Virtual", "" },
    { "Miscellany", "" },
}

fwin_menu = {
    position = {
        { "Centered", awful.placement.centered },
        { "Bottom Right", awful.placement.bottom_right },
        { "Top Left", awful.placement.top_left },
        { "Left", awful.placement.left },
        { "Right", awful.placement.right },
        { "Bottom Left", awful.placement.bottom_left },
        { "Bottom", awful.placement.bottom_right }
    },
    sizes = {
        { "256x144  [16:9]", 256, 144 },
        { "640x360  [16:9]", 640, 360 },
        { "960x560  [16:9]", 960, 560 },
        { "1280x720 [16:9]", 1280, 720 },
        { "640x480  [4:3]", 640, 480 },
        { "800x600  [4:3]", 800, 600 },
        { "960x720  [4:3]", 960, 720 },
        { "1024x768 [4:3]", 1024, 768 },
        { "1024x576 [16:10]", 1024, 576 },
        { "1152x648 [16:10]", 1152, 648 },
        { "1280x800 [16:10]", 1280, 800 },
        { "1024x576 [16:10]", 1024, 576 },
    }
}

-- }}}

-- {{{ Functions

-- Increment/Decrement functions

function increment(func)
    func(1)
end

function decrement(func)
    func(-1)
end

-- Floating Window functions

function position_floating_win(pfunc)
    local c = client.focus
    pfunc(c)
end

function resize_floating_win(w, h)
    local c = client.focus
    c.height = h
    c.width = w
end

function fit_in_screen_height(s, ratio)
    return s.geometry.height * ratio
end

function fit_in_screen_width(s, ratio)
    return s.geometry.width * ratio
end

function focus_relative_to_master(n)
    master = awful.client.getmaster()
    awful.client.focus.byidx(n, master)
end

function focus_relative_to_current(n)
    awful.client.focus.byidx(n)
end

-- Search functions
-- These functions will bring up terminals that serve as a kind of "dialog"
-- box that will use fzf(1) to find various items.

-- Look through recently opened directories to open in a terminal
function lookfor_dir()
    awful.spawn(terminal .. " -c st-dialog " .. " -t Directories" .. " -g 160x45 " .. " -e " .. exec_d .. "find-dirs.sh")
end

-- Look through a list of files in the home directory to open.
function lookfor_files()
    awful.spawn(terminal .. " -c st-dialog " .. "-g 160x45 " .. " -t Finder " .. " -e " .. exec_d .. "find-file.sh")
end

-- Look through the list of manpages to open them in a terminal.
function lookfor_manpages()
    awful.spawn(terminal .. " -c st-dialog" .. " -t Find Manpage " .. " -g 160x45 " .. " -e " .. exec_d .. " find-man.sh")
end

function resize_client(c, height, width)
    c.height = height
    c.width = width
end
-- }}}

-- Autoloads {{{

-- Loads programs automatically at startup.
awful.spawn.with_shell(exec_d .. "autoexec.sh")

-- }}}

-- {{{ Menus

-- System menu: This menu is used to preform important system-wide actions, like rebooting and such.
system_menu = awful.menu({
    items = {
        { "Switch user", function() awful.with_shell("dm-tool switch-to-greater") end,
          "/run/current-system/sw/share/icons/breeze-dark/actions/32/system-switch-user.svg" },
        { "Restart Awesome", awesome.restart,
          "/run/current-system/sw/share/icons/breeze-dark/actions/32/system-switch-user.svg" },
        { "Exit Awesome", function() awesome.quit() end,
          "/run/current-system/sw/share/icons/breeze-dark/actions/32/system-log-out.svg" },
        { "Lock", function() awful.spawn.with_shell("xautolock -locknow") end,
          "/run/current-system/sw/share/icons/breeze-dark/actions/32/system-lock-screen.svg" },
        { "Suspend", function() awful.spawn.with_shell("systemctl suspend") end,
          "/run/current-system/sw/share/icons/breeze-dark/actions/32/system-suspend.svg" },
        { "Reboot", function() awful.spawn.with_shell("systemctl reboot") end,
          "/run/current-system/sw/share/icons/breeze-dark/actions/32/system-reboot.svg" },
        { "Shut Down", function() awful.spawn.with_shell("systemctl poweroff") end,
          "/run/current-system/sw/share/icons/breeze-dark/actions/32/system-shutdown.svg" }
    },
    theme = {
        height = 48,
        width = 300
    }
})

pos_items = {
    { "Centered",
        function()
            local c = client.focus
            awful.placement.centered(c)
        end
    },
    { "Bottom Right",
        function()
            local c = client.focus
            awful.placement.bottom_right(c)
        end
    },
    { "Top Left",
        function()
            local c = client.focus
            awful.placement.top_left(C)
        end
    },
    { "Left",
        function()
            local c = client.focus
            awful.placement.left(C)
        end
    },
    { "Top Right",
        function()
            local c = client.focus
            awful.placement.top_right(C)
        end
    },
    { "Left",
        function()
            local c = client.focus
            awful.placement.left(C)
        end
    },
    { "Right",
        function()
            local c = client.focus
            awful.placement.right(C)
        end
    },
    { "Bottom Left",
        function()
            local c = client.focus
            awful.placement.bottom_left(C)
        end
    },
    { "Bottom",
        function()
            local c = client.focus
            awful.placement.bottom_right(C)
        end
    },
}

size_items = {
    { "16:9 256x144",
        function()
            local c = client.focus
            c.height = 144
            c.width = 256
        end
    },
    { "16:9 640x360",
        function()
            local c = client.focus
            c.height = 360
            c.width = 640
        end
    },
    { "16:9 960x560",
        function()
            local c = client.focus
            c.height = 560
            c.width = 960
        end
    },
    { "16:9 1280x720",
        function()
            local c = client.focus
            c.height = 720
            c.width = 1280
        end
    },
    { "4:3 640x480",
        function()
            local c = client.focus
            c.height = 480
            c.width = 640
        end
    },
    { "4:3 800x600",
        function()
            local c = client.focus
            c.height = 600
            c.width = 800
        end
    },
    { "4:3 960x720",
        function()
            local c = client.focus
            c.height = 720
            c.width = 960
        end
    },
    { "4:3 1024x768",
        function()
            local c = client.focus
            c.height = 768
            c.width = 1024
        end
    },
    { "16:10 1024x576",
        function()
            local c = client.focus
            c.height = 576
            c.width = 1024
        end
    },
    { "16:10 1152x648",
        function()
            local c = client.focus
            c.height = 648
            c.width = 1152
        end
    },
    { "16:10 1280x800",
        function()
            local c = client.focus
            c.height = 800
            c.width = 1280
        end
    },
    { "16:10 1024x576",
        function()
            local c = client.focus
            c.height = 576
            c.width = 1024
        end
    },
}

float_controls = awful.menu({
    items = {
        { "Move windows", pos_items },
        { "Resize windows", size_items }
    }
})

year_calendar = awful.widget.calendar_popup.year ({
    start_sunday = true,
    week_number = true
})
-- }}}

-- {{{ Wibar

-- Audio widget
-- Tells the current volume and if anything is playing
volume = awful.widget.watch(exec_d .. "status-bar-volume.sh", 1)
volume.font = "fontawesome bold 10"
volume:connect_signal("button::press",
    function(_, _, _, button)
        if button == 1 then
            awful.spawn("pamixer --toggle-mute")
        end
    end)
volume_t = awful.tooltip {
    objects = { volume },
    timer_function = function() awful.spawn.easy_async_with_shell("amixer", function(out) v_text = out end) return v_text end
}

-- Removable media widget
-- Check if there is any removable media current, open menu to change it.
removable = awful.widget.watch(exec_d .. "status-bar-removable.sh", 5)
removable.font = "fontawesome bold 10"
removable:connect_signal("button::press",
    function(_, _, _, button)
        if button == 1 then
            awful.spawn(exec_d .. "/rofi-removable.sh")
        end
    end
)

-- Networking widget
networking = awful.widget.watch(exec_d .. "status-bar-networking.sh", 300)
networking.font = "fontawesome bold 10"
networking:connect_signal("button::press",
    function(_, _, _, button)
        if button == 1 then
            awful.spawn("st -c st-float -e nmtui")
        end
    end

)
networking_t = awful.tooltip {
    objects = { networking },
    timer_function = function() awful.spawn.easy_async_with_shell("nmcli general", function(out) n_text = out end) return n_text end
}

-- Weather widget
-- Widget uses weather(1) to give a simple weather report.
-- Hovering over the text gives additional information.
-- Click on the text should take you to the page with a forecast.
weather = awful.widget.watch(exec_d .. 'status-bar-weather.sh ' .. location, 1800)
weather.font = "weathericons bold 10"
weather:connect_signal("button::press",
function(_, _, _, button)
    if button == 1 then
        awful.spawn(browser .. weather_page)
    elseif button == 3 then
        awful.spawn.with_shell(exec_d .. 'weather-report.sh ' .. location)
    end
end)
weather_t = awful.tooltip {
    objects = { weather },
    timer_function = function() awful.spawn.easy_async_with_shell("weather --metric cyul", function(out) m_text = out end) return m_text end
}

-- MPD widget
mpdstatus = awful.widget.watch(exec_d .. 'mpd-report.sh', 1)
mpdstatus.font = "fontawesome bold 10"
mpdstatus_t = awful.tooltip {
    objects = { mpdstatus },
    timer_function = function() awful.spawn.easy_async_with_shell("mpc status", function(out) m_text = out end) return m_text end
}

-- Calendar widget
-- When hovered, given a calendar of the current month with the current day highlighted.
-- Right clicking shows a year calendar.
clock = wibox.widget.textclock("  %I:%M:%S %p", 1)
clock.font = "sans bold 10"
month_calendar = awful.widget.calendar_popup.month({
    start_sunday = true,
    week_number = true
})
year_calendar = awful.widget.calendar_popup.year({
    start_sunday = true,
    week_number = true
})
month_calendar:attach(clock, "tr")
clock:connect_signal("button::press", function() year_calendar:toggle() end)

-- Create a wibox for each screen and add it
local taglist_buttons = gears.table.join(
                    awful.button({ }, 1, awful.tag.viewtoggle),
                    awful.button({ super }, 1, function(t)
                                              if client.focus then
                                                  client.focus:move_to_tag(t)
                                              end
                                          end),
                    awful.button({ }, 3, function(t) t:view_only() end),
                    awful.button({ super }, 3, function(t)
                                              if client.focus then
                                                  client.focus:toggle_tag(t)
                                              end
                                          end)
                )

local tasklist_buttons = gears.table.join(
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
                     awful.button({ }, 3, function () awful.menu.client_list({ theme = { width = 250 } }, _, function (c) return not c.skip_taskbar end) end),
                     awful.button({ }, 4, function () awful.client.focus.byidx(1) end),
                     awful.button({ }, 5, function () awful.client.focus.byidx(-1) end))

local function set_wallpaper(s)
    -- Wallpaper
    if beautiful.wallpaper then
        local wallpaper = beautiful.wallpaper
        -- If wallpaper is a function, call it with the screen
        if type(wallpaper) == "function" then
            wallpaper = wallpaper(s)
        end
        gears.wallpaper.maximized(wallpaper, s, true)
    end
end

-- Re-set wallpaper when a screen's geometry changes (e.g. different resolution)
screen.connect_signal("property::geometry", set_wallpaper)

awful.screen.connect_for_each_screen(function(s)
    -- Wallpaper
    set_wallpaper(s)

    for i, tag in ipairs(tag_symbols) do
        awful.tag.add(
            tag[1], {
               screen = s,
               layout = awful.layout.layouts[1]
            }
        )
    end

    awful.tag.viewtoggle(s.tags[1])

    -- Create a promptbox for each screen
    s.mypromptbox = awful.widget.prompt()
    -- Create an imagebox widget which will contain an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    s.mylayoutbox = awful.widget.layoutbox(s)
    s.mylayoutbox:buttons(gears.table.join(
                           awful.button({ }, 1, function () awful.layout.inc( 1) end),
                           awful.button({ }, 3, function () awful.layout.inc(-1) end),
                           awful.button({ }, 4, function () awful.layout.inc( 1) end),
                           awful.button({ }, 5, function () awful.layout.inc(-1) end)))
    -- Create a taglist widget
    s.mytaglist = awful.widget.taglist {
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

    s.mytasklist = awful.widget.tasklist {
        screen   = s,
        filter   = awful.widget.tasklist.filter.currenttags,
        buttons  = tasklist_buttons,
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
        },
        create_callback = function(self, c, i, cls)
            local tt = awful.tooltip {
                objects = { self },
                timer_function = function() return "Hello World!" end
            }
        end
    }

    -- Create the wibox
    s.mywibox = awful.wibar({ position = "top", screen = s })

    -- Add widgets to the wibox
    s.mywibox:setup {
        layout = wibox.layout.align.horizontal,
        { -- Left widgets
            layout = wibox.layout.fixed.horizontal,
            s.mytaglist
        },
        s.mytasklist, -- Middle widget
        { -- Right widgets
            layout = wibox.layout.fixed.horizontal,
            -- wibox.widget.systray(),
            removable,
            networking,
            volume,
            mpdstatus,
            weather,
            clock,
            s.mylayoutbox,
        },
    }
end)
-- }}}

-- {{{ Mouse bindings
root.buttons(gears.table.join(
    awful.button({ }, 3, function () system_menu:toggle() end),
    awful.button({ }, 4, awful.tag.viewnext),
    awful.button({ }, 5, awful.tag.viewprev)
))
-- }}}

-- Rofi menus
rofi_cmd = "rofi -show combi window drun run -combi-modi \"window,drun,run\""

function rofi_drun()
    awful.spawn.with_shell("export XDG_CURRENT_DESKTOP=kde && " .. "rofi -show combi window drun run -combi-modi \"window,drun\"")
end

function rofi_run()
    awful.spawn.with_shell("export XDG_CURRENT_DESKTOP=kde && " .. "rofi -show combi window drun run -combi-modi \"window,run\"")
end

function create_prompt(question, action)
    awful.spawn.with_shell(exec_d .. "./rofi-prompt.sh " .. question .. " " .. action)
end

shutdown_prompt = function() create_prompt("\"Shutdown your system?\"", "systemctl poweroff") end

reboot_prompt = function() create_prompt("\"Restart your system?\"", "systemctl reboot") end

quit_prompt = function() create_prompt("\"Quit AwesomeWM?\"", "awesome-client \"awesome.quit()\"") end

restart_prompt = function() create_prompt("\"Restart AwesomeWM?\"", "awesome-client \"awesome.restart()\"") end

-- {{{ Key bindings
globalkeys = gears.table.join(

    -- Spawn new programs or switch to existing programs, using rofi as a launcher
    awful.key({ super }, "f", rofi_drun,
              { description = "Find program to run", group = "Launch"}),

    awful.key({ super, shift }, "f", rofi_run,
              { description = "Find any program to run", group = "Launch"}),

    -- Spawn specific programs
    awful.key({ super }, "Return", function () awful.spawn(terminal) end,
              {description = "Spawn a terminal", group = "Launch"}),

    awful.key({ super, shift }, "Return", function () awful.spawn(exec_d .. "rofi-tmux.sh") end,
              {description = "Attach to tmux session in new terminal", group = "Launch"}),

    awful.key({ super }, "w", function() awful.spawn.raise_or_spawn(browser) end,
              { description = "Open web browser", group = "Launch"}),

    awful.key({ super }, "e", function() awful.spawn.raise_or_spawn(email) end,
              { description = "Open email", group = "Launch"}),

    awful.key({ super }, "p", function() awful.spawn.with_shell("rofi-pass --last-used") end,
              { description = "Open passwords", group = "Launch"}),

    -- Search for files
    awful.key({ super }, "s", lookfor_files,
              { description = "Search for files to open", group = "Launch"}),

    awful.key({ super }, "d", lookfor_dir,
       { description = "Find directories to open", group = "Launch"}),

    awful.key({ super }, "F1", lookfor_manpages,
       { description = "Find manpages to open", group = "Launch"}),

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
    awful.key({ super,           }, "space", function () awful.layout.inc( 1)                end,
              {description = "Select next", group = "layout"}),

    awful.key({ super, "Shift"   }, "space", function () awful.layout.inc(-1)                end,
              {description = "Select previous", group = "layout"}),

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
    awful.key( { super }, "i", function() awful.tag.incmwfact(0.05) end,
        { description = "Increase master width factor" , group = "Tag" }),

    awful.key( { super, shift }, "i", function() awful.tag.incmwfact(-0.05) end,
        { description = "Decrease master width factor" , group = "Tag" }),

    awful.key( { super, control }, "i", function() client.focus.first_tag.master_width_factor = 0.5 end,
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

    awful.key({ super, control   }, "s",      hotkeys_popup.show_help,
              {description="Show shortcuts", group="awesome"}),

    -- System functions
    awful.key({ super }, "Escape", function() awful.spawn.with_shell(exec_d .. "rofi-system.sh") end,
               {description = "Show system menu", group = "System"}),

    awful.key({ super }, "q", quit_prompt,
        { description = "Quit Awesome", group = "System"}),

    awful.key({ super, shift }, "q", shutdown_prompt,
        { description = "Shutdown Computer", group = "System"}),

    awful.key({ super }, "r", restart_prompt,
        { description = "Restart AwesomeWM", group = "System"}),

    awful.key({ super, shift }, "r", reboot_prompt,
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

clientkeys = gears.table.join(
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
    awful.key({ super, "Control" }, "space",  awful.client.floating.toggle                     ,
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

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it work on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, 9 do
    globalkeys = gears.table.join(globalkeys,
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
                  {description = "Toggle tag #"..i, group = "tag"}),
        -- Toggle only viewing that tag.
        awful.key({ super, "Control" }, "#" .. i + 9,
                  function ()
                      local screen = awful.screen.focused()
                      local tag = screen.tags[i]
                      if tag then
                           tag:view_only()
                      end
                  end,
                  {description = "Toggle tag #" .. i, group = "tag"}),
        -- Move client to tag.
        awful.key({ super, "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag = client.focus.screen.tags[i]
                          if tag then
                              client.focus:move_to_tag(tag)
                          end
                     end
                  end,
                  {description = "move focused client to tag #"..i, group = "tag"}),
        -- Toggle tag on focused client.
        awful.key({ super, "Control", "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag = client.focus.screen.tags[i]
                          if tag then
                              client.focus:toggle_tag(tag)
                          end
                      end
                  end,
                  {description = "toggle focused client on tag #" .. i, group = "tag"})
    )
end

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

-- Set keys
root.keys(globalkeys)
-- }}}

-- {{{ Rules
-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules = {
    -- All clients will match this rule.
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

    -- Floating clients.
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
          "st-float"},

        -- Note that the name property shown in xprop might be set slightly after creation of the client
        -- and the name shown there might not match defined rules here.
        name = {
          "Event Tester",  -- xev.
        },
        role = {
          "AlarmWindow",  -- Thunderbird's calendar.
          "ConfigManager",  -- Thunderbird's about:config.
          "pop-up",       -- e.g. Google Chrome's (detached) Developer Tools.
        }
      }, properties = { floating = true }},

    -- Center and add titlebars to dialog windows
    { rule_any = { type = { "dialog" } },
      properties = { titlebars_enabled = true,
                     placement = awful.placement.centered } },

    -- Assign applications to tags

    { rule_any = { class = { "Firefox", "Brave" } },
      properties = { tag = "Web" } },

    -- Thunderbird
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
      properties = { tag = "Other" } },

    -- Conky should be present in all windows
    { rule = { class = "Conky" },
      properties = { sticky = true,
                     skip_taskbar = true }},

    { rule = { class = "st-256color" },
      properties = { icon = "utilities-terminal"} },

    -- Used for some of the dialogs
    { rule = { class = "st-dialog" },
      properties = { floating = true,
                     placement = awful.placement.centered } },

    { rule = { class = "Firefox", name = "Picture-in-Picture" },
      properties = { floating = true,
                     sticky = true,
                     placement = awful.placement.bottom_right } },

}
-- }}}

-- {{{ Signals
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

-- When toggling floating mode, force clients to have a titlebar.k
client.connect_signal(
    "property::floating",
    function(c)
        if c.floating and c.class ~= 'Conky' then
            awful.titlebar.show(c)
        else
            awful.titlebar.hide(c)
        end
    end
)

-- Add a titlebar if titlebars_enabled is set to true in the rules.
client.connect_signal("request::titlebars", function(c)
    -- buttons for the titlebar
    local buttons = gears.table.join(
        awful.button({ }, 1, function()
            c:emit_signal("request::activate", "titlebar", {raise = true})
            awful.mouse.client.move(c)
        end),
        awful.button({ }, 3, function()
            c:emit_signal("request::activate", "titlebar", {raise = true})
            awful.mouse.client.resize(c)
        end)
    )

    awful.titlebar(c) : setup {
        { -- Left
            awful.titlebar.widget.iconwidget(c),
            buttons = buttons,
            layout  = wibox.layout.fixed.horizontal
        },
        { -- Middle
            { -- Title
                align  = "center",
                widget = awful.titlebar.widget.titlewidget(c)
            },
            buttons = buttons,
            layout  = wibox.layout.flex.horizontal
        },
        { -- Right
            awful.titlebar.widget.floatingbutton (c),
            awful.titlebar.widget.maximizedbutton(c),
            awful.titlebar.widget.stickybutton   (c),
            awful.titlebar.widget.ontopbutton    (c),
            awful.titlebar.widget.closebutton    (c),
            layout = wibox.layout.fixed.horizontal()
        },
        layout = wibox.layout.align.horizontal
    }
end)

-- Enable sloppy focus, so that focus follows mouse.
client.connect_signal("mouse::enter", function(c)
    c:emit_signal("request::activate", "mouse_enter", {raise = false})
end)

client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)

-- No borders with the max layout or if there is only a single tile client.
screen.connect_signal("arrange",
    function (s)
        local t = s.selected_tag
        local l = t.layout

        for _, c in pairs(s.clients) do
            if #s.tiled_clients == 1 or l == awful.layout.suit.max then
                c.border_width = 0
            else
                c.border_width = beautiful.border_width
            end
        end
    end)
-- }}}
