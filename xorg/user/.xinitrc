[[ -f ~/.Xresources ]] && xrdb -merge -I$HOME ~/.Xresources &
[[ -x ~/.fehbg ]] && ~/.fehbg &
xrandr --auto
setxkbmap de
xset -dpms
xset s 0 0
picom -b
exec i3
