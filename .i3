# i3 config file (v4)
#
# Please see http://i3wm.org/docs/userguide.html for a complete reference!

set $mod Mod4

# Colors
set $color_primary #009688
set $color_primary_light #B2DFDB
set $color_primary_lighter #F7FBFB
set $color_primary_dark #00796B
set $color_dark #212121
set $color_accent #CDDC39

# Font for window titles. Will also be used by the bar unless a different font
# is used in the bar {} block below.
font pango:Source Code Pro 8

# This font is widely installed, provides lots of unicode glyphs, right-to-left
# text rendering and scalability on retina/hidpi displays (thanks to pango).
#font pango:DejaVu Sans Mono 8

# Before i3 v4.8, we used to recommend this one as the default:
# font -misc-fixed-medium-r-normal--13-120-75-75-C-70-iso10646-1
# The font above is very space-efficient, that is, it looks good, sharp and
# clear in small sizes. However, its unicode glyph coverage is limited, the old
# X core fonts rendering does not support right-to-left and this being a bitmap
# font, it doesn’t scale on retina/hidpi displays.

# Use Mouse+$mod to drag floating windows to their wanted position
floating_modifier $mod

# start a terminal
bindsym $mod+Return exec --no-startup-id xterm

# kill focused window
bindsym $mod+Shift+q kill

# start dmenu (a program launcher)
# bindsym $mod+d exec dmenu_run
# There also is the (new) i3-dmenu-desktop which only displays applications
# shipping a .desktop file. It is a wrapper around dmenu, so you need that
# installed.
bindsym $mod+d exec --no-startup-id i3-dmenu-desktop

# change focus
bindsym $mod+j focus left
bindsym $mod+k focus down
bindsym $mod+l focus up
bindsym $mod+odiaeresis focus right

# alternatively, you can use the cursor keys:
bindsym $mod+Left focus left
bindsym $mod+Down focus down
bindsym $mod+Up focus up
bindsym $mod+Right focus right

# move focused window
bindsym $mod+Shift+j move left
bindsym $mod+Shift+k move down
bindsym $mod+Shift+l move up
bindsym $mod+Shift+odiaeresis move right

# alternatively, you can use the cursor keys:
bindsym $mod+Shift+Left move left
bindsym $mod+Shift+Down move down
bindsym $mod+Shift+Up move up
bindsym $mod+Shift+Right move right

# split in horizontal orientation
bindsym $mod+h split h

# split in vertical orientation
bindsym $mod+v split v

# enter fullscreen mode for the focused container
bindsym $mod+f fullscreen toggle

# change container layout (stacked, tabbed, toggle split)
bindsym $mod+s layout stacking
bindsym $mod+w layout tabbed
bindsym $mod+e layout toggle split

# toggle tiling / floating
bindsym $mod+Shift+space floating toggle

# change focus between tiling / floating windows
bindsym $mod+space focus mode_toggle

# focus the parent container
bindsym $mod+a focus parent

# focus the child container
#bindsym $mod+d focus child

# switch to workspace
bindsym $mod+1 workspace 1
bindsym $mod+2 workspace 2
bindsym $mod+3 workspace 3
bindsym $mod+4 workspace 4
bindsym $mod+5 workspace 5
bindsym $mod+6 workspace 6
bindsym $mod+7 workspace 7
bindsym $mod+8 workspace 8
bindsym $mod+9 workspace 9
bindsym $mod+0 workspace 10

# move focused container to workspace
bindsym $mod+Shift+1 move container to workspace 1
bindsym $mod+Shift+2 move container to workspace 2
bindsym $mod+Shift+3 move container to workspace 3
bindsym $mod+Shift+4 move container to workspace 4
bindsym $mod+Shift+5 move container to workspace 5
bindsym $mod+Shift+6 move container to workspace 6
bindsym $mod+Shift+7 move container to workspace 7
bindsym $mod+Shift+8 move container to workspace 8
bindsym $mod+Shift+9 move container to workspace 9
bindsym $mod+Shift+0 move container to workspace 10

# reload the configuration file
bindsym $mod+Shift+c reload
# restart i3 inplace (preserves your layout/session, can be used to upgrade i3)
bindsym $mod+Shift+r restart
# exit i3 (logs you out of your X session)
bindsym $mod+Shift+e exec "i3-nagbar -t warning -m 'End X session?' -b 'Yes' 'i3-msg exit'"

# resize window (you can also use the mouse for that)
mode "resize" {
	# These bindings trigger as soon as you enter the resize mode

	# Pressing left will shrink the window’s width.
	# Pressing right will grow the window’s width.
	# Pressing up will shrink the window’s height.
	# Pressing down will grow the window’s height.
	bindsym j resize shrink width 10 px or 10 ppt
	bindsym k resize grow height 10 px or 10 ppt
	bindsym l resize shrink height 10 px or 10 ppt
	bindsym odiaeresis resize grow width 10 px or 10 ppt

	# same bindings, but for the arrow keys
	bindsym Left resize shrink width 10 px or 10 ppt
	bindsym Down resize grow height 10 px or 10 ppt
	bindsym Up resize shrink height 10 px or 10 ppt
	bindsym Right resize grow width 10 px or 10 ppt

	# back to normal: Enter or Escape
	bindsym Return mode "default"
	bindsym Escape mode "default"
}

bindsym $mod+r mode "resize"

# Start i3bar to display a workspace bar (plus the system information i3status
# finds out, if available)
bar {
	status_command i3status | i3status_extensions
	tray_output primary
	colors {
		background $color_dark
		statusline $color_primary_light
		separator $color_primary_light

		focused_workspace $color_primary_dark $color_primary $color_primary_lighter
		urgent_workspace $color_primary_dark $color_accent $color_dark
	}
}

################################################################################
# CUSTOM                                                                       #
################################################################################
set $refresh_i3status pkill -USR1 -x i3status
set $vlc_sock $HOME/.vlc.sock

# Compton Compositor
exec --no-startup-id compton -b --backend glx --vsync opengl --no-fading-openclose

# Quickstart
bindsym $mod+F1 exec google-chrome-stable
bindsym $mod+F2 exec --no-startup-id xterm mc
bindsym $mod+F3 exec --no-startup-id vlc -LZI rc --rc-fake-tty --rc-unix=$vlc_sock ~/music
bindsym $mod+F10 exec lxtask
bindsym $mod+F11 exec --no-startup-id maim -us ~/pics/screenshot$(date +%s).png
bindsym $mod+F12 exec pavucontrol

# i3lock
bindsym $mod+Escape exec i3lock --color=$color_dark

# Pulse Audio controls
set $audio_device $(pacmd list-sinks | grep -oPm1 "index: \K(\d)")
bindsym XF86AudioRaiseVolume exec --no-startup-id pactl set-sink-volume $audio_device +2% &
bindsym XF86AudioLowerVolume exec --no-startup-id pactl set-sink-volume $audio_device -2% &
bindsym XF86AudioMute exec --no-startup-id pactl set-sink-mute $audio_device toggle &

# VLC controls
mode "vlc" {
	bindsym k exec --no-startup-id nc -NU $vlc_sock <<< "pause"
	bindsym j exec --no-startup-id nc -NU $vlc_sock <<< "prev"
	bindsym l exec --no-startup-id nc -NU $vlc_sock <<< "next"
	bindsym q exec --no-startup-id nc -NU $vlc_sock <<< "quit"

	bindsym Return mode "default"
	bindsym Escape mode "default"
}

bindsym $mod+Menu mode "vlc"

# Sreen brightness controls
bindsym XF86MonBrightnessUp exec --no-startup-id sudo backlight_control +5 && $refresh_i3status &
bindsym XF86MonBrightnessDown exec --no-startup-id sudo backlight_control -5 && $refresh_i3status &

# Move workspace to another monitor
bindsym $mod+m move workspace to output left

# Floating mode
for_window [class="Tk" instance="tk"] floating enable
for_window [class="Google-chrome" instance="google-chrome" window_role="pop-up"] floating enable
for_window [class="Steam" instance="Steam" title=".* - Chat"] floating enable

# Disable window borders
new_window normal 0

# Colorscheme
client.focused          $color_primary $color_primary $color_primary_lighter
client.focused_inactive $color_primary_dark $color_primary_dark $color_primary_light
client.unfocused        $color_dark $color_dark $color_primary_light
client.urgent           $color_accent $color_accent $color_dark
client.placeholder      $color_primary_dark $color_primary_dark $color_primary_light
client.background       $color_dark
