#! /usr/bin/bash

# Exit on any failure
set -e

OUTPUT_FORMAT="mkv"
WF_RECORDER_PATH="$HOME/bin/wf-recorder"

if [[ ! -f "$WF_RECORDER_PATH" ]]; then
    notify-send "wf-recorder is not installed on this machine"
    exit 1
fi

if [[ "$1" == "start" ]]; then
    location="$HOME/Videos/$(date "+%Y-%m-%d_%H-%M-%S").$OUTPUT_FORMAT"
    notify-send "$(echo -e "Starting recording. Will save to:\n$location")"

    if [[ "$2" == "-g" ]]; then
        dimensions="$(slurp)"
        "$WF_RECORDER_PATH" -g "$dimensions" -f "$location"
    else
        "$WF_RECORDER_PATH" -f "$location"
    fi


elif [[ "$1" == "stop" ]]; then
    if killall wf-recorder; then
        notify-send "Video saved to $HOME/Videos"
    else
        notify-send "No video recording in progress"
    fi
fi
