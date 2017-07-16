alias ls='ls --color=auto'
alias l='ls -AFGhl'

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
zstyle ':vcs_info:git*' formats '[%b %m%u%c]'
zstyle ':vcs_info:*' unstagedstr '×'
zstyle ':vcs_info:*' stagedstr '+'
zstyle ':vcs_info:git*+set-message:*' hooks git-untracked

+vi-git-untracked() {
	if [[ $(git rev-parse --is-inside-work-tree 2> /dev/null) == 'true' ]] && \
		git status --porcelain | grep '??' &> /dev/null ; then
		hook_com[staged]+='°'
	fi
}

precmd() {
	vcs_info
}

setopt PROMPT_SUBST
PROMPT='%F{blue}%n%f %F{yellow}%~%f %(!.$.%%) '
RPROMPT='${vcs_info_msg_0_}'
