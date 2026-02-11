#!/bin/sh

DEVICE="/org/freedesktop/UPower/devices/battery_BAT0"

time="$(upower -i $DEVICE | grep time | cut -d':' -f2 | tr -s ' ' | cut -c2-)"
perc="$(upower -i $DEVICE | grep percentage | awk '{print $2}' | tr -d '%')"
stat="$(upower -i $DEVICE | grep state | awk '{print $2}')"

if [ "$stat" = "charging" ]; then
	exit 0
fi

if [ "$perc" -le "20" ]; then
    urgency="normal"
    if [ "$perc" -le "10" ]; then
        urgency="critical"
    fi
    notify-send -u "$urgency" --icon="battery" "Battery is low ($perc%)" "Time remaining is $time."
    mpv /usr/share/sounds/freedesktop/stereo/dialog-information.oga
fi

