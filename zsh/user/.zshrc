chruby='/usr/share/chruby/chruby.sh'
[[ -r "${chruby}" ]] && source "${chruby}"
unset chruby

setopt HIST_IGNORE_DUPS
SAVEHIST=1000
HISTFILE="${XDG_CACHE_HOME}/zsh/history"

REPORTTIME=5

################################################################################
# Terminal control codes                                                       #
################################################################################

bindkey '\e[5C' 'forward-word'
bindkey '\e[5D' 'backward-word'
bindkey '\e\e[C' 'forward-word'
bindkey '\e\e[D' 'backward-word'
bindkey '\e[1;5C' 'forward-word'
bindkey '\e[1;5D' 'backward-word'

bindkey '\e[3~' 'delete-char'

################################################################################
# Alias / Functions                                                            #
################################################################################

alias e='${EDITOR}'

o() {
	xdg-open "${1}" 2>'/dev/null' &
}

################################################################################
# Autocomplete                                                                 #
################################################################################

autoload -Uz 'compinit'
zstyle ':completion:*' 'completer' '_complete' '_approximate' '_ignored'
zstyle ':completion:*' 'menu' 'select'

compinit

################################################################################
# Custom prompt                                                                #
################################################################################

# disable default virtualenv prompt
export VIRTUAL_ENV_DISABLE_PROMPT=1

color_prompt() {
	printf '%%F{%s}%%K{%s}%s%%k%%f' "${1}" "${2}" "${3}"
}

autoload -Uz 'vcs_info'
zstyle ':vcs_info:*' 'enable' 'git'
zstyle ':vcs_info:*' 'check-for-changes' 'true'
zstyle ':vcs_info:git*' 'formats' '[%b%m%c%u]'
zstyle ':vcs_info:git*' 'actionformats' '[%b%c%u %a]'
zstyle ':vcs_info:*' 'unstagedstr' "$(color_prompt 'yellow' 'black' '○')"
zstyle ':vcs_info:*' 'stagedstr' "$(color_prompt 'green' 'black' '◉')"
zstyle ':vcs_info:git*+set-message:*' 'hooks' 'git-untracked' 'git-remote-diff'

+vi-git-untracked() {
	if [[ "$(git rev-parse --is-inside-work-tree 2>'/dev/null')" == 'true' ]] && \
		git status --porcelain | grep '??' &>'/dev/null'; then
		hook_com[unstaged]+="$(color_prompt 'red' 'black' '∆')"
	fi
}

+vi-git-remote-diff() {
	local ahead behind

	ahead="$(git rev-list "${hook_com[branch]}@{upstream}..HEAD" 2>'/dev/null' | wc -l)"
	behind="$(git rev-list "HEAD..${hook_com[branch]}@{upstream}" 2>'/dev/null' | wc -l)"
	(( ${ahead} )) && hook_com[unstaged]+="$(color_prompt 'blue' 'black' " ↑${ahead}")"
	(( ${behind} )) && hook_com[unstaged]+="$(color_prompt 'blue' 'black' " ↓${behind}")"
}

venv_info() {
	if [[ -n "${VIRTUAL_ENV}" ]]; then
		venv_prompt="$(grep -oP 'prompt\s*=\s*\K.+?(?=\s*$)' "${VIRTUAL_ENV}/pyvenv.cfg")"
		venv_prompt="$(color_prompt 'yellow' '208' '')$(color_prompt 'black' '208' " $venv_prompt ")$(color_prompt '208' 'black' '')"
	else
		venv_prompt="$(color_prompt 'yellow' 'black' '')"
	fi
}

precmd() {
	vcs_info
	venv_info
}

setopt PROMPT_SUBST
RPROMPT='${vcs_info_msg_0_}'
PROMPT="$(color_prompt 'black' 'blue' ' %n ')$(color_prompt 'blue' 'yellow' '')$(color_prompt 'black' 'yellow' ' %~ ')"'${venv_prompt}'$'\n''%(!.$.❯) '

################################################################################
# Color output (https://wiki.archlinux.org/index.php/Color_output_in_console)  #
################################################################################

alias diff='diff --color=auto'
alias grep='grep --color=auto'
alias ip='ip --color=auto'
alias ls='ls --color=auto'

export LESS_TERMCAP_md=$'\e[01;31m'
export LESS_TERMCAP_me=$'\e[0m'
export LESS_TERMCAP_se=$'\e[0m'
export LESS_TERMCAP_so=$'\e[01;44;33m'
export LESS_TERMCAP_ue=$'\e[0m'
export LESS_TERMCAP_us=$'\e[01;32m'

zsh_syntax_highlighting='/usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh'
[[ -r "${zsh_syntax_highlighting}" ]] && source "${zsh_syntax_highlighting}"
unset zsh_syntax_highlighting
