[[ -e /usr/share/chruby/chruby.sh ]] && source /usr/share/chruby/chruby.sh

setopt HIST_IGNORE_DUPS
SAVEHIST=1000
HISTFILE=~/.zsh_hist

REPORTTIME=5

################################################################################
# Terminal control codes                                                       #
################################################################################

bindkey "\e[5C" forward-word
bindkey "\e[5D" backward-word
bindkey "\e\e[C" forward-word
bindkey "\e\e[D" backward-word
bindkey "\e[1;5C" forward-word
bindkey "\e[1;5D" backward-word

[[ -n "$terminfo[khome]" ]] && bindkey "$terminfo[khome]" beginning-of-line
[[ -n "$terminfo[kend]" ]] && bindkey "$terminfo[kend]" end-of-line
[[ -n "$terminfo[kich1]" ]] && bindkey "$terminfo[kich1]" overwrite-mode
[[ -n "$terminfo[kbs]" ]] && bindkey "$terminfo[kbs]" backward-delete-char
[[ -n "$terminfo[kdch1]" ]] && bindkey "$terminfo[kdch1]" delete-char
[[ -n "$terminfo[kcuu1]" ]] && bindkey "$terminfo[kcuu1]" up-line-or-history
[[ -n "$terminfo[kcud1]" ]] && bindkey "$terminfo[kcud1]" down-line-or-history
[[ -n "$terminfo[kcub1]" ]] && bindkey "$terminfo[kcub1]" backward-char
[[ -n "$terminfo[kcuf1]" ]] && bindkey "$terminfo[kcuf1]" forward-char

################################################################################
# Environment variables                                                        #
################################################################################

export CFLAGS='-O2 -march=native'
export EDITOR='subl'
export PATH=$PATH:~/.local/bin
export QT_QPA_PLATFORMTHEME=gtk2

################################################################################
# Alias / Functions                                                            #
################################################################################

alias e=$EDITOR
alias l='exa --git-ignore --group-directories-first'
alias ll='exa -la --git --group-directories-first'
alias t='l --tree'
alias tl='ll --tree'

o() {
    xdg-open $1 2>/dev/null &
}

################################################################################
# Autocomplete                                                                 #
################################################################################

autoload -Uz compinit
zstyle ':completion:*' completer _complete _approximate _ignored
zstyle ':completion:*' menu select

compinit

################################################################################
# Custom prompt                                                                #
################################################################################

autoload -Uz vcs_info
zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:git*' formats '[%b%m%u%c]'
zstyle ':vcs_info:git*' actionformats "[%b%u%c %a]"
zstyle ':vcs_info:*' unstagedstr '○'
zstyle ':vcs_info:*' stagedstr '◉'
zstyle ':vcs_info:git*+set-message:*' hooks git-untracked git-remote-diff

+vi-git-untracked() {
	if [[ $(git rev-parse --is-inside-work-tree 2> /dev/null) == 'true' ]] && \
		git status --porcelain | grep '??' &> /dev/null ; then
		hook_com[staged]+='∆'
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

zsh_syntax_highlighting=/usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
[[ -e $zsh_syntax_highlighting ]] && source $zsh_syntax_highlighting
