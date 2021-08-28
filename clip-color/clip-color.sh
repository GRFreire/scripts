#!/bin/sh

notify() {
    if [ "$(command -v notify-send)" ]; then
        notify-send "$@"
    fi
}

COLOR="$(colorpicker --short --one-shot --preview)"

printf "%s" "$COLOR" | xclip -selection clipboard
notify "clip-color" "Color $COLOR copied!"
