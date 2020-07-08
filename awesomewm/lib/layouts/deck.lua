--[[
    This layout has one master window that is always tiled to the left,
    with all other slave windows stack over each other column to the right.
    It has one varient, which has the master window on top and the stacked
    slave windows below.

    Based off the cascade layout from the Lain repository.

     Licensed under GNU General Public License v2
      * (c) 2014,      projektile
      * (c) 2013,      Luca CPZ
      * (c) 2010-2012, Peter Hofmann
      * (c) 2020       Christopher Birkbeck
--]]

local floor  = math.floor
local screen = screen

local deck = {
    name     = "deck",
    icon = "/home/cjpbirkbeck/.config/awesome/themes/custom/layouts/cascadetilew.png",
    horizontal     = {
        name          = "horideck",
    },
}

local function do_deck(p, splith)
    local t = p.tag or screen[p.screen].selected_tag
    local wa = p.workarea
    local cls = p.clients

    if #cls == 0 then return end

    -- If there only 1 windows, just let it take the entire screen
    -- like with suit.max
    if #cls == 1 then
        for _,c in pairs(cls) do
            p.geometries[c] = {
                x = wa.x,
                y = wa.y,
                width = wa.width,
                height = wa.height
            }
        end
        return
    end

    if not splith then
        -- Default vertical split.
        -- Layout with one fixed column meant for a master window. Its
        -- width is calculated according to mwfact. Other clients are
        -- decked or "tabbed" in a slave column on the right.

        --   +--------------+
        --   |      |       |
        --   |      |       |   1 = Column with a single master window.
        --   |   1  |   2   |
        --   |      |       |   2 = Column with all other windows, stacked
        --   |      |       |       over one another.
        --   +--------------+

        local mwfact = t.master_width_factor
        local mcount = t.master_count

        if #cls <= 0 then return end

        -- Main column, fixed width and height.
        local c = cls[1]
        local g = {}
        -- Rounding is necessary to prevent the rendered size of slavewid
        -- from being 1 pixel off when the result is not an integer.
        local mainwid = floor(wa.width * mwfact)
        local slavewid = wa.width - mainwid

        g.width = mainwid
        g.height = wa.height
        g.x = wa.x
        g.y = wa.y

        if g.width < 1  then g.width  = 1 end
        if g.height < 1 then g.height = 1 end

        p.geometries[c] = g

        -- Remaining clients stacked in slave column, new ones on top.
        if #cls <= 1 then return end
        for i = 2,#cls do
            c = cls[i]
            g = {}

            g.width  = slavewid
            g.height = wa.height

            g.x = wa.x + mainwid
            g.y = wa.y

            if g.width < 1  then g.width  = 1 end
            if g.height < 1 then g.height = 1 end

            p.geometries[c] = g
        end
    else
        -- Horizontial split.
        -- Layout with one fixed column meant for a master window. Its
        -- height is calculated according to mwfact. Other clients are
        -- deckd or "tabbed" in a slave column on the bottom.

        --   +----------+---+
        --   | 1            |
        --   |              |   1 = row with a single master
        --   +--------------+
        --   | 2            |   2 = row with all other windows stacked
        --   |              |       over another.
        --   +----------+---+

        local mwfact = t.master_width_factor
        local mcount = t.master_count

        if #cls <= 0 then return end

        -- Main column, fixed width and height.
        local c = cls[1]
        local g = {}
        -- Rounding is necessary to prevent the rendered size of slavewid
        -- from being 1 pixel off when the result is not an integer.
        local mainhgt = floor(wa.height * mwfact)
        local slavehgt = wa.height - mainhgt

        g.height = mainhgt
        g.width = wa.width
        g.x = wa.x
        g.y = wa.y

        if g.width < 1  then g.width  = 1 end
        if g.height < 1 then g.height = 1 end

        p.geometries[c] = g

        -- Remaining clients stacked in slave column, new ones on top.
        if #cls <= 1 then return end
        for i = 2,#cls do
            c = cls[i]
            g = {}

            g.height  = slavehgt
            g.width = wa.width

            g.x = wa.x
            g.y = wa.y + mainhgt

            if g.width < 1  then g.width  = 1 end
            if g.height < 1 then g.height = 1 end

            p.geometries[c] = g
        end
    end
end

function deck.horizontal.arrange(p)
    return do_deck(p, true)
end

function deck.arrange(p)
    return do_deck(p, false)
end

return deck
