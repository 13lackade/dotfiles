#!/usr/bin/env bash

SESSION_NAME="ghostty"

if tmux has-session -t $SESSION_NAME &>/dev/null; then
    exec tmux attach-session -t $SESSION_NAME
else
    tmux new-session -s $SESSION_NAME
    exec tmux attach-session -t $SESSION_NAME
fi
