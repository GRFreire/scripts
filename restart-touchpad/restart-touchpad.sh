#!/bin/sh

id="$(xinput list | grep Touchpad | cut -f 2 | sed 's/id=//')"

xinput disable "$id"
sleep 1
xinput enable "$id"

# $1 prop name
get_prop() {
    name="$1 ("
    xinput list-props "$id" | grep "$name" | sed 's/.*(\(.*\)):.*/\1/'
}

# Set NaturalScrolling
prop="$(get_prop 'Synaptics Scrolling Distance')"
xinput set-prop "$id" "$prop" -93, -93

# Set Tap to Click
prop="$(get_prop 'Synaptics Tap Action')"
xinput set-prop "$id" "$prop" 1, 1, 1, 2, 1, 3

# Enable Horizontal and Vertical Two-Finger scrolling
prop="$(get_prop 'Synaptics Two-Finger Scrolling')"
xinput set-prop "$id" "$prop" 1, 1

if [ "$1" = "--notify" ]; then
	notify-send -u "low" --icon="input-touchpad" "Restarting touchpad"
fi
