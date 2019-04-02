.PHONY: bash chrome firefox git i3 xorg zsh

all: bash chrome firefox git i3 xorg zsh

remove_all: remove_bash remove_chrome remove_firefox remove_git remove_i3 remove_xorg remove_zsh

bash: $@
	ln -rs $@/.[!.]* ~

remove_bash:
	rm -f ~/.bash{rc,_profile}

chrome: $@
	mkdir -p ~/.config
	ln -rs $@/* ~/.config

remove_chrome:
	rm -f ~/.config/chrome-flags.conf

firefox: $@
	$(eval profile:=$(shell find ~/.mozilla/firefox -name "*.default"))
	mkdir -p $(profile)
	ln -rs $@/* $(profile)

remove_firefox:
	$(eval profile:=$(shell find ~/.mozilla/firefox -name "*.default"))
	rm -f $(profile)/chrome

git: $@
	ln -rs $@/.[!.]* ~

remove_git:
	rm -f ~/.gitconfig

i3: $@
	mkdir -p ~/.config
	ln -rs $@/* ~/.config

remove_i3:
	rm -rf ~/.config/i3{,status}

xorg: $@
	ln -rs $@/.[!.]* ~

remove_xorg:
	rm -f ~/.{xinitrc,xserverrc,Xresources{,.d}}

zsh: $@
	ln -rs $@/.[!.]* ~

remove_zsh:
	rm -f ~/.{zprofile,zshrc}

.PHONY: fontconfig nftables reflector sysctl systemd-networkd

systemwide: fontconfig nftables reflector sysctl systemd-networkd

remove_systemwide: remove_fontconfig remove_nftables remove_reflector remove_sysctl remove_systemd-networkd

fontconfig: $@
	sudo ln -rs $@/* /etc/fonts

remove_fontconfig:
	sudo rm -f /etc/fonts/local.conf

nftables: $@
	sudo ln -rs $@/* /etc

remove_nftables:
	sudo rm -f /etc/nftables.conf

reflector: $@
	sudo mkdir -p /etc/pacman.d/hooks
	sudo ln -rs $@/* /etc/pacman.d/hooks

remove_reflector:
	sudo rm -f /etc/pacman.d/hooks/mirrorupgrade.hook

sysctl: $@
	sudo ln -rs $@/* /etc/sysctl.d

remove_sysctl:
	sudo rm -f /etc/sysctl.d/99-sysctl.conf

systemd-networkd: $@
	sudo ln -rs $@/* /etc/systemd/network

remove_systemd-networkd: $@
	sudo rm -f /etc/systemd/network/20-wired.network
