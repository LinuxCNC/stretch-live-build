#!/bin/bash -xe
# Run this script on wlo to download a new set of images from the builder
# NOTE: zsync requires a http URL -- https doesn't work :(
baseurl=http://zaphod.unpythonic.net/lw
#cd "$HOME/www.linuxcnc.org/stretch" # soon
cd "$HOME/www.linuxcnc.org/testing-stretch-rtpreempt"

if [ $# -ne 1 ]; then echo "Usage: sh $0 version"; fi

new=$1
old=$((new-1))

for arch in i386 amd64; do
    o="linuxcnc-stretch-uspace-$arch-r$old.iso"
    if ! [ -e "$o" ]; then o=/dev/null; fi
    zsync -i "$o" -k "linuxcnc-stretch-uspace-$arch-r$new.iso.zsync" \
        "$baseurl/linuxcnc-stretch-uspace-$arch-r$new.iso.zsync"
done
wget -O SHA256SUMS-r$new "$baseurl/SHA256SUMS-r$new"
wget -O MD5SUMS-r$new "$baseurl/MD5SUMS-r$new"
sha256sum --check "SHA256SUMS-r$new"
chmod 444 *.iso *.zsync *SUMS-r*
for arch in i386 amd64; do
    ln -sf linuxcnc-stretch-uspace-$arch-r$new.iso.zsync linuxcnc-stretch-uspace-$arch.iso.zsync
    ln -sf linuxcnc-stretch-uspace-$arch-r$new.iso linuxcnc-stretch-uspace-$arch.iso
done
sed s/-r$new// < SHA256SUMS-r$new > SHA256SUMS
sed s/-r$new// < MD5SUMS-r$new > MD5SUMS
