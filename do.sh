#!/bin/bash

if [ $(id -u) -ne 0 ]; then exec sudo bash "$0" "$@"; fi

set -eo pipefail

LOCATION="$(dirname $(readlink -f "$0"))"
cd "$LOCATION"

if [ -e env.sh ] ; then . ./env.sh ; fi

if [ $# -eq 0 ] ; then set -- i386 amd64; fi
for ARCH in "$@"; do
    ARCH0="$ARCH"
    case "${ARCH%%-*}" in
        i?86) KARCH=686-pae ;;
        *) KARCH="$ARCH" ;;
    esac
    TASK="task-xfce-desktop"
    FIRMWARE="firmware-linux"
    EXTRA="linuxcnc-uspace-dev linux-headers-rt-$KARCH \
        hostmot2-firmware-all f-engrave mesaflash truetype-tracer"
    while [ "${ARCH%-*}" != "${ARCH}" ]; do
        case "$ARCH" in
            *-dfsg)
                ARCH=${ARCH%-dfsg};
                FIRMWARE=firmware-linux-free
            ;;
            *-min)
                ARCH=${ARCH%-min}
                EXTRA=""
                TASK="tasksel \
                    xorg xserver-xorg-video-all xserver-xorg-input-all \
                    desktop-base lightdm xfce4 xfce4-terminal mousepad \
                    default-dbus-session-bus"
            ;;
            *-l10n)
                ARCH=${ARCH%-l10n}
                EXTRA="$EXTRA \
                    task-german-desktop task-spanish-desktop \
                    task-finnish-desktop task-hungarian-desktop \
                    task-italian-desktop task-japanese-desktop \
                    task-polish-desktop task-brazilian-portuguese-desktop \
                    task-romanian-desktop task-russian-desktop \
                    task-slovak-desktop task-serbian-desktop \
                    task-swedish-desktop task-chinese-s-desktop \
                    task-chinese-t-desktop"
            ;;
            *-l10n-full)
                ARCH=${ARCH%-l10n-full}
                TASK=live-task-xfce
            ;;
            *)
                echo 1>&2 "Unknown variant requested: ${ARCH#*-}"
                exit 1
            ;;
        esac
    done
    TARGET="$LOCATION/linuxcnc-stretch-uspace-$ARCH0.iso"
    lwr -o "$TARGET" \
        --architecture=$ARCH \
        -t "$TASK" \
        -e "linux-image-rt-$KARCH \
            $FIRMWARE \
            linuxcnc-uspace
            $EXTRA" \
        --description="Unofficial LinuxCNC 'Stretch' $ARCH0 Live/Install"
done
