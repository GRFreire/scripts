#!/bin/sh

id="$(xprop | grep WM_CLIENT_LEADER | cut -d' ' -f5)"
xdg-screensaver suspend "$id"
