#!/bin/bash
#
# please run this script to fetch some large files from various github releases before starting to build images

if [ "$#" != "1" ]; then
  echo ""
  echo "usage: $0 arch"
  echo "arch can be: armv7l"
  echo "             aarch64"
  echo "             all"
  echo ""
  echo "examples: $0 aarch64"
  echo "          $0 all"
  echo ""
  exit 1
fi

cd `dirname $0`/..

# create downloads dir
mkdir downloads

# exit on errors
set -e

vcvrack_v0_release_version="v0.6.2c-0.2"
vcvrack_v1_release_version="v1.1.6"
padthv1_synthv1_release_version="v1.0.0"

if [ "$1" = "all" ] || [ "$1" = "armv7l" ]; then
  wget https://github.com/hexdump0815/vcvrack-dockerbuild-v0/releases/download/${vcvrack_v0_release_version}/vcvrack.armv7l.tar.gz -O downloads/vcvrack-v0-armv7l.tar.gz
  wget https://github.com/hexdump0815/vcvrack-dockerbuild-v1/releases/download/${vcvrack_v1_release_version}/vcvrack.armv7l-v1.tar.gz -O downloads/vcvrack.armv7l-v1.tar.gz
  wget https://github.com/hexdump0815/sonaremin-rncbc-dockerbuild/releases/download/${padthv1_synthv1_release_version}/padthv1-synthv1-armv7l.tar.gz -O downloads/padthv1-synthv1-armv7l.tar.gz
fi

if [ "$1" = "all" ] || [ "$1" = "aarch64" ]; then
  wget https://github.com/hexdump0815/vcvrack-dockerbuild-v0/releases/download/${vcvrack_v0_release_version}/vcvrack.aarch64.tar.gz -O downloads/vcvrack-v0-aarch64.tar.gz
  wget https://github.com/hexdump0815/vcvrack-dockerbuild-v1/releases/download/${vcvrack_v1_release_version}/vcvrack.aarch64-v1.tar.gz -O downloads/vcvrack.aarch64-v1.tar.gz
  wget https://github.com/hexdump0815/sonaremin-rncbc-dockerbuild/releases/download/${padthv1_synthv1_release_version}/padthv1-synthv1-aarch64.tar.gz -O downloads/padthv1-synthv1-aarch64.tar.gz
fi
