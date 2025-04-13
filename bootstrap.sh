#!/usr/bin/env bash

packages=$(find . -maxdepth 1 -type d | grep ./ | sed 's/\.\///' | grep -v \\. | tr '\n' ' ')
python dot/dot_local/share/dot/dot.py install $packages
python plug/dot_local/share/plug/plug.py
