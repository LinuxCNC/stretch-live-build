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
        -t "live-task-base task-xfce-desktop" \
        -e "linux-image-rt-$KARCH linux-headers-rt-$KARCH \
            linuxcnc-uspace linuxcnc-uspace-dev linuxcnc-doc-en \
            f-engrave hostmot2-firmware-all mesaflash truetype-tracer" \
        -f "dns323-firmware-tools firmware-linux-free \
            hdmi2usb-fx2-firmware nxt-firmware \
            sigrok-firmware-fx2lafw ubertooth-firmware \
            alsa-firmware-loaders \
            bladerf-firmware-fx3 firmware-b43-installer \
            firmware-b43legacy-installer isight-firmware-tools microcode.ctl \
            amd64-microcode atmel-firmware bluez-firmware \
            dahdi-firmware-nonfree firmware-amd-graphics firmware-atheros \
            firmware-bnx2 firmware-bnx2x firmware-brcm80211 firmware-cavium \
            firmware-crystalhd firmware-intel-sound firmware-intelwimax \
            firmware-ipw2x00 firmware-ivtv firmware-iwlwifi firmware-libertas \
            firmware-linux firmware-linux-nonfree firmware-misc-nonfree \
            firmware-myricom firmware-netxen firmware-qlogic firmware-realtek \
            firmware-samsung firmware-siano firmware-ti-connectivity \
            firmware-zd1211 intel-microcode midisport-firmware" \
        --description="Unofficial LinuxCNC 'Stretch' $ARCH Live/Install"
# Note: firmware-ipw2x00 cannot be installed because it requires the user to agree to something during install time
done
