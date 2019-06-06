XDG_CONFIG_HOME ?= $(HOME)/.config

USER = bash chrome compton firefox git i3 xorg zsh

.PHONY: $(USER)

all: $(USER)

remove_all: $(USER:%=remove_%)

$(XDG_CONFIG_HOME):
	mkdir -p $(XDG_CONFIG_HOME)

bash: $@
	ln -rs $@/.[!.]* ~

remove_bash:
	rm -f ~/.bash{rc,_profile}

chrome: $@ $(XDG_CONFIG_HOME)
	ln -rs $@/* $(XDG_CONFIG_HOME)

remove_chrome:
	rm -f $(XDG_CONFIG_HOME)/chrome-flags.conf

compton: $@ $(XDG_CONFIG_HOME)
	ln -rs $@ $(XDG_CONFIG_HOME)

remove_compton:
	rm -f $(XDG_CONFIG_HOME)/compton

firefox: $@
	$(eval profile:=$(shell find ~/.mozilla/firefox -name "*.default"))
	mkdir -p $(profile)
	ln -rs $@/* $(profile)

remove_firefox:
	$(eval profile:=$(shell find ~/.mozilla/firefox -name "*.default"))
	rm -f $(profile)/chrome

git: $@ $(XDG_CONFIG_HOME)
	ln -rs $@ $(XDG_CONFIG_HOME)

remove_git:
	rm -f $(XDG_CONFIG_HOME)/git

i3: $@ $(XDG_CONFIG_HOME)
	ln -rs $@/* $(XDG_CONFIG_HOME)

remove_i3:
	rm -f $(XDG_CONFIG_HOME)/i3{,status}

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
