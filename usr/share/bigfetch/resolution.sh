#!/usr/bin/env bash

if type -p xrandr >/dev/null && [[ $DISPLAY && -z $WAYLAND_DISPLAY ]]; then
    resolution="$(xrandr --nograb --current |\
    awk -F 'connected |\\+|\\(' \
            '/ connected.*[0-9]+x[0-9]+\+/ && $2 {printf $2 ", "}')"
    resolution="${resolution/primary, }"
    resolution="${resolution/primary }"

    resolution="${resolution//\*}"

elif type -p xwininfo >/dev/null && [[ $DISPLAY && -z $WAYLAND_DISPLAY ]]; then
    read -r w h \
        <<< "$(xwininfo -root | awk -F':' '/Width|Height/ {printf $2}')"
    resolution="${w}x${h}"

elif type -p xdpyinfo >/dev/null && [[ $DISPLAY && -z $WAYLAND_DISPLAY ]]; then
    resolution="$(xdpyinfo | awk '/dimensions:/ {printf $2}')"

elif [[ -d /sys/class/drm ]]; then
    for dev in /sys/class/drm/*/modes; do
        read -r resolution _ < "$dev"

        [[ $resolution ]] && break
    done

fi

resolution="${resolution%,*}"
[[ -z "${resolution/x}" ]] && resolution=

echo $resolution
