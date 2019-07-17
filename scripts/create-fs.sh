#!/bin/bash -x

if [ "$#" != "2" ]; then
  echo ""
  echo "usage: $0 system armversion"
  echo ""
  echo "possible system options:"
  echo "- raspberry_pi (armv7l & aarch64)"
  echo "- tinkerboard (armv7l)"
  echo "- odroid_c2 (aarch64)"
  echo "- amlogic_s905_w_x_tv_box (aarch64)"
  echo "- amlogic_s905_tv_box (aarch64)"
  echo "- allwinner_h3_tv_box (armv7l)"
  echo "- bananapi_m1 (armv7l)"
  echo ""
  echo "possible armversion options:"
  echo "- armv7l (32bit)"
  echo "- aarch64 (64bit)"
  echo ""
  exit 1
fi

export BUILD_ROOT=/local/sonaremin/root

cd `dirname $0`/..
export WORKDIR=`pwd`

mkdir -p ${BUILD_ROOT}
cd ${BUILD_ROOT}

if [ "$2" = "armv7l" ]; then 
  BOOTSTRAP_ARCH=armhf
elif [ "$2" = "aarch64" ]; then 
  BOOTSTRAP_ARCH=arm64
fi
LANG=C debootstrap --variant=minbase --arch=${BOOTSTRAP_ARCH} bionic ${BUILD_ROOT} http://ports.ubuntu.com/

cp ${WORKDIR}/files/sources.list ${BUILD_ROOT}/etc/apt
cp ${WORKDIR}/scripts/create-chroot.sh ${BUILD_ROOT}

mount -o bind /dev ${BUILD_ROOT}/dev
mount -o bind /dev/pts ${BUILD_ROOT}/dev/pts
mount -t sysfs /sys ${BUILD_ROOT}/sys
mount -t proc /proc ${BUILD_ROOT}/proc
cp /proc/mounts ${BUILD_ROOT}/etc/mtab  
cp /etc/resolv.conf ${BUILD_ROOT}/etc/resolv.conf 

chroot ${BUILD_ROOT} /create-chroot.sh

cd ${BUILD_ROOT}/
tar --numeric-owner -xzf ${WORKDIR}/boot/boot-${1}-${2}.tar.gz

cd ${BUILD_ROOT}/data
cp -r ${WORKDIR}/files/data/* .
cp -f vcvrack-v0/sonaremin.vcv vcvrack-v0/config/autosave.vcv
cp -f vcvrack-v1/sonaremin.vcv vcvrack-v1/config/autosave.vcv
mkdir -p padthv1/backup synthv1/backup config/qjackctl/backup
cp -f padthv1/sonaremin-* padthv1/backup
cp -f synthv1/sonaremin-* synthv1/backup
mkdir -p myfiles/vcvrack-v0 myfiles/vcvrack-v1 myfiles/padthv1 myfiles/synthv1
cp config/qjackctl/qjackctl-patchbay.xml config/qjackctl/backup

cd ${BUILD_ROOT}
rm -f create-chroot.sh
( cd ${WORKDIR}/files/extra-files ; tar cf - . ) | tar xf -
if [ "${1}" = "odroid_c2" ] || [ "${1}" = "amlogic_s905_tv_box" ]; then
  cp etc/fstab.mmc1 etc/fstab
else
  cp etc/fstab.mmc0 etc/fstab
fi
tar --numeric-owner -xzf ${WORKDIR}/files/opengl-${1}-${2}.tar.gz
tar --numeric-owner -xzf ${WORKDIR}/files/raveloxmidi-${2}.tar.gz
tar --numeric-owner -xzf ${WORKDIR}/files/padthv1-synthv1-${2}.tar.gz
cd home/sonaremin
tar --numeric-owner -xzf ${WORKDIR}/files/vcvrack-v0-${2}.tar.gz
mv vcvrack.${2} vcvrack-v0
rm -f vcvrack-v0/settings.json vcvrack-v0/autosave.vcv
ln -s /data/vcvrack-v0/config/settings.json vcvrack-v0/settings.json
ln -s /data/vcvrack-v0/config/autosave.vcv vcvrack-v0/autosave.vcv
tar --numeric-owner -xzf ${WORKDIR}/files/vcvrack.${2}-v1.tar.gz
mv vcvrack.${2}-v1 vcvrack-v1
rm -f vcvrack-v1/settings.json vcvrack-v1/autosave.vcv vcvrack-v1/template.vcv
ln -s /data/vcvrack-v1/config/settings.json vcvrack-v1/settings.json
cp -f ${BUILD_ROOT}/data/vcvrack-v1/config/autosave.vcv vcvrack-v1/autosave.vcv
cp ${WORKDIR}/files/empty-template.vcv vcvrack-v1/template.vcv
cd ../..
chown -R 1000:1000 home/sonaremin/

export KERNEL_VERSION=`ls ${BUILD_ROOT}/boot/*Image-* | sed 's,.*Image-,,g' | sort -u`

# hack to get the fsck binaries in properly even in out chroot env
cp -f ${BUILD_ROOT}/usr/share/initramfs-tools/hooks/fsck ${BUILD_ROOT}/tmp/fsck.org
sed -i 's,fsck_types=.*,fsck_types="vfat ext4",g' ${BUILD_ROOT}/usr/share/initramfs-tools/hooks/fsck
chroot ${BUILD_ROOT} update-initramfs -c -k ${KERNEL_VERSION}
mv -f ${BUILD_ROOT}/tmp/fsck.org ${BUILD_ROOT}/usr/share/initramfs-tools/hooks/fsck

cd ${WORKDIR}

umount ${BUILD_ROOT}/proc ${BUILD_ROOT}/sys ${BUILD_ROOT}/dev/pts ${BUILD_ROOT}/dev

echo ""
echo "now run create-image.sh ${1} ${2} to build the image"
echo ""
