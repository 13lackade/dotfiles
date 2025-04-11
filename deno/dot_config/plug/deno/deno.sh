#!/usr/bin/env bash

rm -rf *
wget https://github.com/denoland/deno/releases/download/v2.2.8/deno-x86_64-unknown-linux-gnu.zip
unzip deno-x86_64-unknown-linux-gnu.zip
rm deno-x86_64-unknown-linux-gnu.zip
if [ ! -e ~/.local/bin/deno ]; then
    ln -s $(pwd)/deno ~/.local/bin/deno
fi
