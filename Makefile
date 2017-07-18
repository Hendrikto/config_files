all: bashconfig gitconfig xconfig zshconfig

bashconfig: .bashrc
	ln -rs .bashrc ~/.bashrc

remove_bashconfig:
	rm -f ~/.bashrc

gitconfig: .gitconfig
	ln -rs .gitconfig ~/.gitconfig

remove_gitconfig:
	rm -f ~/.gitconfig

xconfig: .xinitrc .Xresources .Xresources.d
	ln -rs .xinitrc ~/.xinitrc
	ln -rs .Xresources ~/.Xresources
	ln -rs .Xresources.d ~/.Xresources.d

remove_xconfig:
	rm -f ~/.xinitrc ~/.Xresources
	rm -rf ~/.Xresources.d

zshconfig: .zshrc .zprofile
	ln -rs .zprofile ~/.zprofile
	ln -rs .zshrc ~/.zshrc

remove_zshconfig:
	rm -f ~/.zprofile ~/.zshrc

remove_all: remove_bashconfig remove_gitconfig remove_xconfig remove_zshconfig
