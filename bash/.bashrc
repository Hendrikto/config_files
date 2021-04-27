# If not running interactively, don't do anything
[[ $- != *i* ]] && return

HISTFILE=${XDG_CACHE_HOME}/bash/history

PS1='\e[34m\u\e[0m \e[33m\w\e[0m \\$\[$(tput sgr0)\] '
