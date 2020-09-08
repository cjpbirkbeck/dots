local awful = require('awful')

local t = {}

t.focus_master = function(c)
    local s = c.screen
    local tiled = s:get_tiled_clients(false)
    local first_tiled = tiled[1]

    awful.client.focus.byidx(0, first_tiled)
end

t.focus_next = function(c)
    local s = c.screen
    local tiled = s:get_tiled_clients(false)
    if #tiled > 1 then
        local n = awful.client.next(1)
        while true do
            if not n.floating then break end
            n = awful.client.next(1, n)
        end
        awful.client.focus.byidx(0, n)
    end
end

t.focus_prev = function(c)
    local s = c.screen
    local tiled = s:get_tiled_clients(false)
    if #tiled > 1 then
        local p = awful.client.next(-1)
        while true do
            if not p.floating then break end
            p = awful.client.next(-1, p)
        end
        awful.client.focus.byidx(0, p)
    end
end

t.swap_master = function(c)
    local s = c.screen
    local tiled = s:get_tiled_clients(false)
    local first_tiled = tiled[1]

    c:swap(first_tiled)
end

t.swap_next = function(c)
    local s = c.screen
    local tiled = s:get_tiled_clients(false)
    if #tiled > 1 then
        local n = awful.client.next(1)
        while true do
            if not n.floating then break end
            n = awful.client.next(1, n)
        end
        c:swap(n)
    end
end

t.swap_prev = function(c)
    local s = c.screen
    local tiled = s:get_tiled_clients(false)
    if #tiled > 1 then
        local p = awful.client.next(-1)
        while true do
            if not p.floating then break end
            p = awful.client.next(-1, p)
        end
        c:swap(p)
    end
end

return t
