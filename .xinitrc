[[ -f ~/.Xresources ]] && xrdb -merge -I$HOME ~/.Xresources &
setxkbmap de
exec i3
