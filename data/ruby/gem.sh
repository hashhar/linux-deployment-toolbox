#!/usr/bin/env sh

TMUX_COMP=https://raw.githubusercontent.com/tmuxinator/tmuxinator/master/completion/tmuxinator.bash
curl ${TMUX_COMP} -o ${LOCAL_SRC}/tmuxinator.bash

printf 'source ~/.bin/tmuxinator.bash' >> ${HOME}/.bashrc
