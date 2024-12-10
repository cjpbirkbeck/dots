from libqtile.config import Key, Screen, Group, Drag, Click, Match
from libqtile.command import lazy
from libqtile.widget import Mpd2, Notify, Volume
from libqtile import layout, bar, widget, hook

from typing import List  # noqa: F401

import os
import subprocess
import sys

# FUNCTIONS

def switch_to_next_screen():
    """Changes focus to the next screen, warping the mouse with it."""
    @lazy.function
    def __inner(qtile):
        qtile.config.cursor_warp = True
        qtile.cmd_next_screen()
        qtile.config.cursor_warp = False

    return __inner

def switch_to_prev_screen():
    """Changes focus to the previous screen, warping the mouse with it."""
    @lazy.function
    def __inner(qtile):
        qtile.config.cursor_warp = True
        qtile.cmd_prev_screen()
        qtile.config.cursor_warp = False

    return __inner

def window_to_next_group():
    """ Move the window to the next group. """
    @lazy.function
    def __inner(qtile):
        i = qtile.groups.index(qtile.currentGroup)
        next_i = (i + 1) % len(qtile.groups)
        next_n = qtile.groups[next_i].name

        qtile.currentWindow.togroup(next_n)
        qtile.groups[next_i].cmd_toscreen()

    return __inner

def window_to_prev_group():
    """ Move the window to the previous group. """
    @lazy.function
    def __inner(qtile):
        i = qtile.groups.index(qtile.currentGroup)
        next_i = (i - 1) % len(qtile.groups)
        next_n = qtile.groups[next_i].name

        qtile.currentWindow.togroup(next_n)
        qtile.groups[next_i].cmd_toscreen()

    return __inner

def goto_first():
    """ Go to the first window of the current stack. """
    @lazy.function
    def __inner(qtile):
        if qtile.currentLayout.name == "stack":
            first = qtile.currentLayout.currentStack.focus_first()
        else:
            first = qtile.currentLayout.focus_first()

        qtile.currentGroup.focus(first)

    return __inner

def goto_last():
    """ Go to the last window of the current stack. """
    @lazy.function
    def __inner(qtile):
        if qtile.currentLayout.name == "stack":
            last = qtile.currentLayout.currentStack.focus_last()
        else:
            last = qtile.currentLayout.focus_last()

        qtile.currentGroup.focus(last)

    return __inner

def move_to_first():
    """ Move the current window to the front of the stack. """
    @lazy.function
    def __inner(qtile):
        l_name = qtile.currentLayout.name
        if l_name == "stack":
            first = qtile.currentLayout.currentStack.focus_first()
            current = qtile.currentLayout.currentStack.focus()
            qtile.currentLayout.currentStack.cmd_swap(current, first)
        else:
            first = qtile.currentLayout.focus_first()
            current = qtile.currentLayout.clients.current_client
            qtile.currentLayout.cmd_swap(current, first)

    return __inner

def move_to_last():
    """ Move the current window to the back of the stack. """
    @lazy.function
    def __inner(qtile):
        l_name = qtile.currentLayout.name
        if l_name == "stack":
            last = qtile.currentLayout.currentStack.focus_last()
            current = qtile.currentLayout.currentStack.focus()
            qtile.currentLayout.currentStack.cmd_swap(current, last)
        else:
            last = qtile.currentLayout.focus_last()
            current = qtile.currentLayout.clients.current_client
            qtile.currentLayout.cmd_swap(current, last)

    return __inner

def layout_primary_special_action():
    @lazy.function
    def __inner(qtile):
        l_name = qtile.currentLayout.name
        if l_name == "monadwide" or l_name == "monadtall":
            qtile.currentLayout.cmd_flip()
        else:
            qtile.currentLayout.cmd_next()

    return __inner

def layout_secondary_special_action():
    @lazy.function
    def __inner(qtile):
        l_name = qtile.currentLayout.name
        if l_name == "stack":
            qtile.currentLayout.cmd_client_to_next()
        elif l_name == "max":
            qtile.currentLayout.cmd_previous()
        elif l_name == "monadwide" or l_name == "monadtall":
            qtile.currentLayout.cmd_normalize()
            qtile.currentLayout.cmd_reset()

    return __inner

@hook.subscribe.startup_once
def autostart():
    subprocess.call(['/home/cjpbirkbeck/.config/qtile/bin/autoexec.sh'])
    subprocess.call(['/home/cjpbirkbeck/.config/qtile/bin/wp.sh'])
    os.environ['XDG_CURRENT_DESKTOP'] = 'kde'

# VARIABLES

# Modifier shortcuts

spk = "mod4"
ck = "control"
ak = "mod1"
shk = "shift"

# Themes

FOCUSED_ACTIVE = '#E29E38'
FOCUSED_INACTIVE = '#655131'
UNFOCUSED = '#7F858F'

ACTIVE_BORDER = '#1890F0'

# Widgets

widget_defaults = dict(
    font='Inconsolata',
    fontsize=18,
    padding=1,
    background='#7F858F',
    forground='#FFFFFF'
)
extension_defaults = widget_defaults.copy()

group_list = widget.GroupBox(
    disable_drag=True,
    fontsize=16,
    spacing=3,
    highlight_method='border',
    this_current_screen_border=FOCUSED_ACTIVE,
    this_screen_border=FOCUSED_INACTIVE,
    other_current_screen_border=FOCUSED_ACTIVE,
    other_screen_border=FOCUSED_INACTIVE,
    inactive='FFFFFF',
    hide_unused=True
)

# Miscellaneous variables

dgroups_key_binder = None
dgroups_app_rules = []  # type: List
main = None
follow_mouse_focus = True
bring_front_click = True
cursor_warp = False
floating_layout = layout.Floating(float_rules=[
    {'wmclass': 'confirm'},
    {'wmclass': 'dialog'},
    {'wmclass': 'download'},
    {'wmclass': 'error'},
    {'wmclass': 'file_progress'},
    {'wmclass': 'notification'},
    {'wmclass': 'splash'},
    {'wmclass': 'toolbar'},
    {'wmclass': 'confirmreset'},  # gitk
    {'wmclass': 'makebranch'},  # gitk
    {'wmclass': 'maketag'},  # gitk
    {'wname': 'branchdialog'},  # gitk
    {'wmclass': 'pinentry'},  # GPG key password entry
    {'wmclass': 'ssh-askpass'},  # ssh-askpass
    {'wmclass': 'asunder'}
])
auto_fullscreen = True
focus_on_window_activation = "focus"

# KEYBINDINGS

keys = [
    # General control keys
    Key([spk], "F5", lazy.restart()),
    Key([spk, shk], "F4", lazy.shutdown()),
    Key([spk], "Escape", lazy.spawncmd()),

    # Spawn applications
    Key([spk], "Return", lazy.spawn("rofi -show combi window run drun")),
    Key([spk, shk], "Return", lazy.spawn("termite")),

    # Screen control commands
    Key([spk], "backslash", switch_to_next_screen()),
    Key([spk, shk], "backslash", switch_to_prev_screen()),

    # Group control commands
    Key([spk], "bracketleft", lazy.screen.prev_group()),
    Key([spk], "bracketright", lazy.screen.next_group()),

    Key([spk, shk], "bracketright", window_to_next_group()),
    Key([spk, shk], "bracketleft", window_to_prev_group()),

    Key([spk], "grave", lazy.next_layout()),
    Key([spk, shk], "grave", lazy.prev_layout()),

    # Change the window focus
    Key([spk], "j", lazy.layout.down()),
    Key([spk], "k", lazy.layout.up()),

    Key([spk], "h", goto_first()),
    Key([spk], "l", goto_last()),

    Key([spk, shk], "h", move_to_first()),
    Key([spk, shk], "l", move_to_last()),

    Key([spk], "i", lazy.layout.shrink()),
    Key([spk], "o", lazy.layout.grow()),

    Key([spk], "m", lazy.layout.maximize()),
    Key([spk], "n", lazy.layout.normalize()),
    Key([spk], "equal", lazy.layout.reset()),

    # Move current window up and down the window list.
    Key([spk, shk], "j", lazy.layout.shuffle_down()),
    Key([spk, shk], "k", lazy.layout.shuffle_up()),

    # Window layout
    Key([spk], "Tab", layout_primary_special_action()),
    Key([spk, shk], "Tab", layout_secondary_special_action()),

    Key([spk], "semicolon", lazy.layout.rotate()),

    # Toggle float
    Key([spk], "space", lazy.window.toggle_floating()),

    # Kill Windows
    Key([spk], "BackSpace", lazy.window.kill()),

    # Screenshots
    Key([], "Print", lazy.spawn("/home/cjpbirkbeck/Scripts/i3/screenshots/selected-region.sh")),
    Key(["shift"], "Print", lazy.spawn("/home/cjpbirkbeck/Scripts/i3/screenshots/single-window.sh")),
    Key(["control"], "Print", lazy.spawn("/home/cjpbirkbeck/Scripts/i3/screenshots/entire-screen.sh")),

    # Audio and volume
    Key([], "XF86AudioRaiseVolume", lazy.spawn("amixer set Master 2%+")),
    Key([], "XF86AudioLowerVolume", lazy.spawn("amixer set Master 2%-")),
    Key([], "XF86AudioMute", lazy.spawn("amixer set Master toggle")),

    Key([], "XF86AudioPrev", lazy.spawn("mpc prev")),
    Key([], "XF86AudioPlay", lazy.spawn("mpc toggle")),
    Key([], "XF86AudioNext", lazy.spawn("mpc next")),
]

# GROUPS

groups = [
    Group('Home', matches=[Match(wm_class=[''])], label=''),
    Group(
        'Web',
        matches=[
            Match(wm_class=[''])
        ],
        label=''
    ),
    Group('Shells', label=''),
    Group('Text', label=''),
    Group('Pictures',
          matches=[
              Match(wm_class=['kolourpaint','Gimp', 'Inkscape'])
          ],
          label=''
    ),
    Group('Music',
          matches=[
              Match(wm_class=['Asunder'])
          ],
          label=''
    ),
    Group('Video',
          matches=[
              Match(wm_class=['mpv'])
          ],
          label=''
    ),
    Group('Games',
          matches=[
              Match(wm_class=[
                  'Gnome-mines',
                  'Rftg'
              ])
          ],
          label=''),
    Group(
        'VMs',
        matches=[Match(wm_class=['VirtualBox Machine'])],
        layouts=[layout.Max()],
        label=''
    ),
    Group('Misc', label='')
]

# Add a group number and give it the right number key, with 10 getting 0.
for i, group in enumerate(groups):
    group_number_string = str(i + 1)
    group_number_char = str((i + 1) % 10)

    keys.extend([
        Key([spk], group_number_char, lazy.group[group.name].toscreen()),
        Key([spk, shk], group_number_char, lazy.window.togroup(group.name))
    ])

    group.label = group_number_string + " " + group.label

# LAYOUTS

layout_defaults = dict(
    border_focus=FOCUSED_ACTIVE
)

layouts = [
    layout.Max(),
    layout.Stack(
        border_focus=FOCUSED_ACTIVE,
        border_width=2,
        num_stacks=2,
    ),
    layout.MonadWide(
        border_focus=FOCUSED_ACTIVE
    ),
    layout.MonadTall(
        border_focus=FOCUSED_ACTIVE
    ),
    layout.Tile()
]

# SCREENS

screens = [
    Screen(
        top=bar.Bar(
            [
                widget.CurrentLayoutIcon(scale=0.75),
                group_list,
                widget.Prompt(
                    prompt='> ',
                    bell_style=None,
                    ignore_dups_history=True
                ),
                widget.WindowName(),
            ],
            24,
        ),
    ),
    Screen(
        top=bar.Bar(
            [
                widget.CurrentLayoutIcon(scale=0.75),
                widget.CurrentScreen(
                    active_text=' A',
                    inactive_text=' I'
                ),
                widget.WindowName(),
                widget.Systray(),
                widget.Volume(
                    emoji=True
                ),
                widget.Clock(
                    format=' %c'
                ),
            ],
            24,
        ),
    )
]
