-- Show the status of the three toggle keys for standard PC keyboards
-- Caps lock, numb lock and scroll lock

local widget = require("awful.widget")

local w = widget.watch(rc.exec_d .. "status-bar-keyboard.sh", 1)
w.font = "fontawesome bold 10"

return w
