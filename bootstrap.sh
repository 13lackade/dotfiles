#!/usr/bin/env bash

mkdir -p ~/.local/share/dotfiles/deno
pushd ~/.local/share/dotfiles/deno
~/.dotfiles/deno/dot_config/plug/deno/deno.sh
popd

export PATH="$PATH:$HOME/.local/bin"
~/.dotfiles/scripts/dot_local/bin/dot
~/.dotfiles/scripts/dot_local/bin/plug
