#!/bin/sh

id="$(xinput list | grep Touchpad | cut -f 2 | sed 's/id=//')"

xinput disable "$id"
xinput enable "$id"

# Set NaturalScrolling
xinput set-prop "$id" 382 -93, -93

# Set Tap to Click
xinput set-prop "$id" 389 1, 1, 1, 2, 1, 3

# Enable Horizontal and Vertical Two-Finger scrolling
xinput set-prop "$id" 384 1, 1
