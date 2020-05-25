local awful = require("awful")

local function resize_client(c, width, height)
    c.width = width
    c.height = height
end

local size = awful.menu({
    items = {
        { "256x144  [16:9]", function() resize_client(client.focus, 256, 144) end },
        { "640x360  [16:9]", function() resize_client(client.focus, 640, 360) end },
        { "960x560  [16:9]", function() resize_client(client.focus, 960, 560) end },
        { "1280x720 [16:9]", function() resize_client(client.focus, 1280, 720) end },
        { "640x480  [4:3]", function() resize_client(client.focus, 640, 480) end },
        { "800x600  [4:3]", function() resize_client(client.focus, 800, 600) end },
        { "960x720  [4:3]", function() resize_client(client.focus, 960, 720) end },
        { "1024x768 [4:3]", function() resize_client(client.focus, 1024, 768) end },
        { "1024x576 [16:10]", function() resize_client(client.focus, 1024, 576) end },
        { "1152x648 [16:10]", function() resize_client(client.focus, 1152, 648) end },
        { "1280x800 [16:10]", function() resize_client(client.focus, 1280, 800) end },
        { "1024x576 [16:10]", function() resize_client(client.focus, 1024, 576) end },
    },
    theme = {
        bg_focus = "#FFFFFF",
        fg_focus = "#000000",
        width = 200
    }
})

return size
