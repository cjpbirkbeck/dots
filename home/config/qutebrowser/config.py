# Manual configuration for qutebrowser.
# type: ignore (This shuts up pythons errors)

import subprocess
import os
from qutebrowser.api import interceptor

# Documentation:
#   qute://help/configuring.html
#   qute://help/settings.html

# Uncomment this to still load settings configured via autoconfig.yml
config.load_autoconfig()

# Aliases for commands. The keys of the given dictionary are the
# aliases, while the values are the commands they map to.
# Type: Dict
c.aliases = {'Q': 'quit', 'q': 'quit', 'w': 'session-save', 'wq': 'quit --save',
             'about': "open -t qute://version/"}

# Use both adblocking methods
c.content.blocking.enabled = True
c.content.blocking.method = 'both'

# UTF by default
c.content.default_encoding = 'utf-8'

# Add Canadian English as the first locality.
c.content.headers.accept_language = 'en-CA,en-US,en;q=0.9'

# Set Dark Mode
# config.set("colors.webpage.darkmode.enabled", True)

# Enable JavaScript.
# Type: Bool
config.set('content.javascript.enabled', True, 'file://*')
config.set('content.javascript.enabled', True, 'chrome://*/*')
config.set('content.javascript.enabled', True, 'qute://*/*')

# Use nvim-qt (nvim GUI frontend) as default editor.
c.editor.command = [ "gnvim", "{file}", "--", "-c", "normal {line}G{column0}l" ]

# Keybindings

# Unbind delete tab from 'd', bind it to 'D'
config.unbind('d')
config.bind('D', 'tab-close')

# Play a link to a video in mpv instead of the browser.
config.bind(',M', 'hint links spawn mpv {hint-url}')

# Play a video in mpv instead of the browser.
config.bind(',m', 'spawn mpv {url}')

# # Use alt-j,k keys to cycle through command history
# config.bind('<Ctrl-n>', 'completion-item-focus next', mode='command')
# config.bind('<Alt-n>', 'command-history-next', mode='command')
# config.bind('<Alt-Shift-n>', 'completion-item-focus --history prev', mode='command')
# config.bind('<Ctrl-p>', 'completion-item-focus prev', mode='command')
# config.bind('<Alt-p>', 'command-history-prev', mode='command')
# config.bind('<Alt-Shift-p>', 'completion-item-focus --history next', mode='command')

# Add emacs-like keybindings (used in command line) to insert mode.

# Navigation
config.bind('<Ctrl-f>', 'fake-key <Right> ', mode='insert')
config.bind('<Alt-f>', 'fake-key <Control-Right> ', mode='insert')
config.bind('<Ctrl-b>', 'fake-key <Left> ', mode='insert')
config.bind('<Alt-b>', 'fake-key <Control-Left> ', mode='insert')
config.bind('<Ctrl-p>', 'fake-key <Up> ', mode='insert')
config.bind('<Ctrl-n>', 'fake-key <Down> ', mode='insert')
config.bind('<Ctrl-a>', 'fake-key <Home> ', mode='insert')
config.bind('<Ctrl-e>', 'fake-key <End> ', mode='insert')

# Deletion
config.bind('<Ctrl-d>', 'fake-key <Delete> ', mode='insert')
config.bind('<Alt-d>', 'fake-key <Control-Delete> ', mode='insert')
config.bind('<Ctrl-w>', 'fake-key <Control-Backspace> ', mode='insert')
config.bind('<Ctrl-u>', 'fake-key <Shift-Home> ;; fake-key <Delete>', mode='insert')
config.bind('<Ctrl-k>', 'fake-key <Shift-End> ;; fake-key <Delete>', mode='insert')

# Open in an editor
config.bind('<Alt-e>', 'edit-text', mode='insert')
config.bind('<Ctrl-x><Ctrl-e>', 'edit-text', mode='insert')

# Set search engines to use.
# Use ';' to distingish between DDG hashbang searches and my own custom searches.
c.url.searchengines = {
    # Default
    "DEFAULT": "https://duckduckgo.com/?q={}&ia=web",
    # General search engines
    ";d":     "https://duckduckgo.com/?q={}&ia=web",
    ";g":     "https://www.google.com/search?q={}",
    ";b":     "https://www.bing.com/search?q={}",
    ";s":     "https://www.startpage.com/sp/{}",
    ";yh":    "https://ca.search.yahoo.com/search?p={}",
    ";q":     "https://www.qwant.com/?q={}",
    # Wikipedia sites
    ";w":     "https://en.wikipedia.org/w/index.php?search={}",
    ";wfr":   "https://fr.wikipedia.org/w/index.php?search={}",
    ";wde":   "https://de.wikipedia.org/w/index.php?search={}",
    ";wes":   "https://es.wikipedia.org/w/index.php?search={}",
    # Search map sites
    ";gm":    "https://www.google.com/maps/search/{}",
    ";osm":   "https://www.openstreetmap.org/search?query={}",
    # Multimedia
    ";y":    "https://www.youtube.com/results?search_query={}",
    ";od":   "https://odysee.com/$/search?q={}",
    # Social media
    ";t":    "https://twitter.com/search?q={}",
    ";rdt":   "https://www.reddit.com/search?q={}",
    ";lbt":   "https://www.librarything.com/search.php?search={}",
    # Stores
    ";a":     "https://www.amazon.com/s?ie=UTF8&field-keywords={}",
    ";ac":    "https://www.amazon.ca/gp/search?ie=UTF8&keywords={}",
    ";eb":    "https://www.ebay.com/sch/{}",
    ";ebc":   "https://www.ebay.ca/sch/{}",
    ";kb":    "https://www.kobo.com/ca/en/search?query={}",
    ";stm":   "https://store.steampowered.com/search/?term={}",
    # Package repositories
    ";rpl":   "https://repology.org/metapackages/?search={}",
    ";npk":   "https://search.nixos.org/packages?channel=20.09&from=0&size=50&sort=relevance&query={}",
    ";nos":   "https://search.nixos.org/options?channel=20.09&from=0&size=50&sort=relevance&query={}",
    ";fbp":   "https://www.freebsd.org/cgi/ports.cgi?query={}&stype=all",
    ";obp":   "https://openports.se/search.php?so={}",
    # Man pages
    ";ubm":   "https://manpages.ubuntu.com/cgi-bin/search.py?q={}",
    ";fbm":   "https://www.freebsd.org/cgi/man.cgi?query={}",
    ";ahm":   "https://jlk.fjfi.cvut.cz/arch/manpages/search?q={}",
    ";obm":   "https://man.openbsd.org/{}",
    ";vdm":   "https://man.voidlinux.org/{}",
    # Git repositories
    ";gh":    "https://github.com/search?q={}",
    ";gl":    "https://gitlab.com/search?q={}",
    # Misc
    ";aw":    "https://wiki.archlinux.org/index.php?title=Special:Search&search={}",
    ";bgg":   "https://boardgamegeek.com/geeksearch.php?action=search&objecttype=boardgame&q={}",
}

# Copied from the base16-seti-page
# base16-qutebrowser (https://github.com/theova/base16-qutebrowser)
# Base16 qutebrowser template by theova
# Helios scheme by Alex Meyer (https://github.com/reyemxela)

base00 = "#1d2021"
base01 = "#383c3e"
base02 = "#53585b"
base03 = "#6f7579"
base04 = "#cdcdcd"
base05 = "#d5d5d5"
base06 = "#dddddd"
base07 = "#e5e5e5"
base08 = "#d72638"
base09 = "#eb8413"
base0A = "#f19d1a"
base0B = "#88b92d"
base0C = "#1ba595"
base0D = "#1e8bac"
base0E = "#be4264"
base0F = "#c85e0d"

# set qutebrowser colors

# Text color of the completion widget. May be a single color to use for
# all columns or a list of three colors, one for each column.
c.colors.completion.fg = base05

# Background color of the completion widget for odd rows.
c.colors.completion.odd.bg = base01

# Background color of the completion widget for even rows.
c.colors.completion.even.bg = base00

# Foreground color of completion widget category headers.
c.colors.completion.category.fg = base0A

# Background color of the completion widget category headers.
c.colors.completion.category.bg = base00

# Top border color of the completion widget category headers.
c.colors.completion.category.border.top = base00

# Bottom border color of the completion widget category headers.
c.colors.completion.category.border.bottom = base00

# Foreground color of the selected completion item.
c.colors.completion.item.selected.fg = base05

# Background color of the selected completion item.
c.colors.completion.item.selected.bg = base02

# Top border color of the selected completion item.
c.colors.completion.item.selected.border.top = base02

# Bottom border color of the selected completion item.
c.colors.completion.item.selected.border.bottom = base02

# Foreground color of the matched text in the selected completion item.
c.colors.completion.item.selected.match.fg = base0B

# Foreground color of the matched text in the completion.
c.colors.completion.match.fg = base0B

# Color of the scrollbar handle in the completion view.
c.colors.completion.scrollbar.fg = base05

# Color of the scrollbar in the completion view.
c.colors.completion.scrollbar.bg = base00

# Background color of disabled items in the context menu.
c.colors.contextmenu.disabled.bg = base01

# Foreground color of disabled items in the context menu.
c.colors.contextmenu.disabled.fg = base04

# Background color of the context menu. If set to null, the Qt default is used.
c.colors.contextmenu.menu.bg = base00

# Foreground color of the context menu. If set to null, the Qt default is used.
c.colors.contextmenu.menu.fg =  base05

# Background color of the context menu’s selected item. If set to null, the Qt default is used.
c.colors.contextmenu.selected.bg = base02

#Foreground color of the context menu’s selected item. If set to null, the Qt default is used.
c.colors.contextmenu.selected.fg = base05

# Background color for the download bar.
c.colors.downloads.bar.bg = base00

# Color gradient start for download text.
c.colors.downloads.start.fg = base00

# Color gradient start for download backgrounds.
c.colors.downloads.start.bg = base0D

# Color gradient end for download text.
c.colors.downloads.stop.fg = base00

# Color gradient stop for download backgrounds.
c.colors.downloads.stop.bg = base0C

# Foreground color for downloads with errors.
c.colors.downloads.error.fg = base08

# Font color for hints.
c.colors.hints.fg = base00

# Background color for hints. Note that you can use a `rgba(...)` value
# for transparency.
c.colors.hints.bg = base0A

# Font color for the matched part of hints.
c.colors.hints.match.fg = base05

# Text color for the keyhint widget.
c.colors.keyhint.fg = base05

# Highlight color for keys to complete the current keychain.
c.colors.keyhint.suffix.fg = base05

# Background color of the keyhint widget.
c.colors.keyhint.bg = base00

# Foreground color of an error message.
c.colors.messages.error.fg = base00

# Background color of an error message.
c.colors.messages.error.bg = base08

# Border color of an error message.
c.colors.messages.error.border = base08

# Foreground color of a warning message.
c.colors.messages.warning.fg = base00

# Background color of a warning message.
c.colors.messages.warning.bg = base0E

# Border color of a warning message.
c.colors.messages.warning.border = base0E

# Foreground color of an info message.
c.colors.messages.info.fg = base05

# Background color of an info message.
c.colors.messages.info.bg = base00

# Border color of an info message.
c.colors.messages.info.border = base00

# Foreground color for prompts.
c.colors.prompts.fg = base05

# Border used around UI elements in prompts.
c.colors.prompts.border = base00

# Background color for prompts.
c.colors.prompts.bg = base00

# Background color for the selected item in filename prompts.
c.colors.prompts.selected.bg = base02

# Foreground color for the selected item in filename prompts.
c.colors.prompts.selected.fg = base05

# Foreground color of the statusbar.
c.colors.statusbar.normal.fg = base0B

# Background color of the statusbar.
c.colors.statusbar.normal.bg = base00

# Foreground color of the statusbar in insert mode.
c.colors.statusbar.insert.fg = base00

# Background color of the statusbar in insert mode.
c.colors.statusbar.insert.bg = base0D

# Foreground color of the statusbar in passthrough mode.
c.colors.statusbar.passthrough.fg = base00

# Background color of the statusbar in passthrough mode.
c.colors.statusbar.passthrough.bg = base0C

# Foreground color of the statusbar in private browsing mode.
c.colors.statusbar.private.fg = base00

# Background color of the statusbar in private browsing mode.
c.colors.statusbar.private.bg = base01

# Foreground color of the statusbar in command mode.
c.colors.statusbar.command.fg = base05

# Background color of the statusbar in command mode.
c.colors.statusbar.command.bg = base00

# Foreground color of the statusbar in private browsing + command mode.
c.colors.statusbar.command.private.fg = base05

# Background color of the statusbar in private browsing + command mode.
c.colors.statusbar.command.private.bg = base00

# Foreground color of the statusbar in caret mode.
c.colors.statusbar.caret.fg = base00

# Background color of the statusbar in caret mode.
c.colors.statusbar.caret.bg = base0E

# Foreground color of the statusbar in caret mode with a selection.
c.colors.statusbar.caret.selection.fg = base00

# Background color of the statusbar in caret mode with a selection.
c.colors.statusbar.caret.selection.bg = base0D

# Background color of the progress bar.
c.colors.statusbar.progress.bg = base0D

# Default foreground color of the URL in the statusbar.
c.colors.statusbar.url.fg = base05

# Foreground color of the URL in the statusbar on error.
c.colors.statusbar.url.error.fg = base08

# Foreground color of the URL in the statusbar for hovered links.
c.colors.statusbar.url.hover.fg = base05

# Foreground color of the URL in the statusbar on successful load
# (http).
c.colors.statusbar.url.success.http.fg = base0C

# Foreground color of the URL in the statusbar on successful load
# (https).
c.colors.statusbar.url.success.https.fg = base0B

# Foreground color of the URL in the statusbar when there's a warning.
c.colors.statusbar.url.warn.fg = base0E

# Background color of the tab bar.
c.colors.tabs.bar.bg = base00

# Color gradient start for the tab indicator.
c.colors.tabs.indicator.start = base0D

# Color gradient end for the tab indicator.
c.colors.tabs.indicator.stop = base0C

# Color for the tab indicator on errors.
c.colors.tabs.indicator.error = base08

# Foreground color of unselected odd tabs.
c.colors.tabs.odd.fg = base05

# Background color of unselected odd tabs.
c.colors.tabs.odd.bg = base01

# Foreground color of unselected even tabs.
c.colors.tabs.even.fg = base05

# Background color of unselected even tabs.
c.colors.tabs.even.bg = base00

# Background color of pinned unselected even tabs.
c.colors.tabs.pinned.even.bg = base0C

# Foreground color of pinned unselected even tabs.
c.colors.tabs.pinned.even.fg = base07

# Background color of pinned unselected odd tabs.
c.colors.tabs.pinned.odd.bg = base0B

# Foreground color of pinned unselected odd tabs.
c.colors.tabs.pinned.odd.fg = base07

# Background color of pinned selected even tabs.
c.colors.tabs.pinned.selected.even.bg = base02

# Foreground color of pinned selected even tabs.
c.colors.tabs.pinned.selected.even.fg = base05

# Background color of pinned selected odd tabs.
c.colors.tabs.pinned.selected.odd.bg = base02

# Foreground color of pinned selected odd tabs.
c.colors.tabs.pinned.selected.odd.fg = base05

# Foreground color of selected odd tabs.
c.colors.tabs.selected.odd.fg = base05

# Background color of selected odd tabs.
c.colors.tabs.selected.odd.bg = base02

# Foreground color of selected even tabs.
c.colors.tabs.selected.even.fg = base05

# Background color of selected even tabs.
c.colors.tabs.selected.even.bg = base02

# Background color for webpages if unset (or empty to use the theme's
# color).
# c.colors.webpage.bg = base00
