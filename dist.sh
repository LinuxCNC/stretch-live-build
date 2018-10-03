#!/bin/bash -xe

if [ $# -ne 1 ]; then echo usage: sh $0 version; exit 1; fi

new=$1

for arch in amd64 i386; do
mv -i linuxcnc-stretch-uspace-$arch.iso dist/linuxcnc-stretch-uspace-$arch-r$new.iso
(cd dist; zsyncmake -u linuxcnc-stretch-uspace-$arch-r$new.iso linuxcnc-stretch-uspace-$arch-r$new.iso)
done
(cd dist; sha256sum linuxcnc-stretch-uspace-*-r$new.iso* > SHA256SUMS-r$new)
(cd dist; md5sum linuxcnc-stretch-uspace-*-r$new.iso* > MD5SUMS-r$new)
#TODO: create SUMS.sign files?
