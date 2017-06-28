#!/bin/bash

if [ $(id -u) -ne 0 ]; then exec sudo bash "$0" "$@"; fi

set -eo pipefail

LOCATION="$(dirname $(readlink -f "$0"))"
cd "$LOCATION"

if [ -e env.sh ] ; then . ./env.sh ; fi

if [ $# -eq 0 ] ; then set -- i386 amd64; fi
for ARCH in "$@"; do
    case "$ARCH" in
        i?86) KARCH=686-pae ;;
        *) KARCH="$ARCH" ;;
    esac
    TARGET="$LOCATION/linuxcnc-stretch-uspace-$ARCH.iso"
    lwr -o "$TARGET" \
        --architecture=$ARCH \
        -t "live-task-base task-xfce-desktop \
            task-german-desktop task-spanish-desktop task-finnish-desktop \
            task-hungarian-desktop task-italian-desktop task-japanese-desktop \
            task-polish-desktop task-brazilian-portuguese-desktop \
            task-romanian-desktop task-russian-desktop task-slovak-desktop \
            task-serbian-desktop task-swedish-desktop task-chinese-s-desktop \
            task-chinese-t-desktop" \
        -e "linux-image-rt-$KARCH linux-headers-rt-$KARCH firmware-linux \
            linuxcnc-uspace linuxcnc-uspace-dev hostmot2-firmware-all" \
        --description="Unofficial LinuxCNC 'Stretch' $ARCH Live/Install"
done
