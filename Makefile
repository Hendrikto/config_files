all: bash chrome git i3 i3status xorg zsh

remove_all: remove_bash remove_chrome remove_git remove_i3 remove_i3status remove_xorg remove_zsh

bash: .bashrc .bash_profile
	ln -rs $< ~/.bashrc
	ln -rs .bash_profile ~/.bash_profile

remove_bash:
	rm -f ~/.bashrc ~/.bash_profile

chrome: .chrome
	mkdir -p ~/.config
	ln -rs $< ~/.config/chrome-flags.conf

remove_chrome:
	rm -f ~/.config/chrome-flags.conf

git: .gitconfig
	ln -rs $< ~/.gitconfig

remove_git:
	rm -f ~/.gitconfig

i3: .i3
	mkdir -p ~/.config/i3
	ln -rs $< ~/.config/i3/config

remove_i3:
	rm -f ~/.config/i3/config

i3status: .i3status
	mkdir -p ~/.config/i3status
	ln -rs $< ~/.config/i3status/config

remove_i3status:
	rm -f ~/.config/i3status/config

xorg: .xinitrc .Xresources .Xresources.d
	ln -rs $< ~/.xinitrc
	ln -rs .xserverrc ~/.xserverrc
	ln -rs .Xresources ~/.Xresources
	ln -rs .Xresources.d ~/.Xresources.d

remove_xorg:
	rm -f ~/.xinitrc ~/.xserverrc ~/.Xresources
	rm -rf ~/.Xresources.d

zsh: .zshrc .zprofile
	ln -rs $< ~/.zshrc
	ln -rs .zprofile ~/.zprofile

remove_zsh:
	rm -f ~/.zprofile ~/.zshrc

systemwide: nftables sysctl

remove_systemwide: remove_nftables remove_sysctl

nftables: .nftables
	sudo ln -rs $< /etc/nftables.conf

remove_nftables:
	sudo rm -f /etc/nftables.conf

sysctl: .sysctl
	sudo ln -rs $< /etc/sysctl.d/99-sysctl.conf

remove_sysctl:
	sudo rm -f /etc/sysctl.d/99-sysctl.conf
