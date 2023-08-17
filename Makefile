# Fallbacks in case pam_env is not configured
XDG_CONFIG_HOME ?= $(HOME)/.config
XDG_STATE_HOME ?= $(HOME)/.local/state

MKDIR := mkdir --parents

# Create absolute symbolic links
LINK = ln --force --symbolic $(realpath $(wildcard $(1))) $(2)

.PHONY: deploy_all remove_all

deploy_all: user system

remove_all: remove_user remove_system

.PHONY: ensure_root
ensure_root:
ifneq ($(shell id -u), 0)
	@echo 'This rule requires root privileges.'
	@exit 1
endif

USER := bash chrome firefox git/user i3 i3status kitty picom procps python sway waybar wofi xorg/user zsh/user
DEPLOY_USER := $(USER:%=deploy-%)
REMOVE_USER := $(USER:%=remove-%)

.PHONY: deploy_user remove_user

deploy_user: $(DEPLOY_USER)

remove_user: $(REMOVE_USER)

# Implicit rule for XDG-compliant user-level configuration deployment
deploy-%: $(XDG_CONFIG_HOME)
	$(call LINK,$*,$(XDG_CONFIG_HOME))

# Implicit rule for XDG-compliant user-level configuration removal
remove-%:
	$(RM) $(XDG_CONFIG_HOME)/$*

$(XDG_CONFIG_HOME):
	$(MKDIR) $(XDG_CONFIG_HOME)

$(XDG_STATE_HOME):
	$(MKDIR) --mode=750 $(XDG_STATE_HOME)

deploy-bash: $(XDG_STATE_HOME)
	$(call LINK,bash/.[!.]*,~)
	$(MKDIR) $(XDG_STATE_HOME)/bash

remove-bash:
	$(RM) ~/.bash{rc,_profile}

deploy-chrome: $(XDG_CONFIG_HOME)
	$(call LINK,chrome/*,$(XDG_CONFIG_HOME))

remove-chrome:
	$(RM) $(XDG_CONFIG_HOME)/chrome-flags.conf

deploy-firefox:
	$(MKDIR) ~/.mozilla/firefox/hendrik
	$(call LINK,firefox/*,~/.mozilla/firefox/hendrik)

remove-firefox:
	$(RM) --recursive ~/.mozilla/firefox/hendrik/user.js
	rmdir --ignore-fail-on-non-empty ~/.mozilla/firefox/hendrik

deploy-git/user: $(XDG_CONFIG_HOME)
	$(call LINK,git/user,$(XDG_CONFIG_HOME)/git)

remove-git/user:
	$(RM) $(XDG_CONFIG_HOME)/git

deploy-xorg/user:
	$(call LINK,xorg/user/.[!.]*,~)

remove-xorg/user:
	$(RM) ~/.{xinitrc,xserverrc,Xresources{,.d}}

deploy-zsh/user: $(XDG_STATE_HOME)
	$(call LINK,zsh/user/.[!.]*,~)
	$(MKDIR) $(XDG_STATE_HOME)/zsh

remove-zsh/user:
	$(RM) ~/.{zprofile,zshrc}

SYSTEM := dbus fontconfig git/system nftables nsswitch openssh pam reflector shadow.service shell sudo sysctl systemd-networkd systemd-resolved xorg/system zsh/system
DEPLOY_SYSTEM := $(SYSTEM:%=deploy-%)
REMOVE_SYSTEM := $(SYSTEM:%=remove-%)

.PHONY: deploy_system $(DEPLOY_SYSTEM) remove_system $(REMOVE_SYSTEM)

deploy_system: $(DEPLOY_SYSTEM)

remove_system: $(REMOVE_SYSTEM)

deploy-dbus: ensure_root
	$(call LINK,dbus/dbus.service.d,/etc/systemd/system)

remove-dbus: ensure_root
	$(RM) /etc/systemd/system/dbus.service.d

deploy-fontconfig: ensure_root
	$(call LINK,fontconfig/*,/etc/fonts)

remove-fontconfig: ensure_root
	$(RM) /etc/fonts/local.conf

deploy-git/system: ensure_root
	$(call LINK,git/system/config,/etc/gitconfig)

remove-git/system: ensure_root
	$(RM) /etc/gitconfig

deploy-nftables: ensure_root
	$(call LINK,nftables/*,/etc)

remove-nftables: ensure_root
	$(RM) /etc/nftables.conf{,.d}

deploy-nsswitch: ensure_root
	$(call LINK,nsswitch/*,/etc)

remove-nsswitch: ensure_root
	$(RM) /etc/nsswitch.conf

deploy-openssh: ensure_root
	$(call LINK,openssh/sshd_config.d/*,/etc/ssh/sshd_config.d/)

remove-openssh: ensure_root
	$(RM) /etc/ssh/sshd_config.d/50-authentication.conf

deploy-pam: ensure_root
	$(call LINK,pam/pam_env.conf,/etc/security)

remove-pam: ensure_root
	$(RM) /etc/security/pam_env.conf

deploy-reflector: ensure_root
	$(MKDIR) /etc/pacman.d/hooks
	$(call LINK,reflector/*,/etc/pacman.d/hooks)

remove-reflector: ensure_root
	$(RM) /etc/pacman.d/hooks/mirrorupgrade.hook

deploy-shadow.service: ensure_root
	$(call LINK,shadow.service/shadow.service.d,/etc/systemd/system)

remove-shadow.service: ensure_root
	$(RM) /etc/systemd/system/shadow.service.d

deploy-shell: ensure_root
	$(call LINK,shell/shellrc.d,/etc)

remove-shell: ensure_root
	$(RM) /etc/shellrc.d

deploy-sudo: ensure_root
	$(call LINK,sudo/sudoers.d/*,/etc/sudoers.d)

remove-sudo: ensure_root
	$(RM) /etc/sudoers.d/group-wheel

deploy-sysctl: ensure_root
	$(call LINK,sysctl/*,/etc/sysctl.d)

remove-sysctl: ensure_root
	$(RM) /etc/sysctl.d/99-sysctl.conf

deploy-systemd-networkd: ensure_root
	$(call LINK,systemd-networkd/*,/etc/systemd/network)

remove-systemd-networkd: ensure_root
	$(RM) /etc/systemd/network/20-network.network

deploy-systemd-resolved: ensure_root
	$(MKDIR) /etc/systemd/resolved.conf.d
	$(call LINK,systemd-resolved/*,/etc/systemd/resolved.conf.d)
	# enable recommended mode of operation
	$(call LINK,/run/systemd/resolve/stub-resolv.conf,/etc/resolv.conf)

remove-systemd-resolved: ensure_root
	$(RM) /etc/systemd/resolved.conf.d/dns.conf

deploy-xorg/system: ensure_root
	$(call LINK,xorg/system/*,/etc/X11/xorg.conf.d)

remove-xorg/system: ensure_root
	$(RM) /etc/X11/xorg.conf.d/30-touchpad.conf

ZSH_SYSTEM_PREFIX := /etc/zsh

deploy-zsh/system: ensure_root
	$(MKDIR) $(ZSH_SYSTEM_PREFIX)
	$(call LINK,zsh/system/*,$(ZSH_SYSTEM_PREFIX))

remove-zsh/system: ensure_root
	$(RM) $(ZSH_SYSTEM_PREFIX)/zshrc
	rmdir --ignore-fail-on-non-empty $(ZSH_SYSTEM_PREFIX)
