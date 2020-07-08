local gears = require("gears")
local awful = require("awful")

local function setup_layoutbox(s)
    local lobox = awful.widget.layoutbox(s)
    lobox:buttons(
        gears.table.join(
            awful.button({ }, 1, function () awful.layout.inc( 1) end),
            awful.button({ }, 3, function () awful.layout.inc(-1) end),
            awful.button({ }, 4, function () awful.layout.inc( 1) end),
            awful.button({ }, 5, function () awful.layout.inc(-1) end)))

    return lobox
end

return setup_layoutbox
