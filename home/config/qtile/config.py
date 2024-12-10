# Copyright (c) 2010 Aldo Cortesi
# Copyright (c) 2010, 2014 dequis
# Copyright (c) 2012 Randall Ma
# Copyright (c) 2012-2014 Tycho Andersen
# Copyright (c) 2012 Craig Barnes
# Copyright (c) 2013 horsik
# Copyright (c) 2013 Tao Sauvage
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

import os
import subprocess

import xdg

from libqtile import bar, layout, widget, hook
from libqtile.config import Click, Drag, Group, Key, Match, Screen
from libqtile.lazy import lazy
from libqtile.utils import guess_terminal
from libqtile.backend.wayland import InputConfig

# Modifier shortcuts

spk = "mod4"
ck = "control"
ak = "mod1"
shk = "shift"

# Themes

FOCUSED_ACTIVE = 'E29E38'
FOCUSED_INACTIVE = '655131'
UNFOCUSED = '7F858F'

ACTIVE_BORDER = '1890F0'

mod = "mod4"
launcher = "fuzzel"
terminal = "alacritty"

@hook.subscribe.startup_once
def autoexec():
    script = os.path.expanduser("~/.config/qtile/autoexec.sh")
    subprocess.run([script])

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

# When using the Wayland backend, this can be used to configure input devices.
wl_input_rules = {
    "type:keyboard": InputConfig(kb_options="ctrl:nocaps, shift:both_capslock")
}

keys = [
    # A list of available commands that can be bound to keys can be found
    # at https://docs.qtile.org/en/latest/manual/config/lazy.html
    # Switch between windows
    Key([spk], "h", lazy.layout.left(), desc="Move focus to left"),
    Key([spk], "l", lazy.layout.right(), desc="Move focus to right"),
    Key([spk], "j", lazy.layout.down(), desc="Move focus down"),
    Key([spk], "k", lazy.layout.up(), desc="Move focus up"),
    Key([spk], "space", lazy.layout.next(), desc="Move window focus to other window"),
    # Move windows between left/right columns or move up/down in current stack.
    # Moving out of range in Columns layout will create new column.
    Key([spk, shk], "h", lazy.layout.shuffle_left(), desc="Move window to the left"),
    Key([spk, shk], "l", lazy.layout.shuffle_right(), desc="Move window to the right"),
    Key([spk, shk], "j", lazy.layout.shuffle_down(), desc="Move window down"),
    Key([spk, shk], "k", lazy.layout.shuffle_up(), desc="Move window up"),
    # Grow windows. If current window is on the edge of screen and direction
    # will be to screen edge - window would shrink.
    Key([spk, ck], "h", lazy.layout.grow_left(), desc="Grow window to the left"),
    Key([spk, ck], "l", lazy.layout.grow_right(), desc="Grow window to the right"),
    Key([spk, ck], "j", lazy.layout.grow_down(), desc="Grow window down"),
    Key([spk, ck], "k", lazy.layout.grow_up(), desc="Grow window up"),
    Key([spk], "n", lazy.layout.normalize(), desc="Reset all window sizes"),
    Key([spk, ak], "j", switch_to_next_screen(), desc="Automatically move to the next screen"),
    Key([spk, ak], "k", switch_to_prev_screen(), desc="Automatically move to the previous screen"),
    # Toggle between split and unsplit sides of stack.
    # Split = all windows displayed
    # Unsplit = 1 window displayed, like Max layout, but still with
    # multiple stack panes
    Key(
        [mod, "shift"],
        "Return",
        lazy.layout.toggle_split(),
        desc="Toggle between split and unsplit sides of stack",
    ),

    # Audio and volume
    Key([], "XF86AudioRaiseVolume", lazy.spawn("pactl set-sink-volume @DEFAULT_SINK@ +2%")),
    Key([], "XF86AudioLowerVolume", lazy.spawn("pactl set-sink-volume @DEFAULT_SINK@ -2%")),
    Key([], "XF86AudioMute", lazy.spawn("pactl set-sink-mute @DEFAULT_SINK@ toggle")),

    Key([spk], "Return", lazy.spawn(terminal), desc="Launch terminal"),
    # Toggle between different layouts as defined below
    Key([spk], "Tab", lazy.next_layout(), desc="Toggle between layouts"),
    Key([spk], "w", lazy.window.kill(), desc="Kill focused window"),
    Key([spk, ck], "r", lazy.reload_config(), desc="Reload the config"),
    Key([spk, ck], "q", lazy.shutdown(), desc="Shutdown Qtile"),
    Key([spk], "r", lazy.spawncmd(), desc="Spawn a command using a prompt widget"),
    Key([spk], "d", lazy.spawn(launcher), desc="Spawn a command using a launcher program"),
]

groups = [Group(i) for i in "123456789"]

for i in groups:
    keys.extend(
        [
            # mod + group number = switch to group
            Key(
                [mod],
                i.name,
                lazy.group[i.name].toscreen(),
                desc=f"Switch to group {i.name}",
            ),
            # mod + shift + group number = switch to & move focused window to group
            Key(
                [mod, "shift"],
                i.name,
                lazy.window.togroup(i.name, switch_group=True),
                desc=f"Switch to & move focused window to group {i.name}",
            ),
            # Or, use below if you prefer not to switch to that group.
            # # mod + shift + group number = move focused window to group
            # Key([mod, "shift"], i.name, lazy.window.togroup(i.name),
            #     desc="move focused window to group {}".format(i.name)),
        ]
    )

# groups = [
#     Group('Home', matches=[Match(wm_class=[''])], label=''),
#     Group(
#         'Web',
#         matches=[
#             Match(wm_class=[''])
#         ],
#         label=''
#     ),
#     Group('Shells', label=''),
#     Group('Text', label=''),
#     Group('Pictures',
#           matches=[
#               Match(wm_class=['kolourpaint','Gimp', 'Inkscape'])
#           ],
#           label=''
#     ),
#     Group('Music',
#           matches=[
#               Match(wm_class=['Asunder'])
#           ],
#           label=''
#     ),
#     Group('Video',
#           matches=[
#               Match(wm_class=['mpv'])
#           ],
#           label=''
#     ),
#     Group('Games',
#           matches=[
#               Match(wm_class=[
#                   'Gnome-mines',
#                   'Rftg'
#               ])
#           ],
#           label=''),
#     Group(
#         'VMs',
#         matches=[Match(wm_class=['VirtualBox Machine'])],
#         layouts=[layout.Max()],
#         label=''
#     ),
#     Group('Misc', label='')
# ]

# # add a group number and give it the right number key, with 10 getting 0.
# for i, group in enumerate(groups):
#     group_number_string = str(i + 1)
#     group_number_char = str((i + 1) % 10)

    # keys.extend([
    #     Key([spk], group_number_char, lazy.group[group.name].toscreen()),
    #     Key([spk, shk], group_number_char, lazy.window.togroup(group.name))
    # ])

    # group.label = group_number_string + " " + group.label

layouts = [
    # layout.Columns(border_focus_stack=["#d75f5f", "#8f3d3d"], border_width=4),
    layout.Max(),
    # Try more layouts by unleashing below layouts.
    # layout.Stack(num_stacks=2),
    # layout.Bsp(),
    # layout.Matrix(),
    layout.MonadTall(),
    layout.MonadWide(),
    # layout.RatioTile(),
    # layout.Tile(),
    # layout.TreeTab(),
    # layout.VerticalTile(),
    # layout.Zoomy(),
]

widget_defaults = dict(
    font="Inconsolata",
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
    highlight_method='line',
    this_current_screen_border=FOCUSED_ACTIVE,
    this_screen_border=FOCUSED_INACTIVE,
    other_current_screen_border=FOCUSED_ACTIVE,
    other_screen_border=FOCUSED_INACTIVE,
    inactive='FFFFFF',
    hide_unused=True
)

def status_bars():
    return bar.Bar(
            [
                widget.CurrentLayoutIcon(sale=0.75),
                widget.CurrentScreen(
                    active_text='',
                    inactive_text=''
                ),
                group_list,
                widget.Prompt(
                    prompt = '> ',
                    bell_style = None,
                    ignore_dups_history = True
                    ),
                # widget.TaskList(
                    # theme_mode = "fallback",
                    # theme_path = "/run/current-system/sw/share/icons/hicolor/",
                    # ),
                widget.WindowTabs(

                    ),
                widget.Chord(
                    chords_colors={
                        "launch": ("#ff0000", "#ffffff"),
                        },
                    name_transform=lambda name: name.upper(),
                    ),
                # NB Systray is incompatible with Wayland, consider using StatusNotifier instead
                widget.ThermalZone(),
                widget.Volume(
                    emoji=True
                ),
                widget.Clock(format=" %Y-%m-%d %a %I:%M:%S %p"),
                ],
            24,
            border_width=[2, 0, 2, 0],  # Draw top and bottom borders
            # border_color=["ff00ff", "000000", "ff00ff", "000000"]  # Borders are magenta
            )

screens = [
    Screen(
        top = status_bars(),
    ),
    Screen(
        top = status_bars()
    ),
]

# Drag floating layouts.
mouse = [
    Drag([mod], "Button1", lazy.window.set_position_floating(), start=lazy.window.get_position()),
    Drag([mod], "Button3", lazy.window.set_size_floating(), start=lazy.window.get_size()),
    Click([mod], "Button2", lazy.window.bring_to_front()),
]

dgroups_key_binder = None
dgroups_app_rules = []  # type: list
follow_mouse_focus = True
bring_front_click = False
cursor_warp = False
floating_layout = layout.Floating(
    float_rules=[
        # Run the utility of `xprop` to see the wm class and name of an X client.
        *layout.Floating.default_float_rules,
        Match(wm_class="confirmreset"),  # gitk
        Match(wm_class="makebranch"),  # gitk
        Match(wm_class="maketag"),  # gitk
        Match(wm_class="ssh-askpass"),  # ssh-askpass
        Match(title="branchdialog"),  # gitk
        Match(title="pinentry"),  # GPG key password entry
    ]
)
auto_fullscreen = True
focus_on_window_activation = "smart"
reconfigure_screens = True

# If things like steam games want to auto-minimize themselves when losing
# focus, should we respect this or not?
auto_minimize = True

# XXX: Gasp! We're lying here. In fact, nobody really uses or cares about this
# string besides java UI toolkits; you can see several discussions on the
# mailing lists, GitHub issues, and other WM documentation that suggest setting
# this string if your java app doesn't work correctly. We may as well just lie
# and say that we're a working one by default.
#
# We choose LG3D to maximize irony: it is a 3D non-reparenting WM written in
# java that happens to be on java's whitelist.
wmname = "LG3D"
