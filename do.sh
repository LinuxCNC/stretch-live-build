#!/bin/bash

if [ $(id -u) -ne 0 ]; then exec sudo bash "$0" "$@"; fi

set -eo pipefail
cd /vms/lw
rm -f live.iso
time env http_proxy=http://localhost:8001/ lwr -t live-task-xfce -e "linux-image-rt-amd64 linux-headers-rt-amd64 firmware-linux" --description="Unofficial LinuxCNC 'Stretch' Live"
