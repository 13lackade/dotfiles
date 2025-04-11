#!/usr/bin/env bash

rm -rf * .*
deno init
echo '{nodeModulesDir: "auto"}' > deno.json
deno install npm:pyright
if [ ! -e ~/.local/bin/pyright-langserver ]; then
    ln -s $(pwd)/node_modules/.bin/pyright-langserver ~/.local/bin/pyright-langserver
fi
