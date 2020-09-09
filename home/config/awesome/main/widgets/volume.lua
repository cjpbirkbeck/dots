local gears = require("gears")
local awful = require("awful")

-- Audio widget
-- Tells the current volume and if anything is playing
local volume = awful.widget.watch(rc.exec_d .. "status-bar-volume.sh", 1)

volume.font = "fontawesome bold 10"
volume:connect_signal("button::press",
    function(_, _, _, button)
        if button == 1 then
            awful.spawn("pamixer --toggle-mute")
        end
    end)

local volume_t = awful.tooltip {
    objects = { volume },
    timer_function = function() awful.spawn.easy_async_with_shell("amixer", function(out) v_text = out end) return v_text end
}

return volume
