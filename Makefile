all: gitconfig xconfig zshconfig

gitconfig: .gitconfig
	ln -rs .gitconfig ~/.gitconfig

remove_gitconfig:
	rm -f ~/.gitconfig

xconfig: .xinitrc
	ln -rs .xinitrc ~/.xinitrc

remove_xconfig:
	rm -f ~/.xinitrc

zshconfig: .zshrc
	ln -rs .zshrc ~/.zshrc

remove_zshconfig:
	rm -f ~/.zshrc

remove_all: remove_gitconfig remove_xconfig remove_zshconfig
