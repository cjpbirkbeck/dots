-- Functions for moving and resizing floating client
-- Coordindates for x and y are measure from the top right corner of the client.
-- Width and height are also calculated from that point.

local awful = require('awful')

-- Constants
local reposition_inc = 5
local resize_inc = 5
local min_width = 12
local min_height = 20

local t = {}

-- Movement functions
t.move_left = function(c)
    c.x = c.x - reposition_inc
    awful.placement.no_offscreen(c)
end

t.move_down = function(c)
    c.y = c.y + reposition_inc
    awful.placement.no_offscreen(c)
end

t.move_up = function(c)
    c.y = c.y - reposition_inc
    awful.placement.no_offscreen(c)
end

t.move_right = function(c)
    c.x = c.x + reposition_inc
    awful.placement.no_offscreen(c)
end

-- Resize functions
t.shrink_left = function(c)
    local max_width = c.screen.geometry.width
    local new = c.width - resize_inc

    if c.floating and new >= min_width and new <= max_width then c.width = new end
end

t.grow_down = function(c)
    local max_height = c.screen.geometry.height
    local new = c.height + resize_inc

    if c.floating and new >= min_height and new <= max_height then c.height = new end
end

t.shrink_up = function(c)
    local max_height = c.screen.geometry.height
    local new = c.height - resize_inc

    if c.floating and new >= min_height and new <= max_height then c.height = new end
end

t.grow_right = function(c)
    local max_width = c.screen.geometry.width
    local new = c.width + resize_inc

    if c.floating and new >= min_width and new <= max_width then c.width = new end
end

-- These functions will increase or decrease both dimentions by the same amount,
-- preserving aspect ratio.
t.grow = function(c)
    local max_width = c.screen.geometry.width
    local max_height = c.screen.geometry.height
    local new_width = c.width + resize_inc
    local new_height = c.height + resize_inc

    if c.floating and new_width >= min_width and new_width <= max_width and
        new_height >= min_height and new_height <= max_height then
        c.width = new_width
        c.height = new_height
    end
end

t.shrink = function(c)
    local max_width = c.screen.geometry.width
    local max_height = c.screen.geometry.height
    local new_width = c.width - resize_inc
    local new_height = c.height - resize_inc

    if c.floating and new_width >= min_width and new_width <= max_width and
        new_height >= min_height and new_height <= max_height then
        c.width = new_width
        c.height = new_height
    end
end

return t
