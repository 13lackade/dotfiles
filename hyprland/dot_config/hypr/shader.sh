#!/usr/bin/env bash

if hyprctl getoption decoration:screen_shader | grep "[[EMPTY]]"; then
    hyprctl keyword decoration:screen_shader "$(dirname $0)/gray.glsl"
else
    hyprctl keyword decoration:screen_shader "[[EMPTY]]"
fi
