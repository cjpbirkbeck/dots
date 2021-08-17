-- Sets up each connected screen, including:
-- * Setup up the wallpapers
-- * Creating all the tags
-- * Creating the wibar and its widgets.

local gears = require("gears")
local awful = require("awful")
local beautiful = require("beautiful")

local tag_symbols = require("lib.vars.tags")
local setup_status_bar = require("main.statusbar")

local landscapes_d = rc.home_d .. "/imgs/wallpapers/landscapes/"
local cityscapes_d = rc.home_d .. "/imgs/wallpapers/cityscapes/"

math.randomseed(os.time())
local is_first_landscape = math.random() >= 0.5
local rand_wp_timeout = 600

local function get_random_file(dir)
    awful.spawn.easy_async_with_shell("shuf --head-count=1 --echo " .. dir .. "*",
        function(stdout, stderr, reason, exit_code)
            rand_file = stdout
        end)
end

local rand_wp = gears.timer { timer = rand_wp_timeout }
rand_wp:connect_signal("timeout",
    function()
        local is_landscape = is_first_landscape

        for s = 1, screen.count() do
            local wp_path
            if is_landscape then
                wp_path = get_random_file(landscapes_d)
            else
                wp_path = get_random_file(cityscapes_d)
            end
            rand_file = gears.string.split(rand_file, "\n")[1]
            gears.wallpaper.maximized(rand_file, s, true)
            -- naughty.notify{ title = "Wallpaper", text = "changed to " .. rand_file }
            is_landscape = not is_landscape
        end

        is_first_landscape = not is_first_landscape

        rand_wp:stop()
        rand_wp.timeout = rand_wp_timeout
        rand_wp:start()
    end)

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

local function set_tags(s, tags)
    for i, tag in ipairs(tags) do
        awful.tag.add(
            tag[1], {
               screen = s,
               layout = awful.layout.layouts[1]
            }
        )
    end
end

-- Re-set wallpaper when a screen's geometry changes (e.g. different resolution)
screen.connect_signal("property::geometry", set_wallpaper)

-- Start randomizing the wallpaper
if is_first_landscape then
    get_random_file(landscapes_d)
else
    get_random_file(cityscapes_d)
end
rand_wp:start()

awful.screen.connect_for_each_screen(
    function(s)
        set_tags(s, tag_symbols)
        awful.tag.viewtoggle(s.tags[1])
        setup_status_bar(s)
    end)
