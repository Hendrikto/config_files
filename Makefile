all: bash git i3 xorg zsh

remove_all: remove_bash remove_git remove_i3 remove_xorg remove_zsh

bash: .bashrc
	ln -rs .bashrc ~/.bashrc

remove_bash:
	rm -f ~/.bashrc

git: .gitconfig
	ln -rs .gitconfig ~/.gitconfig

remove_git:
	rm -f ~/.gitconfig

i3: .i3
	ln -rs .i3 ~/.config/i3/config

remove_i3:
	rm -f ~/.config/i3/config

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
