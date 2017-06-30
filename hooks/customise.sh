#!/bin/bash

set -e
set -x
rootdir=$1

# common needs rootdir to already be defined.
. /usr/share/vmdebootstrap/common/customise.lib

cleanup() {
    umount -l ${rootdir}/proc
    umount -l ${rootdir}/sys
}

trap cleanup 0

mount_support
disable_daemons

mv ${rootdir}/etc/resolv.conf ${rootdir}/etc/resolv.conf.bak
cat /etc/resolv.conf > ${rootdir}/etc/resolv.conf

prepare_apt_source "${LWR_MIRROR}" "${LWR_DISTRIBUTION}"

for PKG in ${LWR_FIRMWARE_PACKAGES}; do
    echo "$PKG        $PKG/license/accepted       boolean true" | \
       chroot ${rootdir} debconf-set-selections
done

cat > ${rootdir}/etc/apt/trusted.gpg.d/linuxcnc.asc <<EOF
-----BEGIN PGP PUBLIC KEY BLOCK-----

mQGiBEgFHDERBADSc677XNT6wR5V78fE3KS+zOkvSepsX5ndWcO6Q+vbMxEnV7Tt
xUi3bc8pD9fTcT819S7U2uduRWW4BGywNeu70Y257EnD/ECXpZBpF0Bztm66O/jO
wWK0QMa3blKSjMc2/axD9FzXNhI7qcEkq/eCiLwotgtfbj1MuwgGQQ3nfwCg3hZg
dCmfkVi2edymEsLz/nhGOxsD/1yKcGCE0udyyWkmkAWSXsF+f2DzuCZ9N6Ct0mmA
P6gJgsVOfqwhr/xsSnN+53MVhjMYwFtF73t/CCr9qiuGwasXwfJIcQZY5GN9IhDC
0vt4sF9D5h6ZOUoxAYgRp2f9s43/9rq+pA7nAgUa0WhQtsGkFDAlwS9EGwaUSYoC
6BLaA/96fmkvpi4+PgM8BbXKQPeTOj+Ytr6JQOBOMVmwEw8av86V49LN773yuCte
f8jb9+CaI59pbZDcjww3yxxg+kLRwucmVqv7wtoqkLkyIODRjUvWLEJAvtaBMiGy
9WxJngseG5jgQZxX3yecszx67uUAvnC8/G9QdCzQDCUGYYGGDbQwRU1DIEFyY2hp
dmUgU2lnbmluZyBLZXkgPGVtYy1ib2FyZEBsaW51eGNuYy5vcmc+iGAEExECACAF
AkgFHDECGwMGCwkIBwMCBBUCCAMEFgIDAQIeAQIXgAAKCRA8uf0UjzdP76GQAJ9C
fC9tHwwEkTNx9NO9GWjT71jwzACglp6ZZJQRYRjM1isMbSCr1rHNa4a5Ag0ESAUc
ORAIAKaIHB7Oimk00u7hKBzKuBP3nY3QaAFDdriAOeMYo6TNEw1csWuO24DU7RPx
1R7m3nwmwHMJMeww4FT69PbmrADfpdaQUo6MMgkQOwCa6R787ss7aPVbzNs/xgQD
XtrgBpdxrGJElthsCWKcilq6MhGeyvZ8Da89piA8110sweKvsfZqoi9fdnIj84g9
b/l2VKc9u5XoRohypTX12cQQeBo6W0tAc+tEyOmZ+pojOUk+QTyOktxY9YT01QcW
y5RLRaohZ1x6Yg/0rEtYbb6CRJo2DWbLcPovIOWhxlw4YvW7lveY9GW1mFL2jRV5
OGmIsWDntw+ldIZnY8JKAkCdVdsAAwUH/3RB3NL4OJCXL3Dd7N6MsY4JfBrPgLSC
mzi4UteV8uXhq8DblNwdNBtSCFSRuT+OfJfBh8odL1jhTdBXYZLMeOV5gz5PsPYH
HlBRBBSVN1T1ahyF0TW9kyt8bh4pDGdttWoKiOYRpa7Oyt1ZmBeE8JAX3LQ8M35h
xswLEyRUnLYjFWeTf3sciwB+gr6Me+8aEdinsR1ws71doha1qlT0gTC02RiuHLGy
78QuyY7jdMUpbdp5HOKcLVL95ArENi5Q8QfCWJ5jsLkApbcmFWY50080Cr4qqI+E
iy9W/RSUy8duEuplv1c4hbW3/xxIGFeLP2CD9aIXUHsdjRCi9uYP8+2ISAQYEQIA
CQUCSAUcOQIbDAAKCRA8uf0UjzdP78McAJiGYVn3U1XDdMU9ygQnK4WVGjX+AKDd
JPvLQAZ5o/MIX+m6jYQwqT/aYw==
=Th6o
-----END PGP PUBLIC KEY BLOCK-----
EOF

cat > ${rootdir}/etc/apt/trusted.gpg.d/linuxcnc-buildbot.asc <<EOF
-----BEGIN PGP PUBLIC KEY BLOCK-----

mQENBFOs6ncBCACnjDY9KAwbdKP2KCe7uhZcIGWRmsJopcJWFvNRhHwV2LnBdcwn
kLfpRfCkINT09rrM8Yoj3HKeenK3vUo/vMYguF0vYZj4c7fHgulJ0rdpy5Or9ID4
7R5ecJYVpXvzZTWXyutEry+jYgFAaJCmFgEl8eE7Q8XIQgAYD9SSlzecUv1g+9vL
aj2QN9XaIaXkydBUhYEsut2qFlgyx2b0QVp/Gs4DY1mKS9plXDnRi75ySC3Ia9YG
jzsPQ99lchmjvY0ZdJfzyH2OmYOV4lku6SqEoI1k+2NIGO1VZh7PojlvrwvkueKT
VbfNMwcbTkMPK9dk0g8KPz0v2E1x8Xl+prv9ABEBAAG0J0xpbnV4Q05DIEJ1aWxk
Ym90IDxub21haWxAbGludXhjbmMub3JnPokBOAQTAQIAIgUCU6zqdwIbAwYLCQgH
AwIGFQgCCQoLBBYCAwECHgECF4AACgkQ7xsH/uDuZj7xXQf7BReuIUw+Gg6WrUKx
Iq6d/CQpUSIxvRgcEDyyXmqLthtdrOWNtb+a9C3IwBT8nVxBxcS+3sRorCfZ+GXU
iAafFpAV0LiopVITYY/ibMkfHdif5MV9XXMN2Hex45gLQBWEKMLtvf6xGhaJ8sFW
gkVkOOYMQ3bBsNbLgK1XGmIwW3NXNsTo1Y6KyMjcovUBdRVugANWsSRS0Y9n6Ysv
uXAsascHljf2daU6mXA6ot/rw+YfhgzMkSIzmfdlSl1njZNPIK2auHq8tSrKXe1p
pSpizjR91B9Zrx3171ACWb6kc6ylLKnHylPnfLGMSZVyadBsVLYyhMGzd3JuzfnP
0qQi5bkBDQRTrOp3AQgA3u/h97fcryMkclLWiGsWt6jmIQE2k5YWHqntFuSymish
f29gSP2aczW+EGrcK/12+q7qDXLfGWoXxOOY+ziNyR+6tUzCsTbqb2Pr8T3pUx1X
49MCC3K9H1g1B67b5G+IXPnLpyfWb7CH0kHZ6rFfX/yuo7KNhbcEtj+SRe/1uCy7
ItcS+4ylDaEEFNLkQyRnuw74WdjTJOmppZonG2w1dPvCGwaBnCHGdFLg+BjZx/XZ
5ZYJozxgD3hhmg5LUvTrZcf3CKzi0NpQFj7YwGbu/rlbo066VNCC51Qkua58Fr1k
6dcj3aeaxBfWdQxU8NE+g+C3L9UQnmHAfucRUnjm6QARAQABiQEfBBgBAgAJBQJT
rOp3AhsMAAoJEO8bB/7g7mY+sEwH/jOsjCGu3n5SPmMkQvYZjot7OLm0cGz20t6V
A1j4yoJEjvToFNbSNYaWMu7sWZ+rf2zKvRFOUPy5yBuaKIOJiUc7VLQsL6c6iwhO
yj+sAaLikk9DLRQJE0drxQQsq0abumnpi5UJwbUJSIDRe4zlFWOxOgaWxVYwALnl
dUqV2RV4UdXKArbBOEw5avVrUrmQg8IrC4KWO94rcErPOgK7S9c8zsARKdBSZABJ
eaEfQrPO6Fqqc3WHtjQ/KIVF3iJyJxAI8MfNlnejIlIc0ulnQ7Btyuleo6zoCikJ
y9wrl8IUhViDfuiHeaVG2tHX6bEdMAey9rPGHO7z+/i4VYj7X2s=
=/Sew
-----END PGP PUBLIC KEY BLOCK-----
EOF

cat > ${rootdir}/etc/apt/sources.list.d/updates.list <<EOF
deb http://ftp.debian.org/debian stretch-updates main contrib non-free
deb http://security.debian.org/debian-security stretch/updates main
EOF

cat > ${rootdir}/etc/apt/sources.list.d/linuxcnc.list <<EOF
deb http://linuxcnc.org/ stretch base
#deb-src http://linuxcnc.org/ stretch base
#deb http://linuxcnc.org/ stretch 2.7-uspace
#deb-src http://linuxcnc.org/ stretch 2.7-uspace
deb http://buildbot.linuxcnc.org/ stretch 2.7-rtpreempt
#deb-src http://buildbot.linuxcnc.org/ stretch 2.7-rtpreempt
EOF

chroot ${rootdir} apt-key list
chroot ${rootdir} apt update

chroot ${rootdir} apt -y install initramfs-tools live-boot live-config ${LWR_TASK_PACKAGES} ${LWR_EXTRA_PACKAGES} ${LWR_FIRMWARE_PACKAGES} task-laptop task-english libnss-myhostname

chroot ${rootdir} apt -y remove linux-image-4.9.0-3-686 || true
chroot ${rootdir} apt -y remove linux-image-4.9.0-3-amd64 || true

# Temporary fix for #843983
chroot ${rootdir} chmod 755 /

chroot ${rootdir} mkdir -p /etc/skel/.config/autostart
if [ -e ${rootdir}/etc/xdg/autostart/light-locker.desktop ]; then
chroot ${rootdir} desktop-file-install --dir=/etc/skel/.config/autostart --set-key=Hidden --set-value=true /etc/xdg/autostart/light-locker.desktop
fi

echo "blacklist bochs-drm" > $rootdir/etc/modprobe.d/qemu-blacklist.conf

# (will be reconfigured in installer)
rm ${rootdir}/etc/apt/sources.list.d/updates.list

replace_apt_source

mv ${rootdir}/etc/resolv.conf ${rootdir}/etc/resolv.conf.bak

echo 1>&2 "(done with customise.sh)"
