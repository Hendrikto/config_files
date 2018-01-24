[[ -f ~/.Xresources ]] && xrdb -merge -I$HOME ~/.Xresources &
[[ -f ~/.fehbg ]] && ~/.fehbg &
setxkbmap de
xset dpms 0 0 0
xset s 0 0
exec i3
