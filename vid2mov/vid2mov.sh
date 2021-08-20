#!/bin/sh

usage() {
cat << EOF  
Usage: vid2mov -i [input_file] {-o [output_file]} {-y}

-h                Show this help.

-i                Specify input_file.

-o                Specify output_file. Default to input_file with .mov extension.

-y                Pass the -y flag to ffmpeg.
EOF
}

notify() {
    if [ "$(command -v notify-send)" ]; then
        notify-send "$@"
    fi
}


VIDEO_PATH=""
OUT_PATH=""
CONFIRMATION=""

while getopts "hi:o::y" ARG; do
    case $ARG in
        i) VIDEO_PATH=$OPTARG;;
        o) OUT_PATH=$OPTARG;;
        y) CONFIRMATION="-y";;
        h | *) usage ; exit 0;;
    esac
done

[ "$VIDEO_PATH" = "" ] && echo "error: video_path not given" && usage &&  exit 1
[ "$OUT_PATH" = "" ] && OUT_PATH=${VIDEO_PATH%%.*}.mov

if ffmpeg -i "$VIDEO_PATH" -vcodec mpeg4 -q:v 2 -acodec pcm_s16le -q:a 0 -f mov "$OUT_PATH" $CONFIRMATION; then
    echo "Done"
    notify "vid2mov" "$OUT_PATH done converting"
    exit 0
else
    echo "Failed"
    notify -u critical "vid2mov" "$OUT_PATH error while converting"
    exit 1
fi

