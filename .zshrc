alias l='ls -AFGhl'

bindkey "\e[1~" beginning-of-line
bindkey "\e[4~" end-of-line
bindkey "\e[5~" beginning-of-history
bindkey "\e[6~" end-of-history
bindkey "\e[7~" beginning-of-line
bindkey "\e[3~" delete-char
bindkey "\e[2~" quoted-insert
bindkey "\e[5C" forward-word
bindkey "\e[5D" backward-word
bindkey "\e\e[C" forward-word
bindkey "\e\e[D" backward-word
bindkey "\e[1;5C" forward-word
bindkey "\e[1;5D" backward-word
bindkey "\e[8~" end-of-line
bindkey "\eOH" beginning-of-line
bindkey "\eOF" end-of-line
bindkey "\e[H" beginning-of-line
bindkey "\e[F" end-of-line

export CFLAGS="-O2 -march=native"
export QT_QPA_PLATFORMTHEME=gtk2

source /usr/share/chruby/chruby.sh

setopt HIST_IGNORE_DUPS
SAVEHIST=1000
HISTFILE=~/.zsh_hist

autoload -Uz compinit
zstyle ':completion:*' completer _complete _ignored
zstyle :compinstall filename '/home/hendrik/.zshrc'

compinit

################################################################################
# Custom prompt                                                                #
################################################################################

autoload -Uz vcs_info
zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:git*' formats '[%b%m%u%c]'
zstyle ':vcs_info:*' unstagedstr '○'
zstyle ':vcs_info:*' stagedstr '◉'
zstyle ':vcs_info:git*+set-message:*' hooks git-untracked
zstyle ':vcs_info:git*+set-message:*' hooks git-remote-diff

+vi-git-untracked() {
	if [[ $(git rev-parse --is-inside-work-tree 2> /dev/null) == 'true' ]] && \
		git status --porcelain | grep '??' &> /dev/null ; then
		hook_com[misc]+='◇'
	fi
}

+vi-git-remote-diff() {
	local ahead behind

	ahead=$(git rev-list ${hook_com[branch]}@{upstream}..HEAD 2>/dev/null | wc -l)
	behind=$(git rev-list HEAD..${hook_com[branch]}@{upstream} 2>/dev/null | wc -l)
	(( $ahead )) && hook_com[staged]+=" ↑$ahead"
	(( $behind )) && hook_com[staged]+=" ↓$behind"
}

precmd() {
	vcs_info
}

setopt PROMPT_SUBST
PROMPT='%F{blue}%n%f %F{yellow}%~%f %(!.$.%%) '
RPROMPT='${vcs_info_msg_0_}'

################################################################################
# Color output (https://wiki.archlinux.org/index.php/Color_output_in_console)  #
################################################################################

alias diff='diff --color=auto'
alias grep='grep --color=auto'
alias ls='ls --color=auto'

export LESS_TERMCAP_md=$'\e[01;31m'
export LESS_TERMCAP_me=$'\e[0m'
export LESS_TERMCAP_se=$'\e[0m'
export LESS_TERMCAP_so=$'\e[01;44;33m'
export LESS_TERMCAP_ue=$'\e[0m'
export LESS_TERMCAP_us=$'\e[01;32m'
