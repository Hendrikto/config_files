all: bash git xorg zsh

remove_all: remove_bash remove_git remove_xorg remove_zsh

bash: .bashrc
	ln -rs .bashrc ~/.bashrc

remove_bash:
	rm -f ~/.bashrc

git: .gitconfig
	ln -rs .gitconfig ~/.gitconfig

remove_git:
	rm -f ~/.gitconfig

xorg: .xinitrc .Xresources .Xresources.d
	ln -rs .xinitrc ~/.xinitrc
	ln -rs .Xresources ~/.Xresources
	ln -rs .Xresources.d ~/.Xresources.d

remove_xorg:
	rm -f ~/.xinitrc ~/.Xresources
	rm -rf ~/.Xresources.d

zsh: .zshrc .zprofile
	ln -rs .zprofile ~/.zprofile
	ln -rs .zshrc ~/.zshrc

remove_zsh:
	rm -f ~/.zprofile ~/.zshrc
