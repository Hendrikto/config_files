# Documentation: `man 1 python` (PYTHONSTARTUP)

# Documentation: https://docs.python.org/3/library/site.html#rlcompleter-config
# Documentation: https://docs.python.org/3/library/readline.html

import sys


def register_readline():
    import atexit
    import os
    import readline
    import rlcompleter
    from pathlib import Path

    # Reading the initialization (config) file may not be enough to set a completion key, so we set
    # one first and then read the file.
    readline.parse_and_bind('tab: complete')

    try:
        readline.read_init_file()
    except OSError:
        # An OSError here could have many causes, but the most likely one is that there's no
        # .inputrc file. In that case, we want to ignore the exception.
        pass

    if readline.get_current_history_length() == 0:
        # If no history was loaded, default to $XDG_STATE_HOME/python/history. The guard is
        # necessary to avoid doubling history size at each interpreter exit when readline was
        # already configured through a PYTHONSTARTUP hook, see:
        # http://bugs.python.org/issue5845#msg198636
        cache_home = Path(os.environ.get('XDG_STATE_HOME', '~/.local/state')).expanduser()
        history = cache_home / 'python/history'

        try:
            readline.read_history_file(history)
        except OSError:
            pass

        def write_history():
            try:
                os.makedirs(history.parent, exist_ok=True)
                readline.write_history_file(history)
            except OSError:
                # bpo-19891, bpo-41193: Config home directory does not exist or is not writable, or
                # the filesystem is read-only.
                pass

        atexit.register(write_history)


sys.__interactivehook__ = register_readline
del register_readline
