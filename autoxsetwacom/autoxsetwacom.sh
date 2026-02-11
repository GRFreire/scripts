#!/bin/sh

# List wacom STYLUS device and set its area to the first monitor, while respection the 16/9 aspect ratio

device_id="$(xsetwacom list devices | grep STYLUS | cut -f2 | cut -d' ' -f2)"

xsetwacom set "$device_id" MapToOutput 1920x1200+0+0
xsetwacom set "$device_id" Area 0 0 15200 8550

