#! /bin/bash

# Launch Git Projects quickly
set -e

list_directories() {
    pw_list=($(find "$HOME" -name ".git" -type d -printf "%P\n" ))
	printf '%s\n' "${pw_list[@]%.git}"
}

result="$HOME/$(list_directories | fzf --reverse --prompt "Git Project> ")"

kitty --directory "$result" --detach
