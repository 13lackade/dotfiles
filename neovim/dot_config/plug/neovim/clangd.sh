#!/usr/bin/env bash

rm -rf *
wget https://github.com/clangd/clangd/releases/download/20.1.0/clangd-linux-20.1.0.zip
unzip clangd-linux-20.1.0.zip
mv clangd_20.1.0/* .
rm clangd-linux-20.1.0.zip
rmdir clangd_20.1.0
if [ ! -e ~/.local/bin/clangd ]; then
    ln -s $(pwd)/bin/clangd ~/.local/bin/clangd
fi
