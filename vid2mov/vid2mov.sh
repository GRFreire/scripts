#!/bin/sh

notify() {
    if [ "$(command -v notify-send)" ]; then
        notify-send "$@"
    fi
}

VIDEO_PATH=$1
[ "$VIDEO_PATH" = "" ] && echo "error: video_path not given" &&  exit 1

[ "$2" != "" ] && OUT_PATH=$2 || OUT_PATH=${VIDEO_PATH%%.*}.mov

if ffmpeg -i "$VIDEO_PATH" -vcodec mpeg4 -q:v 2 -acodec pcm_s16le -q:a 0 -f mov "$OUT_PATH"; then
    echo "Done"
    notify "vid2mov" "$OUT_PATH done converting"
    exit 0
else
    echo "Failed"
    notify -u critical "vid2mov" "$OUT_PATH error while converting"
    exit 1
fi

