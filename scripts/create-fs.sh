#!/bin/bash -x

if [ "$#" != "2" ]; then
  echo ""
  echo "usage: $0 system armversion"
  echo ""
  echo "possible system options:"
  echo "- raspberrypi (armhf & arm64)"
  echo "- tinkerboard (armhf)"
  echo "- odroid_c2 (arm64)"
  echo "- amlogic_s905_w_x_tv_box (arm64)"
  echo "- allwinner_h3_tv_box (armhf)"
  echo "- bananapi_m1 (armhf)"
  echo ""
  echo "possible armversion options:"
  echo "- armhf (32bit)"
  echo "- arm64 (64bit)"
  echo ""
  exit 1
fi

export BUILD_ROOT=/local/sonaremin/root

cd `dirname $0`/..
export WORKDIR=`pwd`

mkdir -p ${BUILD_ROOT}
cd ${BUILD_ROOT}

LANG=C debootstrap --variant=minbase --arch=${2} bionic ${BUILD_ROOT} http://ports.ubuntu.com/

cp ${WORKDIR}/files/sources.list ${BUILD_ROOT}/etc/apt
cp ${WORKDIR}/scripts/create-chroot.sh ${BUILD_ROOT}

mount -o bind /dev ${BUILD_ROOT}/dev
mount -o bind /dev/pts ${BUILD_ROOT}/dev/pts
mount -t sysfs /sys ${BUILD_ROOT}/sys
mount -t proc /proc ${BUILD_ROOT}/proc
cp /proc/mounts ${BUILD_ROOT}/etc/mtab  
cp /etc/resolv.conf ${BUILD_ROOT}/etc/resolv.conf 

chroot ${BUILD_ROOT} /create-chroot.sh

cd ${BUILD_ROOT}/boot
tar --numeric-owner -xzf ${WORKDIR}/boot/boot-${1}-${2}.tar.gz

cd ${BUILD_ROOT}/data
cp -r ${WORKDIR}/files/data/* .

cd ${BUILD_ROOT}
rm -f create-chroot.sh
tar --numeric-owner -xzf ${WORKDIR}/files/extra-files.tar.gz
if [ "${1}" = "odroid_c2" ]; then
  cp etc/fstab.mmc1 etc/fstab
else
  cp etc/fstab.mmc0 etc/fstab
fi
tar --numeric-owner -xzf ${WORKDIR}/files/binaries-${1}-${2}.tar.gz
tar --numeric-owner -xzf ${WORKDIR}/files/vcvrack-v0-${2}.tar.gz
tar --numeric-owner -xzf ${WORKDIR}/files/vcvrack-v1dev-${2}.tar.gz

export KERNEL_VERSION=`ls ${BUILD_ROOT}/boot/*Image-* | sed 's,.*Image-,,g'`

chroot ${BUILD_ROOT} update-initramfs -c -k ${KERNEL_VERSION}

cd ${WORKDIR}

umount ${BUILD_ROOT}/proc ${BUILD_ROOT}/sys ${BUILD_ROOT}/dev/pts ${BUILD_ROOT}/dev

echo ""
echo "now run create-image.sh ${1} ${2} to build the image"
echo ""
