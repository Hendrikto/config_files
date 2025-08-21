# Documentation: `man 1 zsh` (STARTUP/SHUTDOWN FILES)

setopt HIST_IGNORE_DUPS
setopt SHARE_HISTORY

HISTFILE="${XDG_STATE_HOME}/zsh/history"
REPORTTIME=5
SAVEHIST=1000

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

# disable default virtualenv prompt
export VIRTUAL_ENV_DISABLE_PROMPT=1

setopt PROMPT_SUBST
PROMPT='$(STARSHIP_SHELL='zsh' /usr/bin/starship prompt)'
PROMPT2='%_…❯ '

source '/usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh'
