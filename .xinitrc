[[ -f ~/.Xresources ]] && xrdb -merge -I$HOME ~/.Xresources &
[[ -f ~/.fehbg ]] && ~/.fehbg &
setxkbmap de
exec i3
