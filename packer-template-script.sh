#!/usr/bin/env bash

export TARGET=tulip_chiphd-userdebug
export USE_CCACHE=true
export CCACHE_DIR=/android/ccache
export ANDROID_JACK_VM_ARGS="-Xmx4g -Dfile.encoding=UTF-8 -XX:+TieredCompilation"

message() {
  echo "============================"
  echo "$@"
  echo "============================"
}

set -ve

message "Installing dependencies..."
sudo add-apt-repository -y ppa:openjdk-r/ppa
sudo apt-get update -y
sudo apt-get install -y openjdk-7-jdk python git-core gnupg flex bison gperf build-essential \
  zip curl zlib1g-dev gcc-multilib g++-multilib libc6-dev-i386 \
  lib32ncurses5-dev x11proto-core-dev libx11-dev lib32z-dev ccache \
  libgl1-mesa-dev libxml2-utils xsltproc unzip mtools u-boot-tools \
  htop iotop sysstat iftop pigz bc device-tree-compiler lunzip \
  squashfs-tools

message "Downloading repo tool..."
mkdir -p ~/bin
curl https://storage.googleapis.com/git-repo-downloads/repo > ~/bin/repo
chmod a+x ~/bin/repo

message "Downloading manifests..."
mkdir -p /android
cd /android

rm -rf .repo/local_manifests
~/bin/repo init -u https://android.googlesource.com/platform/manifest -b android-6.0.1_r74 --depth=1
git clone https://github.com/ayufan-pine64/local_manifests -b marshmallow .repo/local_manifests

message "Syncing repositories..."
~/bin/repo sync -j 20 -c --force-sync

message "Building..."
source build/envsetup.sh
lunch "${TARGET}"
command make -j$(($(nproc)+1)) || command make -j$(($(nproc)+1)) || true

message "Cleaning objects..."
command make installclean

message "Building squashfs image..."
cd /
mksquashfs -Xcompression-level 7 /android /android.squashfs

message "Cleanup squashfs mount..."
rm -rf /android

message "Prepare squashfs mount..."
mkdir -p /mnt/android /android/{overlay,work}/

cat <<EOF > /etc/rc.local
#!/bin/sh -e
mount -t squashfs /android.squashfs /mnt/android
mount -t overlay overlay -o lowerdir=/mnt/android,upperdir=/android/overlay,workdir=/android/work /android
EOF
