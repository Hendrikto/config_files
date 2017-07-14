all: gitconfig xconfig

gitconfig: .gitconfig
	ln -rs .gitconfig ~/.gitconfig

remove_gitconfig:
	rm -f ~/.gitconfig

xconfig: .xinitrc
	ln -rs .xinitrc ~/.xinitrc

remove_xconfig:
	rm -f ~/.xinitrc

remove_all: remove_gitconfig remove_xconfig
