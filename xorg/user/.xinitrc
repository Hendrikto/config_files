XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-~/.config}"
display_setup="${XDG_CONFIG_HOME}/hendrik/display_setup.sh"

[[ -f ~/.Xresources ]] && xrdb -merge -I"${HOME}" ~/.Xresources &
[[ -x ${display_setup} ]] && ${display_setup}
[[ -x ~/.fehbg ]] && ~/.fehbg &
setxkbmap de
xset -dpms
xset s 0 0
picom -b
exec i3
