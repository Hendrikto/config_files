# If not running interactively, don't do anything
[[ "${-}" != *i* ]] && return

HISTFILE="${XDG_STATE_HOME}/bash/history"

AURA_BLACK='21;20;27'
AURA_GREEN='97;255;202'
AURA_PURPLE='162;119;255'

color() {
	echo -n "\e[38;2;${1}m\e[48;2;${2}m${3}\e[m"
}

PS1=\
"$(color "${AURA_PURPLE}" "${AURA_BLACK}" ' \u ')"\
"$(color "${AURA_BLACK}" '0;0;0' '')"\
"$(color "${AURA_GREEN}" "${AURA_BLACK}" ' \w ')"\
"$(color "${AURA_BLACK}" '0;0;0' '')"\
'\n❯ '
