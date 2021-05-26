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

####################################################################################################
#                                          Display Server                                          #
####################################################################################################

if [[ -z "${DISPLAY}" ]] && [[ -n "${XDG_VTNR}" ]] && (( ${XDG_VTNR} == 1 )); then
	exec xinit
fi
