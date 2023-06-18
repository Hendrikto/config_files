# Fallbacks in case pam_env is not configured
XDG_CONFIG_HOME ?= $(HOME)/.config
XDG_STATE_HOME ?= $(HOME)/.local/state

MKDIR := mkdir --parents

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

USER := bash chrome firefox git/user i3 i3status kitty picom procps python sway waybar wofi xorg/user zsh/user
REMOVE_USER := $(USER:%=remove-%)

.PHONY: user $(USER) remove_user

user: $(USER)

remove_user: $(REMOVE_USER)

# Implicit rule for XDG-compliant user-level configuration removal
remove-%:
	$(RM) $(XDG_CONFIG_HOME)/$*

$(XDG_CONFIG_HOME):
	$(MKDIR) $(XDG_CONFIG_HOME)

$(XDG_STATE_HOME):
	$(MKDIR) --mode=750 $(XDG_STATE_HOME)

bash: $@ $(XDG_STATE_HOME)
	$(call LINK,$@/.[!.]*,~)
	$(MKDIR) $(XDG_STATE_HOME)/bash

remove-bash:
	$(RM) ~/.bash{rc,_profile}

chrome: $@ $(XDG_CONFIG_HOME)
	$(call LINK,$@/*,$(XDG_CONFIG_HOME))

remove-chrome:
	$(RM) $(XDG_CONFIG_HOME)/chrome-flags.conf

firefox: $@
	$(MKDIR) ~/.mozilla/firefox/hendrik
	$(call LINK,$@/*,~/.mozilla/firefox/hendrik)

remove-firefox:
	$(RM) --recursive ~/.mozilla/firefox/hendrik/user.js
	rmdir --ignore-fail-on-non-empty ~/.mozilla/firefox/hendrik

git/user: $@ $(XDG_CONFIG_HOME)
	$(call LINK,$@,$(XDG_CONFIG_HOME)/git)

remove-git/user:
	$(RM) $(XDG_CONFIG_HOME)/git

i3: i3/$@ $(XDG_CONFIG_HOME)
	$(call LINK,i3/$@,$(XDG_CONFIG_HOME))

i3status: i3/$@ $(XDG_CONFIG_HOME)
	$(call LINK,i3/$@,$(XDG_CONFIG_HOME))

kitty: $@ $(XDG_CONFIG_HOME)
	$(call LINK,$@,$(XDG_CONFIG_HOME))

picom: $@ $(XDG_CONFIG_HOME)
	$(call LINK,$@,$(XDG_CONFIG_HOME))

procps: $@ $(XDG_CONFIG_HOME)
	$(call LINK,$@,$(XDG_CONFIG_HOME))

python: $@ $(XDG_CONFIG_HOME)
	$(call LINK,$@,$(XDG_CONFIG_HOME))

sway: $@ $(XDG_CONFIG_HOME)
	$(MKDIR) $(XDG_CONFIG_HOME)/sway/config.d
	$(call LINK,$@/config,$(XDG_CONFIG_HOME)/sway)
	cp --interactive $@/config.d/* $(XDG_CONFIG_HOME)/sway/config.d

remove-sway:
	$(RM) $(XDG_CONFIG_HOME)/sway/config

waybar: $@ $(XDG_CONFIG_HOME)
	$(call LINK,$@,$(XDG_CONFIG_HOME))

wofi: $@ $(XDG_CONFIG_HOME)
	$(call LINK,$@,$(XDG_CONFIG_HOME))

xorg/user: $@
	$(call LINK,$@/.[!.]*,~)

remove-xorg/user:
	$(RM) ~/.{xinitrc,xserverrc,Xresources{,.d}}

zsh/user: $@ $(XDG_STATE_HOME)
	$(call LINK,$@/.[!.]*,~)
	$(MKDIR) $(XDG_STATE_HOME)/zsh

remove-zsh/user:
	$(RM) ~/.{zprofile,zshrc}

SYSTEM := battery_warning dbus fontconfig git/system nftables nsswitch pam reflector shadow.service shell sudo sysctl systemd-networkd systemd-resolved xorg/system zsh/system
REMOVE_SYSTEM := $(SYSTEM:%=remove-%)

.PHONY: system $(SYSTEM) remove_system $(REMOVE_SYSTEM)

system: $(SYSTEM)

remove_system: $(REMOVE_SYSTEM)

battery_warning: ensure_root $@
	$(call LINK,$@/battery_warning.service.d,/etc/systemd/system)

remove-battery_warning: ensure_root
	$(RM) /etc/systemd/system/battery_warning.service.d

dbus: ensure_root $@
	$(call LINK,$@/dbus.service.d,/etc/systemd/system)

remove-dbus: ensure_root
	$(RM) /etc/systemd/system/dbus.service.d

fontconfig: ensure_root $@
	$(call LINK,$@/*,/etc/fonts)

remove-fontconfig: ensure_root
	$(RM) /etc/fonts/local.conf

git/system: ensure_root $@
	$(call LINK,$@/config,/etc/gitconfig)

remove-git/system: ensure_root
	$(RM) /etc/gitconfig

nftables: ensure_root $@
	$(call LINK,$@/nftables.conf,/etc)
	$(MKDIR) /etc/nftables.conf.d
	cp --interactive $@/nftables.conf.d/* /etc/nftables.conf.d

remove-nftables: ensure_root
	$(RM) /etc/nftables.conf
	rmdir --ignore-fail-on-non-empty /etc/nftables.conf.d

nsswitch: ensure_root $@
	$(call LINK,$@/*,/etc)

remove-nsswitch: ensure_root
	$(RM) /etc/nsswitch.conf

pam: ensure_root $@
	$(call LINK,$@/pam_env.conf,/etc/security/pam_env.conf)

remove-pam: ensure_root
	$(RM) /etc/security/pam_env.conf

reflector: ensure_root $@
	$(MKDIR) /etc/pacman.d/hooks
	$(call LINK,$@/*,/etc/pacman.d/hooks)

remove-reflector: ensure_root
	$(RM) /etc/pacman.d/hooks/mirrorupgrade.hook

shadow.service: ensure_root $@
	$(call LINK,$@/shadow.service.d,/etc/systemd/system)

remove-shadow.service: ensure_root
	$(RM) /etc/systemd/system/shadow.service.d

shell: ensure_root $@
	$(call LINK,$@/shellrc.d,/etc)

remove-shell: ensure_root
	$(RM) /etc/shellrc.d

sudo: ensure_root $@
	$(call LINK,$@/sudoers.d/*,/etc/sudoers.d)

remove-sudo: ensure_root
	$(RM) /etc/sudoers.d/group-wheel

sysctl: ensure_root $@
	$(call LINK,$@/*,/etc/sysctl.d)

remove-sysctl: ensure_root
	$(RM) /etc/sysctl.d/99-sysctl.conf

systemd-networkd: ensure_root $@
	$(call LINK,$@/*,/etc/systemd/network)

remove-systemd-networkd: ensure_root $@
	$(RM) /etc/systemd/network/20-network.network

systemd-resolved: ensure_root $@
	$(MKDIR) /etc/systemd/resolved.conf.d
	$(call LINK,$@/*,/etc/systemd/resolved.conf.d)
	# enable recommended mode of operation
	$(call LINK,/run/systemd/resolve/stub-resolv.conf,/etc/resolv.conf)

remove-systemd-resolved: ensure_root
	$(RM) /etc/systemd/resolved.conf.d/dns.conf

xorg/system: ensure_root $@
	$(call LINK,$@/*,/etc/X11/xorg.conf.d)

remove-xorg/system: ensure_root
	$(RM) /etc/X11/xorg.conf.d/30-touchpad.conf

ZSH_SYSTEM_PREFIX := /etc/zsh

zsh/system: ensure_root $@
	$(MKDIR) $(ZSH_SYSTEM_PREFIX)
	$(call LINK,$@/*,$(ZSH_SYSTEM_PREFIX))

remove-zsh/system: ensure_root
	$(RM) $(ZSH_SYSTEM_PREFIX)/zshrc
	rmdir --ignore-fail-on-non-empty $(ZSH_SYSTEM_PREFIX)
