#!/bin/sh

restore() {
	n_active_displays="$(xrandr | awk '/ connected/ && /[0-9]+x[0-9]+\+[0-9]+\+[0-9]+/ { print $1 }' | wc -l)"
	
	if [ "$n_active_displays" -ge "1" ]; then
		return 0
	fi
	
	monitor="$(xrandr | awk '$2 == "connected" {print $1; exit}')"
	
	xrandr --output "$monitor" --preferred
}

if [ "$1" = "loop" ]; then
	while true
	do
		restore
		sleep 5
	done
else
	restore
fi
