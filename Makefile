USER = bash chrome compton firefox git i3 xorg zsh

.PHONY: $(USER)

all: $(USER)

remove_all: $(USER:%=remove_%)

bash: $@
	ln -rs $@/.[!.]* ~

remove_bash:
	rm -f ~/.bash{rc,_profile}

chrome: $@
	mkdir -p ~/.config
	ln -rs $@/* ~/.config

remove_chrome:
	rm -f ~/.config/chrome-flags.conf

compton: $@
	mkdir -p ~/.config
	ln -rs $@ ~/.config

remove_compton:
	rm -rf ~/.config/compton

firefox: $@
	$(eval profile:=$(shell find ~/.mozilla/firefox -name "*.default"))
	mkdir -p $(profile)
	ln -rs $@/* $(profile)

remove_firefox:
	$(eval profile:=$(shell find ~/.mozilla/firefox -name "*.default"))
	rm -f $(profile)/chrome

git: $@
	ln -rs $@ ~/.config

remove_git:
	rm -f ~/.config/git

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

SYSTEM = fontconfig nftables reflector sysctl systemd-networkd

.PHONY: $(SYSTEM)

systemwide: $(SYSTEM)

remove_systemwide: $(SYSTEM:%=remove_%)

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
	sudo cp $@/* /etc/systemd/network

remove_systemd-networkd: $@
	sudo rm -f /etc/systemd/network/20-wired.network
