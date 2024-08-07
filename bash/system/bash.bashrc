unset HISTFILE

PS1='$(STARSHIP_CONFIG=/etc/configuration/starship/starship.toml /usr/bin/starship prompt)'

if [[ -d '/etc/shellrc.d' ]]; then
	for script in /etc/shellrc.d/*.sh; do
		[[ -r "${script}" ]] && source "${script}"
	done
fi

if [[ -r '/usr/share/bash-completion/bash_completion' ]]; then
	source '/usr/share/bash-completion/bash_completion'
fi
