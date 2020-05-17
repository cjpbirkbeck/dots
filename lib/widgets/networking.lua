local gears = require("gears")
local awful = require("awful")

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

return networking
