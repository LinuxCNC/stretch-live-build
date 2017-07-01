# stretch-live-build
Scripts supporting the build of the linuxcnc stretch live cd image

The images themselves are at http://www.linuxcnc.org/testing-stretch-rtpreempt/

## Current status
When run on a Debian Stretch amd64 system, this produces an approximately 1.2GB image that can be booted via USB.
It includes the 64-bit "preempt-rt" kernel, the latest linuxcnc 2.7.x "uspace" release, and uses the xfce desktop.

This is essentially untested.  It will probably let your chickes out of the coop, make your goats' milk sour, etc.

Not to mention ruining machine tools galore.

The usual set of "non-free" firmware is included, but I didn't test any firmware that requires it.
Because the non-free firmware is included, I expect the image to have generally the same wireless support as Debian Stretch.

## Items I tested:
* Boots in qemu when used as a "cdrom" installation image
* installs into a 20GB virtual hard drive, using "one filesystem" partitioning.  Installed system has rt kernel and linuxcnc package
* Boots off a 32GB USB stick (copy with 'dd')

## Important notes
* The live user's name/password is user/live.
* The screen locker (live-locker) is disabled by default.  You can reenable it by via Session and Startup after installation.
* At the live boot prompt, you can edit the kernel commandline by pressing ctrl-i.  This can be useful for example to enter an `isolcpus=` value.
* After installation, root access is via "sudo" with the user's password.  You can configure root access with "su" and a separate root password via "sudo passwd root".
* openssh-server is installed and activated by default.  This means you should only run the live image on a trusted network, and you should set a good password when installing.

## Known limitations
* Actual installation requires a network at install time
* The installation uses packages from buildbot, not released versions.  After 2.7.10 is released, you can use synaptic package manager to change to the released version.
* On most systems, the "preempt-rt" kernel is not suitable for software step generation
* on a 20GB virtual hard drive, the "separate partitions" method failed, I think because the disk filled
* Language packs are not included, because they caused a large increase in the download size
* If you specify `/dev/shm` as the temporary directory in `env.sh` the resulting image can't install, because it looks for files like `/dev/shmpool/main/….deb`.  (Workaround: you can use temporary directories like `/tmp/shm` and carefully symlink or bind-mount)
* There's no update notifier

## Hacking on it

* Install the depends of live-wrapper, or just install live-wrapper.  However, a local version of live-wrapper is used instead of the system one in any case.
* `git submodule update --init --recursive` to get the live-wrapper submodule
* You can select a different task by editing `do.sh`: Find the `-t ... task-xfce-desktop` line.  Remove it and replace it with the task you want (e.g., `task-kde-desktop`).
* Build the image with `./do.sh`.  Specify `./do.sh i386` or `./do.sh amd64` to generate just one of the two images.  If there's already an image there, remove it with `rm -f` before invoking `do.sh`.
* Using a caching proxy greatly speeds image generation
** I use squid-deb-proxy and set up env.sh with the line `export http_proxy=http://localhost:8000/` to enable its use while lwr runs.
** squid-deb-proxy must additionally be reconfigured to allow it to access linuxcnc.org.  See `etc/squid-deb-proxy/mirror-dstdomain.acl.d/99-linuxcnc` in the source tree for such a file (copy to `/etc/squid-deb-proxy/mirror-dstdomain.acl.d/99-linuxcnc` and restart squid-deb-proxy to use)
** Other proxy choices such as apt-cacher, apt-cacher-ng, and apt-proxy appear to be incompatible with `live-wrapper`.
* Using a modified version of mksquashfs greatly speeds image generation
** An experimental patch is available at `etc/mksquashfs-compression-cache.patch`
** However, this will also cause a growing cache of compressed blocks in `~root/.cache` which is never cleaned automaticlaly
