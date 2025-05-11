#!/usr/bin/env bash

packages=$(find . -maxdepth 1 -type d | grep ./ | sed 's/\.\///' | grep -v \\. | tr '\n' ' ')
python3 dot/dot_local/share/dot/dot.py install $packages
python3 plug/dot_local/share/plug/plug.py
