# Fallbacks in case pam_env is not configured
XDG_CONFIG_HOME ?= $(HOME)/.config
XDG_STATE_HOME ?= $(HOME)/.local/state

# Create absolute symbolic links
LINK = ln --force --symbolic $(realpath $(wildcard $(1))) $(2)

.PHONY: all remove_all

all: user system

remove_all: remove_user remove_system

.PHONY: ensure_root
ensure_root:
ifneq ($(shell id -u), 0)
	@echo 'This rule requires root privileges.'
	@exit 1
endif

USER := bash chrome firefox git i3 kitty picom procps python xorg/user zsh/user
REMOVE_USER := $(USER:%=remove_%)

.PHONY: user $(USER) remove_user $(REMOVE_USER)

user: $(USER)

remove_user: $(REMOVE_USER)

$(XDG_CONFIG_HOME):
	mkdir -p $(XDG_CONFIG_HOME)

$(XDG_STATE_HOME):
	mkdir -p --mode=750 $(XDG_STATE_HOME)

bash: $@ $(XDG_STATE_HOME)
	$(call LINK,$@/.[!.]*,~)
	mkdir -p $(XDG_STATE_HOME)/bash

remove_bash:
	rm -f ~/.bash{rc,_profile}

chrome: $@ $(XDG_CONFIG_HOME)
	$(call LINK,$@/*,$(XDG_CONFIG_HOME))

remove_chrome:
	rm -f $(XDG_CONFIG_HOME)/chrome-flags.conf

firefox: $@
	$(eval profile:=$(shell find ~/.mozilla/firefox -name "*.default"))
	mkdir -p $(profile)
	$(call LINK,$@/*,$(profile))

remove_firefox:
	$(eval profile:=$(shell find ~/.mozilla/firefox -name "*.default"))
	rm -f $(profile)/chrome

git: $@ $(XDG_CONFIG_HOME)
	$(call LINK,$@,$(XDG_CONFIG_HOME))

remove_git:
	rm -f $(XDG_CONFIG_HOME)/git

i3: $@ $(XDG_CONFIG_HOME)
	$(call LINK,$@/*,$(XDG_CONFIG_HOME))

remove_i3:
	rm -f $(XDG_CONFIG_HOME)/i3{,status}

kitty: $@ $(XDG_CONFIG_HOME)
	$(call LINK,$@,$(XDG_CONFIG_HOME))

remove_kitty:
	rm -f $(XDG_CONFIG_HOME)/kitty

picom: $@ $(XDG_CONFIG_HOME)
	$(call LINK,$@,$(XDG_CONFIG_HOME))

remove_picom:
	rm -f $(XDG_CONFIG_HOME)/picom

procps: $@ $(XDG_CONFIG_HOME)
	$(call LINK,$@,$(XDG_CONFIG_HOME))

remove_procps:
	rm -f $(XDG_CONFIG_HOME)/procps

python: $@ $(XDG_CONFIG_HOME)
	$(call LINK,$@,$(XDG_CONFIG_HOME))

remove_python:
	rm -r $(XDG_CONFIG_HOME)/python

xorg/user: $@
	$(call LINK,$@/.[!.]*,~)

remove_xorg/user:
	rm -f ~/.{xinitrc,xserverrc,Xresources{,.d}}

zsh/user: $@ $(XDG_STATE_HOME)
	$(call LINK,$@/.[!.]*,~)
	mkdir -p $(XDG_STATE_HOME)/zsh

remove_zsh/user:
	rm -f ~/.{zprofile,zshrc}

SYSTEM := battery_warning dbus fontconfig nftables nsswitch pam reflector shadow.service shell sysctl systemd-networkd systemd-resolved xorg/system zsh/system
REMOVE_SYSTEM := $(SYSTEM:%=remove_%)

.PHONY: system $(SYSTEM) remove_system $(REMOVE_SYSTEM)

system: $(SYSTEM)

remove_system: $(REMOVE_SYSTEM)

battery_warning: ensure_root $@
	$(call LINK,$@/battery_warning.service.d,/etc/systemd/system)

remove_battery_warning: ensure_root
	rm -f /etc/systemd/system/battery_warning.service.d

dbus: ensure_root $@
	$(call LINK,$@/dbus.service.d,/etc/systemd/system)

remove_dbus: ensure_root
	rm -f /etc/systemd/system/dbus.service.d

fontconfig: ensure_root $@
	$(call LINK,$@/*,/etc/fonts)

remove_fontconfig: ensure_root
	rm -f /etc/fonts/local.conf

nftables: ensure_root $@
	$(call LINK,$@/*,/etc)

remove_nftables: ensure_root
	rm -f /etc/nftables.conf

nsswitch: ensure_root $@
	$(call LINK,$@/*,/etc)

remove_nsswitch: ensure_root
	rm -f /etc/nsswitch.conf

pam: ensure_root $@
	$(call LINK,$@/pam_env.conf,/etc/security/pam_env.conf)

remove_pam: ensure_root
	rm -f /etc/security/pam_env.conf

reflector: ensure_root $@
	mkdir -p /etc/pacman.d/hooks
	$(call LINK,$@/*,/etc/pacman.d/hooks)

remove_reflector: ensure_root
	rm -f /etc/pacman.d/hooks/mirrorupgrade.hook

shadow.service: ensure_root $@
	$(call LINK,$@/shadow.service.d,/etc/systemd/system)

remove_shadow.service: ensure_root
	rm -r /etc/systemd/system/shadow.service.d

shell: ensure_root $@
	$(call LINK,$@/shellrc.d,/etc)

remove_shell: ensure_root
	rm -f /etc/shellrc.d

sysctl: ensure_root $@
	$(call LINK,$@/*,/etc/sysctl.d)

remove_sysctl: ensure_root
	rm -f /etc/sysctl.d/99-sysctl.conf

systemd-networkd: ensure_root $@
	cp $@/* /etc/systemd/network

remove_systemd-networkd: ensure_root $@
	rm -f /etc/systemd/network/20-network.network

systemd-resolved: ensure_root $@
	mkdir -p /etc/systemd/resolved.conf.d
	cp $@/* /etc/systemd/resolved.conf.d

remove_systemd-resolved: ensure_root
	rm -f /etc/systemd/resolved.conf.d/dns.conf

xorg/system: ensure_root $@
	$(call LINK,$@/*,/etc/X11/xorg.conf.d)

remove_xorg/system: ensure_root
	rm -f /etc/X11/xorg.conf.d/30-touchpad.conf

zsh/system: ensure_root $@
	$(call LINK,$@/*,/etc/zsh)

remove_zsh/system: ensure_root
	rm -f /etc/zsh/zshrc
