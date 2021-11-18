#! /usr/bin/bash
swaynag \
    -b 'logout' 'swaymsg exit' \
    -b 'shutdown' 'systemctl poweroff' \
    -b 'reboot' 'systemctl reboot' --type poweroff
