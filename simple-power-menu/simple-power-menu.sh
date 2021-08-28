#!/bin/sh

if [ "$(command -v rofi)" ]; then
    CMD='rofi -dmenu';
elif [ "$(command -v dmenu)" ]; then
    CMD='dmenu';
else
    echo 'Could not find either dmenu or rofi, exiting'
    exit 1;
fi

fn_logout() {
    case "$DESKTOP_SESSION" in
        *openbox*) openbox --exit;;
        *i3*) i3-msg exit;;
        *qtile*) qtile shell -c 'shutdown()';;
        *fluxbox*) killall fluxbox;;
        *bspwm*) bspc quit 1;;
        *) loginctl terminate-session "${XDG_SESSION_ID-}";;
    esac
}

OPTIONS="\
Shutdown    \tsystemctl poweroff
Reboot      \tsystemctl reboot
Suspend     \tsystemctl suspend
Lockscreen  \tbetterlockscreen -l dimblur
Log out     \tfn_logout"

PROMPT="$(echo "$OPTIONS" | awk -F"\t" '{print $1}')"

PROMPT_LENGHT="$(echo "$PROMPT" | wc -l)"

CHOICE="$(echo "$PROMPT" | $CMD -l "$PROMPT_LENGHT" -p "Power Menu" | xargs)"

if [ -z "$CHOICE" ]; then
    exit 0;
fi

COMMAND="$(echo "$OPTIONS" | grep "$CHOICE" | awk -F"\t" '{print $2}')"

if [ -z "$COMMAND" ]; then
    exit 0;
fi

CONFIRMATION_CHOICES="no\nyes"
CONFIRMATION="$(echo $CONFIRMATION_CHOICES | $CMD -l 2 -p "Do you want to $CHOICE")"

if [ -z "$CONFIRMATION" ]; then
    exit 0;
fi

if [ "$CONFIRMATION" != yes ]; then
    exit 0;
fi

$COMMAND
