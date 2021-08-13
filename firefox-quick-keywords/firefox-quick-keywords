#!/bin/sh

if [ "$(command -v rofi)" ]; then
    CMD='rofi -dmenu';
elif [ "$(command -v dmenu)" ]; then
    CMD='dmenu';
else
    echo 'Could not find either dmenu or rofi, exiting'
    exit 1;
fi


# Copy the firefox database
DB='/tmp/places.sqlite'
cp ~/.mozilla/firefox/*.default-release/places.sqlite $DB

# SQL
QUERY="SELECT moz_keywords.keyword, moz_places.url FROM moz_keywords left JOIN moz_places ON place_id=moz_places.id WHERE moz_places.url<>'' AND moz_keywords.keyword<>''"
OPTIONS=$(sqlite3 $DB "$QUERY" | awk -F "|" '{print "["$1"] - "$NF}')

# Clean tmp
rm $DB

# Prompt:
CHOICE=$(echo "$OPTIONS" | $CMD -p "Firefox quick open:")

# Check choice
URL=$(echo "$CHOICE" | awk '{print $NF}') || exit 1
VALID=$(echo "$OPTIONS" | grep "$URL")
if [ -n "$VALID" ] && [ -n "$CHOICE" ]; then
    firefox "$URL"
    exit 0
else
    exit 1
fi
