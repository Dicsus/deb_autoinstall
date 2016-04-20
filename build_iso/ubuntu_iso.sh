#!/bin/sh
mkdir -p /tmp/iso
cd /tmp/ubuntu
[ -f initrd.gz ] || wget "http://archive.ubuntu.com/ubuntu/dists/trusty/main/installer-amd64/current/images/netboot/ubuntu-installer/amd64/initrd.gz"
[ -f firmware.cpio.gz ] || wget "http://cdimage.debian.org/cdimage/unofficial/non-free/firmware/stable/current/firmware.cpio.gz"
cat initrd.gz firmware.cpio.gz > /tmp/iso/initrd.gz
[ -f linux ] || wget "http://archive.ubuntu.com/ubuntu/dists/trusty/main/installer-amd64/current/images/netboot/ubuntu-installer/amd64/linux"
cat linux > /tmp/iso/linux
[ -f isolinux.bin ] || wget "http://mirror.centos.org/centos/7/os/x86_64/isolinux/isolinux.bin"
cat isolinux.bin > /tmp/iso/isolinux.bin

cat > /tmp/iso/isolinux.cfg << EOF
prompt 0
timeout 0
default auto

label auto
    kernel /linux
    append auto=true preseed/file=/cdrom/apt.cfg keyboard-configuration/xkb-keymap=en priority=critical vga=788 initrd=/initrd.gz --- quiet
EOF
mkdir -p /tmp/ubuntu
wget "http://le9i0nx.github.io/debian-autoinstall/apt.cfg"
wget "http://le9i0nx.github.io/debian-autoinstall/pve.cfg"
wget "http://le9i0nx.github.io/debian-autoinstall/default.cfg"

cd ..
genisoimage -r -V "ubuntu auto install" -cache-inodes -J -l -b isolinux.bin  -c boot.cat -no-emul-boot -boot-load-size 4 -boot-info-table -o ubuntu-lts-amd64-auto-install.iso iso/
rm -r /tmp/iso
