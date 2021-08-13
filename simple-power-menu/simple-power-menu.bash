#!/bin/bash

if [ "$(command -v rofi)" ]; then
    CMD='rofi -dmenu';
elif [ "$(command -v dmenu)" ]; then
    CMD='dmenu';
else
    echo 'Could not find either dmenu or rofi, exiting'
    exit 1;
fi

fn_logout() {
    if [[ $DESKTOP_SESSION =~ ^.*openbox$ ]]; then
        openbox --exit
    elif [[ $DESKTOP_SESSION =~ ^.*i3$ ]]; then
        i3-msg exit
    elif [[ $DESKTOP_SESSION =~ ^.*qtile$ ]]; then
        qtile shell -c 'shutdown()'
    elif [[ $DESKTOP_SESSION =~ ^.*fluxbox$ ]]; then
        killall fluxbox
    elif [[ $DESKTOP_SESSION =~ ^.*bspwm$ ]]; then
        bspc quit 1
    else
        loginctl terminate-session "${XDG_SESSION_ID-}"
    fi
}

OPTIONS=(
    "Shutdown"
    "Reboot"
    "Suspend"
    "Log out"
)

OPTIONS_CMD=(
    "systemctl poweroff"
    "systemctl reboot"
    "systemctl suspend"
    "fn_logout"
)

PROMPT=$(printf "%s\\\\n" "${OPTIONS[@]}")
PROMPT="${PROMPT%??}"

PROMPT_LENGHT="${#OPTIONS[@]}"

CHOICE=$(echo -e "$PROMPT" | $CMD -l "$PROMPT_LENGHT" -p "Power Menu")

if [[ -z $CHOICE ]]; then
    exit 0;
fi

CAN_PROCEDE=0
for i in "${!OPTIONS[@]}"; do
    if [[ "${OPTIONS[$i]}" = "${CHOICE}" ]]; then
        CAN_PROCEDE=1
    fi
done

if [ $CAN_PROCEDE -eq 0 ]; then
    exit 0;
fi

CONFIRMATION_CHOICES="no\nyes"
CONFIRMATION=$(echo -e $CONFIRMATION_CHOICES | $CMD -l 2 -p "Do you want to $CHOICE")

if [ -z "$CONFIRMATION" ]; then
    exit 0;
fi

if [ "$CONFIRMATION" != yes ]; then
    exit 0;
fi

for i in "${!OPTIONS[@]}"; do
    if [[ "${OPTIONS[$i]}" = "${CHOICE}" ]]; then
        ${OPTIONS_CMD[i]}
    fi
done