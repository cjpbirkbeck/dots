# Awesomewm config

My configuration for the [Awesome window manager](https://www.awesomewm.org/), a titling window manager.

## Features

* Uses the tags as they were originally designed in dwm; tags are collections of clients that can be combined with one another freely.
-- Added some key combinations for control the tags: `s-0` — select all tags with at least one client, `s-S-0` — select all tags of the current client. `s-C-0` — reverse toggle on all tags.
-- Number tags will never toggle off if it is only tag active.
* No window borders for stacked clients in the max layout, or if they is only one non-floating client in any other layout.
* Only dialog boxes have a title bar.
* Special 'mode' for floating windows. In particular, it has menus to specify an exact position and an exact size.
* Randomly switches wallpapers.
* Uses 5 different layouts: max, tile, tile bottom and deck and the horizontal deck. The last two is a layout of my own design, based of the deck layout in qtile, and a similar layout in dwm. The screen is divided into two section: one for the master window(s) and the other for other windows. All master windows are tiled, while the slave windows are stacked.

## TODO

* Wallpaper code is absolute mess and is completely unportable. Need to rewrite from the ground up, either within lua or in another programming language via shell.
* Need to refactor the window control codes.
