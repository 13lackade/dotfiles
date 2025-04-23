#!/usr/bin/env bash

wget https://github.com/latex-lsp/texlab/releases/latest/download/texlab-x86_64-linux.tar.gz
tar xzf texlab-x86_64-linux.tar.gz
rm texlab-x86_64-linux.tar.gz
if [ ! -e ~/.local/bin/texlab ]; then
    ln -s $(pwd)/texlab ~/.local/bin/texlab
fi
