#!/usr/bin/env bash

SHOWING=$([ $(tmux show -g -w status | awk '{print $2}') \== 'on' ] && echo true || echo false)

if $SHOWING; then
    for table in prefix root copy-mode copy-mode-vi; do
        tmux unbind -a -T "$table"
    done
    tmux set -g prefix C-s
    tmux bind C-s run ~/.config/tmux/silent.tmux
    tmux setw -g status off
else
    tmux source-file ~/.config/tmux/tmux.default.conf
    tmux source-file ~/.config/tmux/tmux.conf
    tmux setw -g status on
fi
