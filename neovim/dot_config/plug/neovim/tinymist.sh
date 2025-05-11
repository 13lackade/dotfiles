#!/usr/bin/env bash

wget https://github.com/latex-lsp/texlab/releases/latest/download/texlab-x86_64-linux.tar.gz
wget https://github.com/Myriad-Dreamin/tinymist/releases/latest/download/tinymist-x86_64-unknown-linux-gnu.tar.gz
tar xzf tinymist-x86_64-unknown-linux-gnu.tar.gz
rm tinymist-x86_64-unknown-linux-gnu.tar.gz
if [ ! -e ~/.local/bin/tinymist ]; then
    ln -s $(pwd)/tinymist-x86_64-unknown-linux-gnu/tinymist ~/.local/bin/tinymist
fi
