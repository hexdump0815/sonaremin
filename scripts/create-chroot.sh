#!/bin/bash

# do not ask anything
export DEBIAN_FRONTEND=noninteractive

export LANG=C

apt-get update
apt-get -yq upgrade
apt-get -yq install vim openssh-server qjackctl fluxbox xpra xvfb libgl1 rtirq-init sudo net-tools ifupdown iputils-ping isc-dhcp-client lxterminal kmod less rsync overlayroot u-boot-tools xinit xserver-xorg-input-libinput mingetty locales irqbalance usbutils mousepad alsa-utils matchbox-keyboard dosfstools libllvm6.0 a2jmidid samba avahi-daemon liblo7 libfftw3-3 unzip libcap2-bin xserver-xorg-legacy libllvm6.0 linux-firmware

systemctl enable ssh
systemctl disable xpra
systemctl disable irqbalance
systemctl disable ondemand
systemctl disable smbd
systemctl disable nmbd
systemctl disable avahi-daemon
systemctl disable fstrim.timer
systemctl disable apt-daily
systemctl disable apt-daily-upgrade
systemctl mask alsa-restore.service
systemctl mask alsa-state.service
systemctl mask alsa-utils

useradd -c sonaremin -d /home/sonaremin -m -p '$6$ogEKlCQK$t8xIWJOE2eQgw4gcReHlCun4/AlNWBlHS6sWJSJnR.ZUru4kdWzT7iUDXWNwjjwGif0yOm1wDShv7BbRlvsN0.' -s /bin/bash sonaremin
usermod -a -G sudo sonaremin
usermod -a -G audio sonaremin
usermod -a -G video sonaremin
usermod -a -G xpra sonaremin

# setup locale info for en-us
sed -i 's,# en_US ISO-8859-1,en_US ISO-8859-1,g;s,# en_US.UTF-8 UTF-8,en_US.UTF-8 UTF-8,g' /etc/locale.gen
locale-gen

# enable jack realtime settings
mv -f /etc/security/limits.d/audio.conf.disabled /etc/security/limits.d/audio.conf

# remove snapd and dmidecode (only on ubuntu) as it crashes on some arm devices on boot
apt-get -yq remove snapd dmidecode

apt-get -yq auto-remove
apt-get clean
