#! /usr/bin/bash

# Exit on any failure
set -e

location="$HOME/Pictures/$(date "+%Y-%m-%d_%H-%M-%S").png"

# Take a screenshot with clipper tool (slurp)
if [[ "$1" == "-g" ]]; then
    dimensions="$(slurp -d)"
    grim -g "$dimensions" "$location"

# Take a screenshot of the current window
elif [[ "$1" == "-w" ]]; then
    rect="$(swaymsg -t get_tree | jq '.. | select(.focused?) | .rect')"
    x="$(jq '.x' <<< "$rect")"
    y="$(jq '.y' <<< "$rect")"
    width="$(jq '.width' <<< "$rect")"
    height="$(jq '.height' <<< "$rect")"
    grim -g "${x},${y} ${width}x${height}" "$location"

# Take a screenshot of the entire screen
else
    grim "$location"
fi

notify-send -i "$location" "Screenshot saved to $(realpath $location --relative-to=$HOME)"
