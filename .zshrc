alias ls='ls --color=auto'
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

setopt HIST_IGNORE_DUPS
SAVEHIST=1000
HISTFILE=~/.zsh_hist

autoload -Uz compinit
zstyle ':completion:*' completer _complete _ignored
zstyle :compinstall filename '/home/hendrik/.zshrc'

compinit

autoload -Uz vcs_info
zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:git*' formats '[%b%m%u%c]'
zstyle ':vcs_info:*' unstagedstr '×'
zstyle ':vcs_info:*' stagedstr '+'
zstyle ':vcs_info:git*+set-message:*' hooks git-untracked
zstyle ':vcs_info:git*+set-message:*' hooks git-remote-diff

+vi-git-untracked() {
	if [[ $(git rev-parse --is-inside-work-tree 2> /dev/null) == 'true' ]] && \
		git status --porcelain | grep '??' &> /dev/null ; then
		hook_com[misc]+='°'
	fi
}

+vi-git-remote-diff() {
	local ahead behind gitstatus

	ahead=$(git rev-list ${hook_com[branch]}@{upstream}..HEAD 2>/dev/null | wc -l)
	(( $ahead )) && gitstatus+=" ↑${ahead}"

	behind=$(git rev-list HEAD..${hook_com[branch]}@{upstream} 2>/dev/null | wc -l)
	(( $behind )) && gitstatus+=" ↓${behind}"

	hook_com[staged]+=${gitstatus}
}

precmd() {
	vcs_info
}

setopt PROMPT_SUBST
PROMPT='%F{blue}%n%f %F{yellow}%~%f %(!.$.%%) '
RPROMPT='${vcs_info_msg_0_}'
