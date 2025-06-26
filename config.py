# Qtile config.py - updated for dual monitor support and better DE-like experience

from libqtile import bar, layout, qtile, widget, hook
from libqtile.config import Click, Drag, Group, Key, Match, Screen
from libqtile.lazy import lazy
from libqtile.utils import guess_terminal
import subprocess
import os
import os.path
import json

with open("{}/.config/qtile/settings.json".format(os.getenv("HOME"))) as file:
    settings = json.load(file)

looks: dict = settings["looks"]
display: dict = settings["display"]

with open("{}/.config/qtile/colors.json".format(os.getenv("HOME"))) as file:
    colors_json = json.load(file)

colors = colors_json
wallpaper = looks["wallpaper"]

mod = "mod4"
#terminal = guess_terminal()
terminal = "alacritty"
path = "/home/quaithejedi"
home = os.path.expanduser(path)

keys = [
    # Navigation
    Key([mod], "h", lazy.layout.left(), desc="Focus left"),
    Key([mod], "l", lazy.layout.right(), desc="Focus right"),
    Key([mod], "j", lazy.layout.down(), desc="Focus down"),
    Key([mod], "k", lazy.layout.up(), desc="Focus up"),
    Key([mod], "space", lazy.layout.next(), desc="Next window"),
    
    # Monitor switch
    Key([mod], "v", lazy.to_screen(0)),
    Key([mod], "c", lazy.to_screen(1)),
    # Toggle between screens
    Key([mod], "period", lazy.next_screen()), 
   
    # Move windows
    Key([mod, "shift"], "h", lazy.layout.shuffle_left(), desc="Move left"),
    Key([mod, "shift"], "l", lazy.layout.shuffle_right(), desc="Move right"),
    Key([mod, "shift"], "j", lazy.layout.shuffle_down(), desc="Move down"),
    Key([mod, "shift"], "k", lazy.layout.shuffle_up(), desc="Move up"),
    
    # Eww
    Key([mod, "shift"], "p", lazy.spawn("eww open powermenu"), desc="Power menu"),
    Key([mod, "shift"], "c", lazy.spawn("eww open calendar"), desc="Calendar"),

    # Resize windows
    Key([mod, "control"], "h", lazy.layout.grow_left(), desc="Grow left"),
    Key([mod, "control"], "l", lazy.layout.grow_right(), desc="Grow right"),
    Key([mod, "control"], "j", lazy.layout.grow_down(), desc="Grow down"),
    Key([mod, "control"], "k", lazy.layout.grow_up(), desc="Grow up"),
    Key([mod], "n", lazy.layout.normalize(), desc="Normalize size"),
    Key([mod], "s", lazy.layout.toggle_split(), desc="Toggle between split and unsplit sides of stack"),

    # Launch terminal
    Key([mod], "Return", lazy.spawn(terminal), desc="Launch terminal"),
    # Layout
    Key([mod], "Tab", lazy.next_layout(), desc="Next layout"),
    Key([mod], "w", lazy.window.kill(), desc="Kill window"),
    Key([mod], "f", lazy.window.toggle_fullscreen(), desc="Fullscreen"),
    Key([mod], "t", lazy.window.toggle_floating(), desc="Toggle floating"),
    # Config
    Key([mod, "control"], "r", lazy.reload_config(), desc="Reload config"),
    Key([mod, "control"], "q", lazy.shutdown(), desc="Shutdown Qtile"),
    Key([mod], "r", lazy.spawncmd(), desc="Run command"),
    # App launcher
    Key([mod], "d", lazy.spawn("rofi -show drun"), desc="Launch Rofi"),
    Key([mod], "b", lazy.spawn("rofi-bluetooth"), desc="Bluetooth manager"),
    Key([mod], "p", lazy.spawn("rofi -show power-menu -modi power-menu:rofi-power-menu"), desc="Power menu"),
    Key([mod, "control"], "f", lazy.spawn("flameshot gui"), desc="Open flameshot gui"),
    Key([mod], "g", lazy.spawn("rofi -show filebrowser"), desc="Rofi File Browser"),
    Key([mod], "e", lazy.spawn("tauon"), desc="Open tauon music box"),
    Key([mod, "control"], "t", lazy.spawn("thunar"), desc="Open Thunar file manager"),
]

# Workspaces

groups = [Group(i) for i in "123456789"]
for i in groups:
    keys.extend([
        Key([mod], i.name, lazy.group[i.name].toscreen(), desc=f"Go to group {i.name}"),
        Key([mod, "shift"], i.name, lazy.window.togroup(i.name, switch_group=True), desc=f"Move window to group {i.name}"),
    ])

#group_names = [
#    ("code", {"layout": "bsp"}),
#    ("wifi", {"layout": "max"}),
#    ("terminal", {"layout": "bsp"}),
#    ("code-branch", {"layout": "bsp"}),
#    ("coffee", {"layout": "bsp"}),
#    ("record-vinyl", {"layout": "monadtall"}),
#]

#groups = [Group(name, **kwargs) for name, kwargs in group_names]

#for i, (name, kwargs) in enumerate(group_names, 1):
#    keys.append(Key([mod], str(i), lazy.group[name].toscreen()))
#    keys.append(Key([mod, "shift"], str(i), lazy.window.togroup(name)))

layout_theme = {
    "border_width": 1,
    "margin": 1,
    #     "border_focus": colors["color1"],
    #     "border_normal": colors["color2"],
    "border_focus": colors["border_focus"],
    "border_normal": colors["border_normal"],
}

layouts = [
    layout.Columns(border_focus_stack=["#d75f5f", "#8f3d3d"], border_width=3),
    layout.Max(),
    layout.MonadTall(border_width=3, margin=8, single_margin=0),
    layout.Floating(),
    layout.Bsp(),
    layout.Zoomy(),
]

#widget_defaults = dict(font="sans", fontsize=12, padding=3)
widget_defaults = dict(font="JetBrainsMono Nerd Font", fontsize=16, padding=3)
extension_defaults = widget_defaults.copy()

#colors = {
#    "background": "#1e1e2e",
#    "foreground": "#cdd6f4",
#    "accent": "#89b4fa",
#    "warning": "#f38ba8",
#    "ok": "#a6e3a1",
#}

power_widgets: list = [
    widget.Sep(
        linewidth=0,
        padding=8,
        background=colors["seperator"],
        foreground=colors["color2fg"],
    ),
    widget.TextBox(
        text="Shutdown",
        background=colors["color2"],
        foreground=colors["color2fg"],
        mouse_callbacks={"Button1": lambda: qtile.cmd_spawn("shutdown now")},
    ),
    widget.TextBox(
        text="|", background=colors["color2"], foreground=colors["color2fg"]
    ),
    widget.TextBox(
        text="Reboot",
        background=colors["color2"],
        foreground=colors["color2fg"],
        mouse_callbacks={"Button1": lambda: qtile.cmd_spawn("reboot")},
    ),
]

widgets_list = lambda: [
    widget.Sep(linewidth=0, padding=6, background=colors["groups_bg"]),
    widget.GroupBox(
        font=looks["caret_font"],
        #borderwidth=3,
        active=colors["accent"],
        inactive=colors["inactive"],
        rounded=False,
        #highlight_method="line",
        highlight_method="block",
        #highlight_color=colors["groups_bg"],
        #this_current_screen_border=colors["current_screen_tab"],
        #this_screen_border=colors["color1"],
        #other_screen_border=colors["bg"],
        #foreground=colors["fg"],
        #background=colors["groups_bg"],
    ),
    widget.Sep(padding=6, linewidth=0, background=colors["seperator"]),
    widget.Prompt(
        foreground=colors["active"],
        background=colors["groups_bg"],
        font="JetBrains Mono Nerd Font",
        #prompt="Woof: "
    ),
    widget.Sep(padding=6, linewidth=0, background=colors["seperator"]),
    widget.Spacer(),
    # Window
    widget.WindowName(),
    widget.Sep(padding=6, linewidth=0, background=colors["seperator"]),
    ### Volume ###
    #widget.Sep(padding=9, linewidth=0, background=colors["color3"]),
    #widget.TextBox(
    #    text="volume-off",
    #    font="JetBrainsMono Nerd Font",
    #    foreground=colors["color3fg"],
    #    background=colors["color3"],
    #    fontsize=14,
    #    padding=0,
    #),
    #widget.Volume(foreground=colors["color3fg"], background=colors["color3"]),
    #widget.Sep(padding=6, linewidth=0, background=colors["color3"]),
    #widget.Sep(padding=6, linewidth=0, background=colors["color1"]),
    #widget.TextBox(
        #foreground=colors["color1fg"],
        #background=colors["color1"],
        #text="calendar-alt",
        #font="JetBrainsMono Nerd Font",
        #        Uncomment the below snippet to enable calendar as a notification if dunst uses monospace font.
        #        mouse_callbacks={
        #            Button1": lambda: os.system(' notify-send "$(cal)" -i ICON ')
        #        },
    #),
    # Systray
    #widget.Systray(),
    #widget.Systray(background=colors["systray"], padding=10),
    #widget.Sep(linewidth=0, padding=6, background=colors["systray"]),
    # Net connections
    #widget.Wlan(foreground=colors["color5fg"], background=colors["color5"]),
    widget.Sep(padding=6, linewidth=0, background=colors["color5"]),
    widget.TextBox(
        foreground=colors["color5fg"],
        background=colors["color5"],
        text="NET",
        font="JetBrainsMono Nerd Font",
        mouse_callbacks={"Button1": lazy.spawn("/run/current-system/sw/bin/nm-applet")},
    ),
    widget.Sep(padding=6, linewidth=0, background=colors["seperator"]),
    # Volume ctrl
    widget.Volume(foreground=colors["color3fg"], background=colors["color3"]),
    widget.Sep(padding=6, linewidth=0, background=colors["color3"]),
    widget.TextBox(
        foreground=colors["color3fg"],
        background=colors["color3"],
        text="VOL",
        font="JetBrainsMono Nerd Font",
        mouse_callbacks={"Button1": lazy.spawn("pavucontrol")},
    ),
    widget.Sep(padding=6, linewidth=0, background=colors["seperator"]),
    # Calendar
    widget.Clock(
        foreground=colors["color1fg"],
        background=colors["color1"],
        format="%D",
        font="JetBrainsMono Nerd Font",
        mouse_callbacks={"Button1": lazy.spawn("gnome-calendar")},
    ),
    widget.Sep(padding=6, linewidth=0, background=colors["color3"]),
    # Clock
    widget.Clock(
            foreground=colors["color5fg"],
            background=colors["color5"],
            format="%A - %H:%M"
    ),
    widget.Sep(padding=6, linewidth=0, background=colors["color1"]),
    # Weather
    widget.OpenWeather(
        location="Pecs,HU",
        format="{main_temp}°C {weather_details}",
        app_key="cd11433ea237ae8c782c612e5eb663f9"
    ),
    # System monitoring
    widget.CPU(format="CPU {load_percent}%", foreground=colors["warning"]),
    widget.Memory(format="RAM {MemUsed: .0f}{mm}", foreground=colors["accent"]),
    ### Systray ###
    #widget.Systray(background=colors["systray"], padding=10),
    #widget.Sep(linewidth=0, padding=6, background=colors["systray"]),
    widget.QuickExit()
]

bar_margin = 0

screen0 = Screen(
        #top=bar.Bar([
        bottom=bar.Bar(
            #widget.GroupBox(highlight_method="block", active=colors["accent"]),
            #widget.Prompt(),
            #widget.WindowName(),
            #widget.Systray(),
            #widget.Clock(
            #    format="%Y-%m-%d %a %H:%M",
            #    mouse_callbacks={"Button1": lazy.spawn("gnome-calendar")},
            #    foreground=colors["ok"]
            #),
            #widget.OpenWeather(
            #    location="Pecs,HU",
            #    format="{main_temp}°C {weather_details}",
            #    app_key="cd11433ea237ae8c782c612e5eb663f9"
            #),
            #widget.CPU(format="CPU {load_percent}%", foreground=colors["warning"]),
            #widget.Memory(format="RAM {MemUsed: .0f}{mm}", foreground=colors["accent"]),
            #widget.DF(partition="/dev/nvme0n1p2", format="Disk {uf}{m} free", foreground=colors["accent"]),
            #widget.DF(partition="/dev/nvme0n1p2", format="Disk {uf}{m} free", visible_on_warn=False),
            #widget.QuickExit()
            widgets_list(),
            int(looks["panel-size"]),
            background=colors["bg"],
            opacity=float(looks["panel-opacity"]),
            margin=bar_margin,
        #background=colors["bg"],
      ),
      #36,
    )

screen1 = Screen(
        #top=bar.Bar([
        bottom=bar.Bar(
            #widget.GroupBox(),
            #widget.WindowName(),
            #widget.Clock(format="%H:%M")
            widgets_list(),
            int(looks["panel-size"]),
            background=colors["bg"],
            opacity=float(looks["panel-opacity"]),
            margin=bar_margin,
       ),
       #40,
    )

screens = [screen0, screen1]

mouse = [
    Drag([mod], "Button1", lazy.window.set_position_floating(), start=lazy.window.get_position()),
    Drag([mod], "Button3", lazy.window.set_size_floating(), start=lazy.window.get_size()),
    Click([mod], "Button2", lazy.window.bring_to_front()),
]

floating_layout = layout.Floating(
    #**layout_theme,
    float_rules=[
    *layout.Floating.default_float_rules,
    Match(wm_type="utility"),
    Match(wm_type="notification"),
    Match(wm_type="dialog"),
    Match(wm_class="confirm"),
    Match(wm_class="dialog"),
    Match(wm_class="download"),
    Match(wm_class="error"),
    Match(wm_class="file_progress"),
    Match(wm_class="notification"),
    Match(wm_class="splash"),
    Match(wm_class="confirmreset"),
    Match(wm_class="makebranch"),
    Match(wm_class="maketag"),
    Match(wm_class="ssh-askpass"),
    Match(title="branchdialog"),
    Match(title="pinentry"),
    Match(wm_class="screenkey"),
    Match(title="screenkey"),
])

auto_fullscreen = True
focus_on_window_activation = "smart"
reconfigure_screens = True
auto_minimize = True

@hook.subscribe.startup_once
def autostart():
    subprocess.Popen(["/home/quaithejedi/.screenlayout/multi-monitor.sh"])
    subprocess.Popen([
        "xwallpaper", "--output", "HDMI-0", "--zoom", "/home/quaithejedi/Pictures/wolf_moon_art.jpg",
        "--output", "eDP-1-1", "--zoom", "/home/quaithejedi/Pictures/164523-wolf-digital-art-art-horse-carnivore-1280x720.jpg"
    ])
    #subprocess.Popen(["eww", "daemon"])
    #subprocess.Popen(["eww", "open-many", "bar"])
    #subprocess.Popen(["/home/quaithejedi/.config/eww/custom_bar/launch_bar.sh"])
    subprocess.Popen(["picom"])
    subprocess.Popen(["nm-applet"])
    subprocess.Popen(["blueman-applet"])
    subprocess.Popen(["gnome-power-manager"])
    subprocess.Popen(["dunst"])
    subprocess.Popen(["inhibridge"])
    #subprocess.Popen(["swaybg", "-i", "/home/quaithejedi/Pictures/wolf_moon_art.jpg", "-m", "fill"])


#wl_input_rules = [
#  {
#    "type": "keyboard",
#    "xkb_layout": "hu",
#    "xkb_variant": "standard"
#  }
#]


wmname = "LG3D"
