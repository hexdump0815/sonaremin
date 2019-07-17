#!/bin/bash
#
# please run this script to fetch some large files from various github releases before starting to build images
# some of those files were too big to commit directly into the git repo

wget https://github.com/hexdump0815/vcvrack-dockerbuild-v0/releases/download/v0.6.2c-0.2/vcvrack.armv7l.tar.gz -O vcvrack-v0-armv7l.tar.gz
wget https://github.com/hexdump0815/vcvrack-dockerbuild-v0/releases/download/v0.6.2c-0.2/vcvrack.aarch64.tar.gz -O vcvrack-v0-aarch64.tar.gz

wget https://github.com/hexdump0815/vcvrack-dockerbuild-v1/releases/download/v1.1.1/vcvrack.armv7l-v1.tar.gz
wget https://github.com/hexdump0815/vcvrack-dockerbuild-v1/releases/download/v1.1.1/vcvrack.aarch64-v1.tar.gz

wget https://github.com/hexdump0815/sonaremin-rncbc-dockerbuild/releases/download/v1.0.0/padthv1-synthv1-armv7l.tar.gz
wget https://github.com/hexdump0815/sonaremin-rncbc-dockerbuild/releases/download/v1.0.0/padthv1-synthv1-aarch64.tar.gz
