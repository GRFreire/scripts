#!/bin/sh

if [ "$(command -v rofi)" ]; then
    CMD='rofi -dmenu -i';
elif [ "$(command -v dmenu)" ]; then
    CMD='dmenu';
else
    echo 'Could not find either dmenu or rofi, exiting'
    exit 1;
fi

# $1 - monitor name
#
# return "WIDTH1xHEIGTH1\nWIDTH2xHEIGTH2\n..."
get_monitor_sizes() {
	xrandr | awk -v monitor="$1" \
		'$1 == monitor { display=1; next } /^[A-Z]/ { display=0 } display { print $1 }'
}

# $1 - monitor name
#
# return xrandr "--mode WIDTHxHEIGTH" or "--preferred"
monitor_config() {
	sizes="$(get_monitor_sizes "$1")"
	if [ "$1" = "eDP-1" ]; then
		DISPLAY_CONFIGS="Preferred\n$sizes"
	else
		DISPLAY_CONFIGS="$sizes"
	fi

	CONFIG="$(echo "$DISPLAY_CONFIGS" | $CMD -p "Monitor $1 config" | xargs)"

	case "$CONFIG" in
		Preferred)
			echo "--preferred"
			return
			;;
		"")
			exit 1
			;;
		*)
			echo "--mode $CONFIG"
			return
			;;
	esac
}

# return "eDP-1\nHDMI-1\n..."
get_monitors() {
	xrandr | awk '$2 == "connected" {print $1}'
}

monitors="$(get_monitors)"
n_monitors="$(echo "$monitors" | wc -l)"

if [ "$n_monitors" -eq "1" ]; then
	config="$(monitor_config "$monitors")" || exit 1
	# shellcheck disable=SC2086
	xrandr --output "$monitors" $config
elif [ "$n_monitors" -eq "2" ]; then
	DISPLAY_ARRANGEMENTS="Join\nMirror\nOnly"
	N_ARRANGEMENTS="$(echo $DISPLAY_ARRANGEMENTS | wc -l)"
	ARRANGEMENT="$(echo "$DISPLAY_ARRANGEMENTS" | $CMD -l "$N_ARRANGEMENTS" -p "Display arrangement" | xargs)"

	case "$ARRANGEMENT" in
		Join)
			args=""

			prev_monitor=""
			for monitor in $(get_monitors); do
				position=""
				if [ "$prev_monitor" != "" ]; then
					POSITIONS="right-of\nleft-of\nabove\nbelow"
					N_POSITIONS=4
					position_flag="$(echo "$POSITIONS" | $CMD -l "$N_POSITIONS" -p "Select position" | xargs)"
					if [ "$position_flag" = "" ]; then exit 1; fi

					position="--$position_flag $prev_monitor"
				fi
				config="$(monitor_config "$monitor")" || exit 1
				args="$args --output $monitor $config $position"
				prev_monitor="$monitor"
			done
			# shellcheck disable=SC2086
			xrandr $args
			;;
		Mirror)
			args=""

			prev_monitor=""
			for monitor in $(get_monitors); do
				config="$(monitor_config "$monitor")" || exit 1
				args="$args --output $monitor $config"
				if [ "$prev_monitor" != "" ]; then
					args="$args --same-as $prev_monitor"
				fi
				prev_monitor="$monitor"
			done
			# shellcheck disable=SC2086
			xrandr $args
			;;
		Only)
			monitors="$(get_monitors)"
			n_monitors="$(echo "$monitors" | wc -l)"
			monitor="$(echo "$monitors" | $CMD -l "$n_monitors" -p "Select monitor" | xargs)"
			if [ "$monitor" = "" ]; then exit 1; fi
			config="$(monitor_config "$monitor")" || exit 1

			args=""
			for monitor_i in $monitors; do
				if [ "$monitor_i" = "$monitor" ]; then
					args="$args --output $monitor_i $config"
				else
					args="$args --output $monitor_i --off"
				fi
			done
			# I do want word splitting for argument config
			# shellcheck disable=SC2086
			xrandr $args
			;;
		*)
			exit 0
			;;
	esac
else
	arandr
fi

