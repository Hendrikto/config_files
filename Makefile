XDG_CONFIG_HOME ?= $(HOME)/.config

.PHONY: all remove_all

all: user system

remove_all: remove_user remove_system

USER := bash chrome firefox git i3 kitty picom procps xorg/user zsh
REMOVE_USER := $(USER:%=remove_%)

.PHONY: user $(USER) remove_user $(REMOVE_USER)

user: $(USER)

remove_user: $(REMOVE_USER)

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

kitty: $@ $(XDG_CONFIG_HOME)
	ln -rs $@ $(XDG_CONFIG_HOME)

remove_kitty:
	rm -f $(XDG_CONFIG_HOME)/kitty

picom: $@ $(XDG_CONFIG_HOME)
	ln -rs $@ $(XDG_CONFIG_HOME)

remove_picom:
	rm -f $(XDG_CONFIG_HOME)/picom

procps: $@ $(XDG_CONFIG_HOME)
	ln -rs $@ $(XDG_CONFIG_HOME)

remove_procps:
	rm -f $(XDG_CONFIG_HOME)/procps

xorg/user: $@
	ln -rs $@/.[!.]* ~

remove_xorg/user:
	rm -f ~/.{xinitrc,xserverrc,Xresources{,.d}}

zsh: $@
	ln -rs $@/.[!.]* ~

remove_zsh:
	rm -f ~/.{zprofile,zshrc}

SYSTEM := fontconfig nftables reflector sysctl systemd-networkd systemd-resolved xorg/system
REMOVE_SYSTEM := $(SYSTEM:%=remove_%)

.PHONY: system $(SYSTEM) remove_system $(REMOVE_SYSTEM)

system: $(SYSTEM)

remove_system: $(REMOVE_SYSTEM)

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
	sudo rm -f /etc/systemd/network/20-ether.network

systemd-resolved: $@
	sudo mkdir -p /etc/systemd/resolved.conf.d
	sudo cp $@/* /etc/systemd/resolved.conf.d

remove_systemd-resolved:
	sudo rm -f /etc/systemd/resolved.conf.d/dns.conf

xorg/system: $@
	sudo ln -rs $@/* /etc/X11/xorg.conf.d

remove_xorg/system:
	sudo rm -f /etc/X11/xorg.conf.d/30-touchpad.conf
