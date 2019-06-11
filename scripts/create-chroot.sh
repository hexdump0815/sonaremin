#!/bin/bash -x

apt-get update
apt-get -y upgrade
apt-get -y install vim openssh-server qjackctl fluxbox xpra xvfb libgl1 rtirq-init sudo net-tools ifupdown net-tools isc-dhcp-client lxterminal kmod less overlayroot u-boot-tools xinit xserver-xorg-input-libinput mingetty locales irqbalance usbutils mousepad alsa-utils matchbox-keyboard dosfstools libllvm6.0 a2jmidid samba avahi-daemon

mkdir /data
# this has been created already during debootstrap
#mkdir /boot
systemctl enable ssh
systemctl disable xpra
systemctl disable irqbalance
systemctl disable ondemand
systemctl disable smbd
systemctl disable nmbd
systemctl mask alsa-restore.service
systemctl mask alsa-state.service
systemctl mask alsa-utils

useradd -c sonaremin -d /home/sonaremin -m -p '$6$ogEKlCQK$t8xIWJOE2eQgw4gcReHlCun4/AlNWBlHS6sWJSJnR.ZUru4kdWzT7iUDXWNwjjwGif0yOm1wDShv7BbRlvsN0.' -s /bin/bash sonaremin
usermod -a -G sudo sonaremin
usermod -a -G audio sonaremin
usermod -a -G video sonaremin

apt-get -y auto-remove
apt-get clean
