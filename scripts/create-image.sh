#!/bin/bash -x

if [ "$#" != "2" ]; then
  echo ""
  echo "usage: $0 system armversion"
  echo ""
  echo "possible system options:"
  echo "- raspberry_pi (armv7l)"
  echo "- raspberry_pi (aarch64)"
  echo "- amlogic_gx (aarch64)"
  echo ""
  echo "possible armversion options:"
  echo "- armv7l (32bit)"
  echo "- aarch64 (64bit)"
  echo ""
  echo "example: $0 amlogic_gx aarch64"
  echo ""
  exit 1
fi

export BUILD_ROOT=/compile/local/sonaremin-root
export IMAGE_DIR=/compile/local/sonaremin-diskimage
export MOUNT_POINT=/tmp/sonaremin-mnt

if [ ! -d ${BUILD_ROOT}/boot ]; then
  echo ""
  echo "no BUILD_ROOT at ${BUILD_ROOT}/boot - giving up"
  echo ""
  exit 1
fi

cd `dirname $0`/..
export WORKDIR=`pwd`

if [ -d `dirname $0`/../../imagebuilder ]; then
  # path to the cloned imagebuilder framework
  cd `dirname $0`/../../imagebuilder
  export IMAGEBUILDER=`pwd`
else
  echo ""
  echo "please clone https://github.com/hexdump0815/imagebuilder to `dirname $0`/../../imagebuilder"
  echo ""
  echo "giving up"
  echo ""
  exit 1
fi

mkdir -p ${IMAGE_DIR}
mkdir -p ${MOUNT_POINT}

if [ -f ${IMAGE_DIR}/sonaremin-${1}-${2}.img ]; then
  echo ""
  echo "image file ${IMAGE_DIR}/sonaremin-${1}-${2}.img alresdy exists - giving up for safety reasons ..."
  echo ""
  exit 1
fi

# we use less than the marketing capacity of the sd card as it is usually lower in reality
# 7g for an 8g card and 14g for a 16g card - it can easily be extended to full size later
dd if=/dev/zero of=${IMAGE_DIR}/sonaremin-${1}-${2}.img bs=1024k count=1 seek=$((7*1024)) status=progress
#dd if=/dev/zero of=${IMAGE_DIR}/sonaremin-${1}-${2}.img bs=1024k count=1 seek=$((14*1024)) status=progress

losetup /dev/loop0 ${IMAGE_DIR}/sonaremin-${1}-${2}.img

if [ -f ${IMAGEBUILDER}/boot/boot-${1}-${2}.dd ]; then
  dd if=${IMAGEBUILDER}/boot/boot-${1}-${2}.dd of=/dev/loop0
fi

# inspired by https://github.com/jeromebrunet/libretech-image-builder/blob/libretech-cc-xenial-4.13/linux-image.sh
fdisk /dev/loop0 < ${WORKDIR}/files/mbr-partitions.txt

# this is to make sure we really use the new partition table and have all partitions around
partprobe /dev/loop0
losetup -d /dev/loop0
losetup --partscan /dev/loop0 ${IMAGE_DIR}/sonaremin-${1}-${2}.img

# get partition mapping info
. ${WORKDIR}/files/partition-mapping.txt
mkfs.vfat -F32 -n BOOTPART /dev/loop0p$BOOTPART
mkfs.vfat -F32 -n DATAPART /dev/loop0p$DATAPART
mkswap -L swappart /dev/loop0p$SWAPPART
mkfs -t ext4 -O ^has_journal -L rootpart /dev/loop0p$ROOTPART

mount /dev/loop0p$ROOTPART ${MOUNT_POINT}
mkdir ${MOUNT_POINT}/boot
mount /dev/loop0p$BOOTPART ${MOUNT_POINT}/boot
mkdir ${MOUNT_POINT}/data
mount /dev/loop0p$DATAPART ${MOUNT_POINT}/data

rsync -a ${BUILD_ROOT}/ ${MOUNT_POINT}

ROOT_PARTUUID=$(blkid | grep "/dev/loop0p$ROOTPART" | awk '{print $5}' | sed 's,",,g')

# should not be needed for the sonaremin
#if [ -f ${MOUNT_POINT}/boot/extlinux/extlinux.conf ]; then
#  sed -i "s,ROOT_PARTUUID,$ROOT_PARTUUID,g" ${MOUNT_POINT}/boot/extlinux/extlinux.conf
#fi
if [ -f ${MOUNT_POINT}/boot/menu/extlinux.conf ]; then
  sed -i "s,ROOT_PARTUUID,$ROOT_PARTUUID,g" ${MOUNT_POINT}/boot/menu/extlinux.conf
fi

umount ${MOUNT_POINT}/data 
umount ${MOUNT_POINT}/boot 
umount ${MOUNT_POINT}

losetup -d /dev/loop0

rmdir ${MOUNT_POINT}

echo ""
echo "the image is now ready at ${IMAGE_DIR}/sonaremin-${1}-${2}.img"
echo ""
