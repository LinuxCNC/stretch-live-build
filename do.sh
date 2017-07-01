#!/bin/bash

if [ $(id -u) -ne 0 ]; then exec sudo bash "$0" "$@"; fi

set -eo pipefail

LOCATION="$(dirname $(readlink -f "$0"))"
cd "$LOCATION"

lwr () {
    PYTHONPATH="$LOCATION/live-wrapper${PYTHONPATH+:$PYTHONPATH}" python -c 'import lwr.run; lwr.run.main()' "$@"
}

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
        --customise="$LOCATION/hooks/customise.sh" \
        --kernel=linux-image-rt-$KARCH \
        --preseed=preseed.cfg \
        -t "live-task-base task-xfce-desktop" \
        -e "linux-headers-rt-$KARCH \
            linuxcnc-uspace linuxcnc-uspace-dev linuxcnc-doc-en \
            f-engrave hostmot2-firmware-all mesaflash truetype-tracer \
            bash-completion openssh-server build-essential \
            nopaste mesa-utils" \
        -f "firmware-linux-free \
            hdmi2usb-fx2-firmware nxt-firmware \
            bladerf-firmware-fx3 firmware-b43-installer \
            firmware-b43legacy-installer \
            amd64-microcode atmel-firmware bluez-firmware \
            firmware-amd-graphics firmware-atheros \
            firmware-bnx2 firmware-bnx2x firmware-brcm80211 firmware-cavium \
            firmware-intelwimax \
            firmware-ipw2x00 firmware-iwlwifi firmware-libertas \
            firmware-linux \
            firmware-myricom firmware-netxen firmware-qlogic firmware-realtek \
            firmware-ti-connectivity \
            firmware-zd1211 intel-microcode" \
        --description="Unofficial LinuxCNC 'Stretch' $ARCH Live/Install"
done
