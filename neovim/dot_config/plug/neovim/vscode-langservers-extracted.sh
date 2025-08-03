#!/usr/bin/env bash

rm -rf * .*
npm install vscode-langservers-extracted 
for cmd in $(ls node_modules/.bin); do
    if [ ! -e ~/.local/bin/$cmd ]; then
        ln -s $(pwd)/node_modules/.bin/$cmd ~/.local/bin/$cmd
    fi
done
