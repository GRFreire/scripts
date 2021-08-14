#!/bin/sh

EMOJI_LIST="$HOME/.scripts/clip-moji/emoji-list"

if [ "$(command -v rofi)" ]; then
    LAUNCHER_CMD='rofi -dmenu';
elif [ "$(command -v dmenu)" ]; then
    LAUNCHER_CMD='dmenu';
else
    echo 'Could not find either dmenu or rofi, exiting'
    exit 1;
fi

if [ "$(command -v xclip)" ]; then
    CLIPBOARD_CMD='xclip -selection clipboard';
elif [ "$(command -v wl-copy)" ]; then
    CLIPBOARD_CMD='wl-copy';
else
    echo 'Could not find either xclip or wl-copy, exiting'
    exit 1;
fi

EMOJI=$(cut -d';' -f1 "$EMOJI_LIST" | $LAUNCHER_CMD -i | cut -d' ' -f1)

[ -z "$EMOJI" ] && exit

printf "%s" "$EMOJI" | $CLIPBOARD_CMD
