--[[
    This layout has master clients that is always tiled to the left,
    with all other slave windows stack over each other column to the right.
    It has one variant, which has the master clients on top and the stacked
    slave windows below.

    Based off the cascade layout from the Lain repository.

     Licensed under GNU General Public License v2
      * (c) 2014,      projektile
      * (c) 2013,      Luca CPZ
      * (c) 2010-2012, Peter Hofmann
      * (c) 2020-2021, Christopher Birkbeck
--]]

local floor  = math.floor
local screen = screen

-- TODO: Add icon support (use lain's cascadetilew.png as an interm icon).

-- @beautiful beautiful.layout_deck
local deck = {
    name     = "deck",
    icon = "/home/cjpbirkbeck/.config/awesome/theme/layouts/cascadetilew.png",
    single_fills_screen = true,
    single_master = false,
    horizontal     = {
        name          = "horideck",
    },
}

local function do_deck(p, splith)
    local t = p.tag or screen[p.screen].selected_tag
    local wa = p.workarea
    local cls = p.clients

    if #cls == 0 then return end

    -- If deck.single_fills_screen is true, when there is only a single client,
    -- then that client will fill up the entire work area. If false, then the
    -- the client will only take up space with its respectively row or column.
    if #cls == 1 and deck.single_fills_screen then
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
        -- Layout with one fixed column on the right meant for master windows.
        -- Its width is calculated according to mwfact. If deck.single_master is
        -- true, then only a single client will be in the master column.
        -- If false, then the master column will have several clients tiled,
        -- according to the master count. The other clients are decked or
        -- "tabbed" in a slave column on the right.

        --   +------+-------+
        --   |      |       |   1 = Column with master clients, tiled
        --   |      |       |       if there are multiple master clients.
        --   |   1  |   2   |
        --   |      |       |   2 = Column with all other windows, stacked
        --   |      |       |       over one another.
        --   +------+-------+

        local mwfact = t.master_width_factor
        local mcount = t.master_count
        local start  = 2

        if #cls <= 0 then return end

        -- Rounding is necessary to prevent the rendered size of slavewid
        -- from being 1 pixel off when the result is not an integer.
        local mainwid = floor(wa.width * mwfact)
        local slavewid = wa.width - mainwid
        local mainheight = floor(wa.height / mcount)

        -- Main column, fixed width and height.
        if deck.single_master then
            local c = cls[1]
            local g = {}

            g.width = mainwid
            g.height = wa.height
            g.x = wa.x
            g.y = wa.y

            if g.width < 1  then g.width  = 1 end
            if g.height < 1 then g.height = 1 end

            p.geometries[c] = g
        else
            for i=1,mcount do
                local c = cls[i]
                local g = {}

                g.width = mainwid
                g.height = mainheight
                g.x = wa.x
                g.y = wa.y + (i - 1) * mainheight

                if g.width < 1  then g.width  = 1 end
                if g.height < 1 then g.height = 1 end

                p.geometries[c] = g
            end
        end

        -- Remaining clients stacked in slave column, new ones on top.
        if #cls <= 1 then return end

        if not deck.single_master then
            start = mcount + 1
        end

        for i = start,#cls do
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
        -- Layout with one fixed roe on the top meant for master windows. Its
        -- height is calculated according to mwfact. If deck.single_master is
        -- true, then only a single client will be in the master row.
        -- If false, them the master row will have several clients tiled within
        -- that row, according to the master_count. The other clients are
        -- decked or "tabbed" in a slave column on the bottom.

        --   +--------------+
        --   | 1            |   1 = row with master clients, tiled if
        --   |              |       multiple.
        --   +--------------+
        --   | 2            |   2 = row with all other windows stacked
        --   |              |       over another.
        --   +--------------+

        local mwfact = t.master_width_factor
        local mcount = t.master_count
        local start  = 2

        -- Rounding is necessary to prevent the rendered size of slavewid
        -- from being 1 pixel off when the result is not an integer.
        local mainhgt = floor(wa.height * mwfact)
        local slavehgt = wa.height - mainhgt
        local mainwidth = floor(wa.width / mcount)

        -- Main row, fixed width and height.
        if deck.single_master then
            local c = cls[1]
            local g = {}

            g.width = wa.width
            g.height = mainhgt
            g.x = wa.x
            g.y = wa.y

            if g.width < 1  then g.width  = 1 end
            if g.height < 1 then g.height = 1 end

            p.geometries[c] = g
        else
            for i=1,mcount do
                local c = cls[i]
                local g = {}

                g.width = mainwidth
                g.height = mainhgt
                g.x = wa.x + (i - 1) * mainwidth
                g.y = wa.y

                if g.width < 1  then g.width  = 1 end
                if g.height < 1 then g.height = 1 end

                p.geometries[c] = g
            end
        end

        -- Remaining clients stacked in slave column, new ones on top.
        if #cls <= 1 then return end

        if not deck.single_master then
            start = mcount + 1
        end

        for i = start,#cls do
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
