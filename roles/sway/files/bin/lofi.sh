#! /bin/bash

# lofi is a fzf wrapper script for copying passwords from the password
# store folder.
# It is named mockingly after "rofi" due to how simple it is

# Make sure we only have one running
if [[ "$(pgrep lofi.sh --count)" != "1" ]]; then
    pkill lofi.sh --oldest
fi

set -e
PASSWORD_STORE="$HOME/.password-store"

# get all password files and create an array
list_passwords() {
    pw_list=($(find "$PASSWORD_STORE" -name "*.gpg" -printf "%P\n"))
	printf '%s\n' "${pw_list[@]%.gpg}"
}

result="$(list_passwords | fzf --reverse --prompt "Password> ")"

# Show this in the background in case the GPG password prompt is shown
echo "Unlock your password now 🔑"

# Keep this on a separate line so that if GPG pass is cancelled
# the rest of the script won't continue
# TODO: is this a bug or expected behaviour on -e bash scripts?
password="$(pass "$result")"

echo "$password" | head -1 | xclip -selection c

notify-send --app-name=password-store \
" " \
"Copied <b>$result</b> to clipboard 🔑
Password will only paste ONCE"
