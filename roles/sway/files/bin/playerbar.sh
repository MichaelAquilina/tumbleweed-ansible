#! /usr/bin/bash
# Display appropriate metadata on waybar

artist="$(playerctl metadata -f "{{artist}}")"
album="$(playerctl metadata -f "{{album}}")"

output="$(playerctl metadata -f '[{{status}}]  <b>{{title}}</b>')"
output="$(printf "$output" | sed 's/\[Playing\]//')"
output="$(printf "$output" | sed 's/\[Paused\]//')"

# Replace & with &amp; to prevent markdown errors
output="$(printf "$output" | sed 's/\&/\&amp;/')"

if [[ -n "$artist" ]]; then
    output="$output by <i>$artist</i>"
fi

if [[ -n "$album" ]]; then
    output="$output from <i>$album</i>"
fi

if [[ "$output" != "[Stopped]"* ]]; then
    printf "$output"
else
    printf "No song playing"
fi
