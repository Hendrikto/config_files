# Documentation: `man 1 zsh` (STARTUP/SHUTDOWN FILES)

####################################################################################################
#                                      Environment Variables                                       #
####################################################################################################

export CFLAGS='-O2 -march=native -mtune=native'
export EDITOR='subl'
export PATH="${PATH}:~/.local/bin"
export QT_QPA_PLATFORMTHEME='gtk2'

python_startup="${XDG_CONFIG_HOME}/python/startup.py"
[[ -r "${python_startup}" ]] && export PYTHONSTARTUP="${python_startup}"
unset python_startup

############################################## Colors ##############################################

export LESS_TERMCAP_md=$'\e[01;31m'
export LESS_TERMCAP_me=$'\e[0m'
export LESS_TERMCAP_se=$'\e[0m'
export LESS_TERMCAP_so=$'\e[01;44;33m'
export LESS_TERMCAP_ue=$'\e[0m'
export LESS_TERMCAP_us=$'\e[01;32m'

####################################################################################################
#                                          Display Server                                          #
####################################################################################################

if [[ -z "${DISPLAY}" ]] && [[ -n "${XDG_VTNR}" ]] && (( ${XDG_VTNR} == 1 )); then
	exec xinit
fi
