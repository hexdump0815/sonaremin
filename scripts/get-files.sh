#!/bin/bash
#
# please run this script to fetch some large files from various github releases before starting to build images

if [ "$#" != "1" ]; then
  echo ""
  echo "usage: $0 arch"
  echo ""
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

vcvrack_v1_release_version="v1.1.6_4"

if [ "$1" = "all" ] || [ "$1" = "armv7l" ]; then
  wget https://github.com/hexdump0815/vcvrack-dockerbuild-v1/releases/download/${vcvrack_v1_release_version}/vcvrack.armv7l-v1.tar.gz -O downloads/vcvrack.armv7l-v1.tar.gz
fi

if [ "$1" = "all" ] || [ "$1" = "aarch64" ]; then
  wget https://github.com/hexdump0815/vcvrack-dockerbuild-v1/releases/download/${vcvrack_v1_release_version}/vcvrack.aarch64-v1.tar.gz -O downloads/vcvrack.aarch64-v1.tar.gz
fi
