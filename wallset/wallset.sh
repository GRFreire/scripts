#!/bin/sh

notify() {
    if [ "$(command -v notify-send)" ]; then
        notify-send "$@"
    fi
}

IMAGE="$1"
WALLPAPER="$HOME/.config/wall.png"

echo "Converting image..."
convert "$IMAGE" "$WALLPAPER" > /dev/null

echo "Setting wallpaper..."
feh --bg-scale "$WALLPAPER" > /dev/null

generate_lockscreen() {
    if betterlockscreen -u "$WALLPAPER" > /dev/null; then
        notify "wallset" "Lockscreen generated!"
    else
        notify --urgency critical "wallset" "Error while generating lockscreen"
    fi
}
echo "Generating lockscreen in the background..."
generate_lockscreen &

echo "Done!"
