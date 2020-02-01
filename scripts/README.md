get-files.sh - get precompiled binaries needed from other repositories
create-fs.sh - builds the filesystem for the sonaremin in a directory
create-chroot.sh - is being called by create-fs.sh to execute some tasks chrooted into the directory created by it
create-image.sh - creates a diskimage from the directory created by create-fs.sh

before starting, please checkout https://github.com/hexdump0815/imagebuilder next to this repo and run scripts/get-files.sh for the corresponding system there
