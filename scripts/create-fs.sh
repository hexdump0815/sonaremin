#!/bin/bash

if [ "$#" != "2" ]; then
  echo ""
  echo "usage: $0 system arch"
  echo ""
  echo "possible system options:"
  echo "- tinkerboard (armv7l)"
  echo "- raspberry_pi (armv7l)"
  echo "- raspberry_pi (aarch64)"
  echo "- raspberry_pi_4 (aarch64)"
  echo "- amlogic_gx (aarch64)"
  echo ""
  echo "possible arch options:"
  echo "- armv7l (32bit)"
  echo "- aarch64 (64bit)"
  echo ""
  echo "example: $0 amlogic_gx aarch64"
  echo ""
  exit 1
fi

export BUILD_ROOT=/compile/local/sonaremin-root

if [ -d ${BUILD_ROOT} ]; then
  echo ""
  echo "BUILD_ROOT ${BUILD_ROOT} alresdy exists - giving up for safety reasons ..."
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

mkdir -p ${BUILD_ROOT}
cd ${BUILD_ROOT}

if [ "$2" = "armv7l" ]; then 
  BOOTSTRAP_ARCH=armhf
elif [ "$2" = "aarch64" ]; then 
  BOOTSTRAP_ARCH=arm64
fi
LANG=C debootstrap --variant=minbase --arch=${BOOTSTRAP_ARCH} bionic ${BUILD_ROOT} http://ports.ubuntu.com/

cp ${IMAGEBUILDER}/files/ubuntu-sources.list ${BUILD_ROOT}/etc/apt/sources.list
cp ${WORKDIR}/scripts/create-chroot.sh ${BUILD_ROOT}

mount -o bind /dev ${BUILD_ROOT}/dev
mount -o bind /dev/pts ${BUILD_ROOT}/dev/pts
mount -t sysfs /sys ${BUILD_ROOT}/sys
mount -t proc /proc ${BUILD_ROOT}/proc
cp /proc/mounts ${BUILD_ROOT}/etc/mtab  
cp /etc/resolv.conf ${BUILD_ROOT}/etc/resolv.conf 

chroot ${BUILD_ROOT} /create-chroot.sh

cd ${BUILD_ROOT}/

tar --numeric-owner -xzf ${IMAGEBUILDER}/downloads/kernel-${1}-${2}.tar.gz
if [ -f ${IMAGEBUILDER}/downloads/kernel-mali-${1}-${2}.tar.gz ]; then
  tar --numeric-owner -xzf ${IMAGEBUILDER}/downloads/kernel-mali-${1}-${2}.tar.gz
fi
cp -r ${IMAGEBUILDER}/boot/boot-${1}-${2}/* boot
# the sonaremin uses syslinux with /boot/menu as dir - so remove /boot/extlinux and add /boot/menu per system
rm -rf boot/extlinux
cp -r ${WORKDIR}/boot/boot-${1}-${2}/* boot

rm -f create-chroot.sh
( cd ${IMAGEBUILDER}/files/extra-files ; tar cf - . ) | tar xf -
if [ -d ${IMAGEBUILDER}/files/extra-files-${2} ]; then
  ( cd ${IMAGEBUILDER}/files/extra-files-${2} ; tar cf - . ) | tar xf -
fi
if [ -d ${IMAGEBUILDER}/files/extra-files-ubuntu ]; then
  ( cd ${IMAGEBUILDER}/files/extra-files-ubuntu ; tar cf - . ) | tar xf -
fi
if [ -d ${IMAGEBUILDER}/files/systems/${1}/extra-files-${1}-${2} ]; then
  ( cd ${IMAGEBUILDER}/files/systems/${1}/extra-files-${1}-${2} ; tar cf - . ) | tar xf -
fi
if [ -d ${IMAGEBUILDER}/files/systems/${1}/extra-files-${1}-${2}-ubuntu ]; then
  ( cd ${IMAGEBUILDER}/files/systems/${1}/extra-files-${1}-${2}-ubuntu ; tar cf - . ) | tar xf -
fi
if [ -f ${IMAGEBUILDER}/downloads/opengl-${1}-${2}.tar.gz ]; then
  tar --numeric-owner -xzf ${IMAGEBUILDER}/downloads/opengl-${1}-${2}.tar.gz
fi
if [ -f ${IMAGEBUILDER}/downloads/opengl-fbdev-${1}-${2}.tar.gz ]; then
  tar --numeric-owner -xzf ${IMAGEBUILDER}/downloads/opengl-fbdev-${1}-${2}.tar.gz
fi
if [ -f ${IMAGEBUILDER}/downloads/opengl-wayland-${1}-${2}.tar.gz ]; then
  tar --numeric-owner -xzf ${IMAGEBUILDER}/downloads/opengl-wayland-${1}-${2}.tar.gz
fi
if [ -f ${IMAGEBUILDER}/downloads/opengl-mesa-${2}-ubuntu.tar.gz ]; then
  tar --numeric-owner -xzf ${IMAGEBUILDER}/downloads/opengl-mesa-${2}-ubuntu.tar.gz
fi
if [ -f ${IMAGEBUILDER}/downloads/xorg-armsoc-${2}-ubuntu.tar.gz ]; then
  tar --numeric-owner -xzf ${IMAGEBUILDER}/downloads/xorg-armsoc-${2}-ubuntu.tar.gz
fi
if [ -f ${IMAGEBUILDER}/downloads/gl4es-${2}-ubuntu.tar.gz ]; then
  tar --numeric-owner -xzf ${IMAGEBUILDER}/downloads/gl4es-${2}-ubuntu.tar.gz
fi

# the sonaremin brings its own xorg config, so delete the one coming from the imagebuilder
rm -f etc/X11/xorg.conf.d/01-*

# not sure if this is all needed for the sonaremin
#if [ -f ${IMAGEBUILDER}/files/systems/${1}/rc-local-additions-${1}-${2}-ubuntu.txt ]; then
#  echo "" >> etc/rc.local
#  echo "# additions for ${1}-${2}-ubuntu" >> etc/rc.local
#  echo "" >> etc/rc.local
#  cat ${IMAGEBUILDER}/files/systems/${1}/rc-local-additions-${1}-${2}-ubuntu.txt >> etc/rc.local
#fi
#echo "" >> etc/rc.local
#echo "exit 0" >> etc/rc.local
#
## adjust some config files if they exist
#if [ -f ${BUILD_ROOT}/etc/modules-load.d/cups-filters.conf ]; then
#  sed -i 's,^lp,#lp,g' ${BUILD_ROOT}/etc/modules-load.d/cups-filters.conf
#  sed -i 's,^ppdev,#ppdev,g' ${BUILD_ROOT}/etc/modules-load.d/cups-filters.conf
#  sed -i 's,^parport_pc,#parport_pc,g' ${BUILD_ROOT}/etc/modules-load.d/cups-filters.conf
#fi
#if [ -f ${BUILD_ROOT}/etc/NetworkManager/NetworkManager.conf ]; then
#  sed -i 's,^managed=false,managed=true,g' ${BUILD_ROOT}/etc/NetworkManager/NetworkManager.conf
#  touch ${BUILD_ROOT}/etc/NetworkManager/conf.d/10-globally-managed-devices.conf
#fi
#if [ -f ${BUILD_ROOT}/etc/default/numlockx ]; then
#  sed -i 's,^NUMLOCK=auto,NUMLOCK=off,g' ${BUILD_ROOT}/etc/default/numlockx
#fi

mkdir -p ${BUILD_ROOT}/data
cd ${BUILD_ROOT}/data
cp -r ${WORKDIR}/files/data/* .
cp -f vcvrack-v1/sonaremin.vcv config/vcvrack-v1/autosave.vcv
mkdir -p config/qjackctl/backup
mkdir -p myfiles/vcvrack-v1
cp config/qjackctl/qjackctl-patchbay.xml config/qjackctl/backup
mkdir -p config/vcvrack-v1/backup
cp config/vcvrack-v1/settings.json config/vcvrack-v1/backup/settings.json 

cd ${BUILD_ROOT}
tar --numeric-owner -xzf ${WORKDIR}/downloads/sfizz.${2}.tar.gz
# unpack this before the extra-files as they bring an adapted config
tar --numeric-owner -xzf ${WORKDIR}/files/xorgxrdp-${2}.tar.gz
( cd ${WORKDIR}/files/extra-files ; tar cf - . ) | tar xf -
tar --numeric-owner -xzf ${WORKDIR}/files/raveloxmidi-${2}.tar.gz
cd home/sonaremin
tar --numeric-owner -xzf ${WORKDIR}/downloads/vcvrack.${2}-v1.tar.gz
mv vcvrack.${2}-v1 vcvrack-v1
rm -f vcvrack-v1/settings.json vcvrack-v1/autosave.vcv vcvrack-v1/template.vcv
ln -s /data/config/vcvrack-v1/settings.json vcvrack-v1/settings.json
cp -f ${BUILD_ROOT}/data/config/vcvrack-v1/autosave.vcv vcvrack-v1/autosave.vcv
cp ${WORKDIR}/files/empty-template.vcv vcvrack-v1/template.vcv
cp ${WORKDIR}/files/empty-template-sfizz.vcv vcvrack-v1/template-sfizz.vcv
cd ../..
chown -R 1000:1000 home/sonaremin/

export KERNEL_VERSION=`ls ${BUILD_ROOT}/boot/*Image-* | sed 's,.*Image-,,g' | sort -u`

# hack to get the fsck binaries in properly even in out chroot env
cp -f ${BUILD_ROOT}/usr/share/initramfs-tools/hooks/fsck ${BUILD_ROOT}/tmp/fsck.org
sed -i 's,fsck_types=.*,fsck_types="vfat ext4",g' ${BUILD_ROOT}/usr/share/initramfs-tools/hooks/fsck
chroot ${BUILD_ROOT} update-initramfs -c -k ${KERNEL_VERSION}
mv -f ${BUILD_ROOT}/tmp/fsck.org ${BUILD_ROOT}/usr/share/initramfs-tools/hooks/fsck

cd ${BUILD_ROOT}

# post install script per system
if [ -x ${IMAGEBUILDER}/files/systems/${1}/postinstall-${1}-${2}-ubuntu.sh ]; then
  ${IMAGEBUILDER}/files/systems/${1}/postinstall-${1}-${2}-ubuntu.sh
fi

chroot ${BUILD_ROOT} ldconfig

cd ${WORKDIR}

umount ${BUILD_ROOT}/proc ${BUILD_ROOT}/sys ${BUILD_ROOT}/dev/pts ${BUILD_ROOT}/dev

echo ""
echo "now run create-image.sh ${1} ${2} to build the image"
echo ""
