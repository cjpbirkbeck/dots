-- Layouts

local lo = require("awful.layout")
local deck = require("lib.deck")

-- Set layout table
lo.layouts = {
    lo.suit.max,
    deck,
    lo.suit.tile,
    deck.horizontal,
    lo.suit.tile.bottom,
}

