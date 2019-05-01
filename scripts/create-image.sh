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
  echo "- bananapi_m1 (armhf)"
  echo ""
  echo "possible armversion options:"
  echo "- armhf (32bit)"
  echo "- arm64 (64bit)"
  echo ""
  exit 1
fi

export BUILD_ROOT=/local/sonaremin/root
export IMAGE_DIR=/local/sonaremin/diskimage
export MOUNT_POINT=/mnt

cd `dirname $0`/..
export WORKDIR=`pwd`

mkdir -p ${IMAGE_DIR}

dd if=/dev/zero of=${IMAGE_DIR}/sonaremin.img bs=1024k count=1 seek=6419 status=progress

losetup --partscan /dev/loop0 ${IMAGE_DIR}/sonaremin.img

if [ -f ${WORKDIR}/boot/boot-${1}-${2}.dd ]; then
  dd if=${WORKDIR}/boot/boot-${1}-${2}.dd of=/dev/loop0
fi

# created with sfdisk -d ...
sfdisk ${IMAGE_DIR}/sonaremin.img < files/partitions.txt

losetup -d /dev/loop0
losetup --partscan /dev/loop0 ${IMAGE_DIR}/sonaremin.img

mkfs.fat -F32 -n BOOT /dev/loop0p1 
mkfs.fat -F32 -n DATA /dev/loop0p2
mkswap -L swap /dev/loop0p3 
mkfs -t ext4 -O ^has_journal -L root /dev/loop0p5

mount /dev/loop0p5 ${MOUNT_POINT}
mkdir ${MOUNT_POINT}/boot
mkdir ${MOUNT_POINT}/data
mount /dev/loop0p1 ${MOUNT_POINT}/boot
mount /dev/loop0p2 ${MOUNT_POINT}/data

rsync -a ${BUILD_ROOT}/ ${MOUNT_POINT}

umount ${MOUNT_POINT}/boot 
umount ${MOUNT_POINT}/data 
umount ${MOUNT_POINT}

losetup -d /dev/loop0

echo ""
echo "the image is now ready at ${IMAGE_DIR}/sonaremin.img"
echo ""
