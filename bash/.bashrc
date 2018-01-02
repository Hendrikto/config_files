# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias l='ls -AFGh'
alias ll='l -l'

PS1='\e[34m\u\e[0m \e[33m\w\e[0m \\$\[$(tput sgr0)\] '
