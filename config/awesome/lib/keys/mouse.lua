local gears = require("gears")
local awful = require("awful")

local mousebinds = gears.table.join(
    awful.button({ }, 1, function() awful.spawn(terminal) end),
    awful.button({ }, 3, function () awful.spawn.with_shell(launcher) end)
)

return mousebinds
