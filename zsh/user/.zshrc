# Documentation: `man 1 zsh` (STARTUP/SHUTDOWN FILES)

setopt HIST_IGNORE_DUPS
SAVEHIST=1000
HISTFILE="${XDG_STATE_HOME}/zsh/history"

REPORTTIME=5

################################################################################
# Scripts                                                                      #
################################################################################

src() {
	if [[ -r "${1}" ]]; then
		source "${1}"
	fi
}

src '/usr/share/chruby/chruby.sh'
src '/usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh' # Arch
src '/usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh' # Fedora

unset -f src

################################################################################
# Terminal control codes                                                       #
################################################################################

bindkey '\e[5C' 'forward-word'
bindkey '\e[5D' 'backward-word'
bindkey '\e\e[C' 'forward-word'
bindkey '\e\e[D' 'backward-word'
bindkey '\e[1;5C' 'forward-word'
bindkey '\e[1;5D' 'backward-word'

bindkey '^U' 'backward-kill-line'

bindkey '\e[3~' 'delete-char'

################################################################################
# Aliases                                                                      #
################################################################################

alias top='top -u !0'

#################################### Colors ####################################

alias diff='diff --color=auto'
alias grep='grep --color=auto'
alias ip='ip --color=auto'
alias ls='ls --color=auto'

################################################################################
# Functions                                                                    #
################################################################################

o() {
	for file in "${@}"; do
		xdg-open "${file}" 2>'/dev/null' &
	done
}

################################################################################
# Hooks                                                                        #
################################################################################

# executed when the current working directory changes
chpwd () {
	# set title to current working directory
	echo -en "\e]0;$(basename "$(pwd)")\a"
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

AURA_BLACK='#15141b'
AURA_BLUE='#82e2ff'
AURA_GREEN='#61ffca'
AURA_ORANGE='#ffca85'
AURA_PURPLE='#a277ff'

# disable default virtualenv prompt
export VIRTUAL_ENV_DISABLE_PROMPT=1

autoload -Uz 'vcs_info'
zstyle ':vcs_info:*' 'enable' 'git'
zstyle ':vcs_info:*' 'check-for-changes' 'true'
zstyle ':vcs_info:git*' 'formats' '[%b%m%c%u%f]'
zstyle ':vcs_info:git*' 'actionformats' '[%b%c%u%f %a]'
zstyle ':vcs_info:*' 'unstagedstr' '%F{yellow}○'
zstyle ':vcs_info:*' 'stagedstr' '%F{green}◉'
zstyle ':vcs_info:git*+set-message:*' 'hooks' 'git-untracked' 'git-remote-diff'

+vi-git-untracked() {
	if [[ $(git status --porcelain 2>'/dev/null') =~ '\?\?' ]]; then
		hook_com[unstaged]+='%F{red}∆'
	fi
}

+vi-git-remote-diff() {
	local ahead="$(git rev-list --count '@{upstream}..' 2>'/dev/null')"
	local behind="$(git rev-list --count '..@{upstream}' 2>'/dev/null')"

	(( ahead )) && hook_com[unstaged]+="%F{blue} ↑${ahead}"
	(( behind )) && hook_com[unstaged]+="%F{blue} ↓${behind}"
}

precmd() {
	vcs_info
}

venv_info="\$([[ -n \"\${VIRTUAL_ENV}\" ]] && echo \"%F{${AURA_ORANGE}}%K{${AURA_BLACK}} \$(grep -oP 'prompt\s*=\s*\K.+?(?=\s*$)' \"\${VIRTUAL_ENV}/pyvenv.cfg\" 2>'/dev/null' || basename \"\${VIRTUAL_ENV}\") %F{${AURA_BLACK}}%K{0}\")"

setopt PROMPT_SUBST
RPROMPT='${vcs_info_msg_0_}'
PROMPT=\
"%F{${AURA_PURPLE}}%K{${AURA_BLACK}} %n "\
"%F{${AURA_BLACK}}%K{0}"\
"%F{${AURA_BLUE}}%K{${AURA_BLACK}} %M "\
"%F{${AURA_BLACK}}%K{0}"\
"%F{${AURA_GREEN}}%K{${AURA_BLACK}} %~ "\
"%F{${AURA_BLACK}}%K{0}"\
"${venv_info}"\
'%k%f
%(!.$.❯) '
PROMPT2='%_…❯ '

unset venv_info
