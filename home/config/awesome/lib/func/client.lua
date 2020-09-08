-- Functions for working with windows

local t = {}

-- Fuctions for focusing and swapping tiled (and stacked) clients.
t.focus_tiled_master = local function (c)
    local s = c.screen
    local tiled = s:get_tiled_clients(false)
    local first_tiled = tiled[1]

    awful.client.focus.byidx(0, first_tiled)
end

t.swap_tiled_master = local function (c)
    local s = c.screen
    local tiled = s:get_tiled_clients(false)
    local first_tiled = tiled[1]

    c:swap(first_tiled)
end

t.focus_tiled = local function (c, n)
    local s = c.screen
    local tiled = s:get_tiled_clients(false)
    if #tiled > 1 then
        local new = awful.client.next(n)
        while true do
            if not n.floating then break end
            new = awful.client.next(1, new)
        end
        awful.client.focus.byidx(0, new)
    end
end

t.swap_tiled = local function (c, n)
    local s = c.screen
    local tiled = s:get_tiled_clients(false)
    if #tiled > 1 then
        local new = awful.client.next(n)
        while true do
            if not p.floating then break end
            new = awful.client.next(1, new)
        end
        c:swap(new)
    end
end

t.move_floating_client = local function (c, coord, incr)
    c.coord + incr
    awful.placement.no_offscreen(c)
end

t.change_floating_height = local function (c, min_height, incr)
    local max_height = c.screen.geometry.height
    local new = c.height + incr

    if new >= min_height and new <= max_height then c.height = new end
end

t.change_floating_width = local function (c, min_width, incr)
    local max_width = c.screen.geometry.width
    local new = c.width + incr

    if new >= min_width and new <= max_width then c.width = new end
end

-- Toggle between tiled and floating clients.
-- If focused client is floating, get next tiled client
-- If focused client is tiled, get next floating client
t.toggle_focus = local function (c)
    local s = c.screen
    local cls = s.clients
    if #cls > 1 then
        local n = awful.client.next(1)
        for i = 1,#cls,1 do
            n = awful.client.next(1, n)
            if c.floating then
                if not n.floating then break end
            else
                if n.floating then break end
            end
        end
        awful.client.focus.byidx(0, n)
    end
end

-- Function increment size changes in both directions, preserving the aspect ratio.
t.change_floating_size = local function (c, incr)
    local max_width = c.screen.geometry.width
    local max_height = c.screen.geometry.height
    local new_width = c.width + incr
    local new_height = c.height + incr

    if c.floating and new_width >= min_width and new_width <= max_width and
        new_height >= min_height and new_height <= max_height
        then
        c.width = new_width
        c.height = new_height
    end
end

return t
