local gears = require("gears")
local awful = require("awful")

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

return removable
