local gears = require("gears")
local awful = require("awful")

local tooltip_script = "if command -v nmcli 2&>1 /dev/null; then nmcli general; else netstat -i; fi"

-- Networking widget
local networking = awful.widget.watch(exec_d .. "status-bar-networking.sh", 300)

networking.font = "fontawesome bold 10"
networking:connect_signal("button::press",
    function(_, _, _, button)
        if button == 1 then
            awful.spawn.with_shell("if command -v nmtui; then st -c st-float -e nmtui; fi")
        end
    end
)
local networking_t = awful.tooltip {
    objects = { networking },
    timer_function = function() awful.spawn.easy_async_with_shell(tooltip_script, function(out) n_text = out end) return n_text end
}

return networking
