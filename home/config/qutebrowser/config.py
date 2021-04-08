# Manual configuration for qutebrowser.

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

# Set Dark Mode
# config.set("colors.webpage.darkmode.enabled", True)

# Enable JavaScript.
# Type: Bool
config.set('content.javascript.enabled', True, 'file://*')
config.set('content.javascript.enabled', True, 'chrome://*/*')
config.set('content.javascript.enabled', True, 'qute://*/*')

# Use gnvim (nvim GUI frontend) as default editor.
c.editor.command = [ "gnvim", "{file}", "--", "-c", "normal {line}G{column0}" ]

# Keybindings

# Unbind delete tab from 'd', bind it to 'D'
config.unbind('d')
config.bind('D', 'tab-close')

# Play a link to a video in mpv instead of the browser.
config.bind(',M', 'hint links spawn mpv {hint-url}')

# Play a video in mpv instead of the browser.
config.bind(',m', 'spawn mpv {url}')

# Use alt-j,k keys to cycle through command history
config.bind('<Alt-j>', 'completion-item-focus next', mode='command')
config.bind('<Alt-n>', 'completion-item-focus next', mode='command')
config.bind('<Alt-k>', 'completion-item-focus prev', mode='command')
config.bind('<Alt-p>', 'completion-item-focus prev', mode='command')

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
config.bind('<Alt-e>', 'open-editor', mode='insert')
config.bind('<Ctrl-x><Ctrl-e>', 'open-editor', mode='insert')

# Set search engines to use.
# Use ';' to distingish between DDG hashbang searches and my own custom searches.
c.url.searchengines = {
    # Default
    "DEFAULT": "https://duckduckgo.com/?q={}&ia=web",
    # General search engines
    ";d":     "https://duckduckgo.com/?q={}&ia=web",
    ";g":     "https://www.google.com/search?q={}",
    ";b":     "https://www.bing.com/search?q={}",
    ";yc":    "https://ca.search.yahoo.com/search?p={}",
    ";qw":    "https://www.qwant.com/?q={}",
    # Wikipedia sites
    ";w":     "https://en.wikipedia.org/w/index.php?search={}",
    ";wfr":   "https://fr.wikipedia.org/w/index.php?search={}",
    ";wde":   "https://de.wikipedia.org/w/index.php?search={}",
    ";wes":   "https://es.wikipedia.org/w/index.php?search={}",
    # Search map sites
    ";gm":    "https://www.google.com/maps/search/{}",
    ";osm":   "https://www.openstreetmap.org/search?query={}",
    # Multimedia
    ";yt":    "https://www.youtube.com/results?search_query={}",
    # Social media
    ";tw":    "https://twitter.com/search?q={}",
    ";rdt":   "https://www.reddit.com/search?q={}",
    ";lbt":   "https://www.librarything.com/search.php?search={}",
    # Stores
    ";a":     "https://www.amazon.com/s?ie=UTF8&field-keywords={}",
    ";ac":    "https://www.amazon.ca/gp/search?ie=UTF8&keywords={}",
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
# https://github.com/theova/base16-qutebrowser/blob/main/themes/default/base16-seti.config.py
# base16-qutebrowser (https://github.com/theova/base16-qutebrowser)
# Base16 qutebrowser template by theova
# Seti UI scheme by Unknown.

base00 = "#151718"
base01 = "#282a2b"
base02 = "#3B758C"
base03 = "#41535B"
base04 = "#43a5d5"
base05 = "#d6d6d6"
base06 = "#eeeeee"
base07 = "#ffffff"
base08 = "#Cd3f45"
base09 = "#db7b55"
base0A = "#e6cd69"
base0B = "#9fca56"
base0C = "#55dbbe"
base0D = "#55b5db"
base0E = "#a074c4"
base0F = "#8a553f"

# set qutebrowser colors

# Text color of the completion widget. May be a single color to use for
# all columns or a list of three colors, one for each column.
c.colors.completion.fg = base05

# Background color of the completion widget for odd rows.
c.colors.completion.odd.bg = base03

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
c.colors.completion.item.selected.fg = base01

# Background color of the selected completion item.
c.colors.completion.item.selected.bg = base0A

# Top border color of the completion widget category headers.
c.colors.completion.item.selected.border.top = base0A

# Bottom border color of the selected completion item.
c.colors.completion.item.selected.border.bottom = base0A

# Foreground color of the matched text in the completion.
c.colors.completion.match.fg = base0B

# Color of the scrollbar handle in the completion view.
c.colors.completion.scrollbar.fg = base05

# Color of the scrollbar in the completion view.
c.colors.completion.scrollbar.bg = base00

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
c.colors.prompts.selected.bg = base0A

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
c.colors.statusbar.private.bg = base03

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
c.colors.tabs.odd.bg = base03

# Foreground color of unselected even tabs.
c.colors.tabs.even.fg = base05

# Background color of unselected even tabs.
c.colors.tabs.even.bg = base00

# Foreground color of selected odd tabs.
c.colors.tabs.selected.odd.fg = base00

# Background color of selected odd tabs.
c.colors.tabs.selected.odd.bg = base05

# Foreground color of selected even tabs.
c.colors.tabs.selected.even.fg = base00

# Background color of selected even tabs.
c.colors.tabs.selected.even.bg = base05

# Background color for webpages if unset (or empty to use the theme's
# color).
# c.colors.webpage.bg = base00
