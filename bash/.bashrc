# If not running interactively, don't do anything
[[ "${-}" != *i* ]] && return

HISTFILE="${XDG_CACHE_HOME}/bash/history"

PS1='\e[30;44m \u \e[34;43m\e[30;43m \w \e[33;40m\e[0m\n❯ '
