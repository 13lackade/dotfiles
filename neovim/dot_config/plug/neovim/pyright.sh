#!/usr/bin/env bash

rm -rf * .*
npm install pyright
if [ ! -e ~/.local/bin/pyright-langserver ]; then
    ln -s $(pwd)/node_modules/.bin/pyright-langserver ~/.local/bin/pyright-langserver
fi
