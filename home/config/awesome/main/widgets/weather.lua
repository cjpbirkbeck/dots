local gears = require("gears")
local awful = require("awful")

local location = "cyul"
local weather_page = "https://weather.gc.ca/city/pages/qc-147_metric_e.html"

-- Weather widget
-- Widget uses weather(1) to give a simple weather report.
-- Hovering over the text gives additional information.
-- Click on the text should take you to the page with a forecast.
local weather = awful.widget.watch(rc.exec_d .. 'status-bar-weather.sh ' .. location, 1800)
weather.font = "weathericons bold 10"
weather:connect_signal("button::press",
function(_, _, _, button)
    if button == 1 then
        -- if not rc.browser then browser = "firefox " end
        awful.spawn("firefox " .. weather_page)
    elseif button == 3 then
        awful.spawn.with_shell(exec_d .. 'weather-report.sh ' .. location)
    end
end)
local weather_t = awful.tooltip {
    objects = { weather },
    timer_function = function()
        awful.spawn.easy_async_with_shell("weather --metric cyul",
        function(out) w_text = out end)
            return w_text
        end
}

return weather
