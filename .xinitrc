# Merge X resources if they exist
if [ -f ~/.Xresources ]; then
	xrdb -merge -I$HOME ~/.Xresources
fi

setxkbmap de
exec i3
