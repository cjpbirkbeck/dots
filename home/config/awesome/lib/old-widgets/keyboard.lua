local widget = require("awful.widget")

local w = widget.watch(exec_d .. "status-bar-keyboard.sh", 1)
w.font = "fontawesome bold 10"

return w
