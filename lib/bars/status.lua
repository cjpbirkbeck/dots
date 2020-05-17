layoutbox = awful.widget.layoutbox(s)

taglist = awful.widget.taglist {
    screen = s,
    filter = awful.widget.taglist.filter.all,
}

bar = awful.wibar({ position = "top", screen = s})

bar:setup{
    layout = wibox.layout.align.horizontal,
    {
        layout = wibox.layout.fixed.horizontal,
        -- layout indicator
        -- seperator?
        taglist
    },
    clientlist,
    {
        layout  = wibox.layout.fixed.horizontal,
        -- Audio widget
        -- Removable media widget
        -- Networking widget
        -- Weather
        -- Time
    }
}
