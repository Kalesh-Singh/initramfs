#! /bin/bash

# -------------------- Configurations ---------------------

# Select from one of the below architectures
# - i386        (for x86 32-bit)
# - x86         (for x86 64-bit)
# - arm         (for arm 32-bit)
# - aarch64     (for arm 64-bit)
#
# Example: If your target architecture is 64-bit arm
# then, TARGET_ARCH="aarch64"

TARGET_ARCH="arm"

# You can find the latest version number at
#     https://www.busybox.net/downloads
#
# You only need to specify the version number
# Example: If the latest release is:
#    busybox-1.32.0.tar.bz2
# then, BUSYBOX_VERSION="1.32.0"


BUSYBOX_VERSION="1.32.0"

# You can find the latest version number at:
#     https://matt.ucc.asn.au/dropbear/releases"
#
# You only need to specify the version number
# Example: If the latest release is:
#    dropbear-2020.81.tar.bz2
# then, DROPBEAR_VERSION="2020.81"

DROPBEAR_VERSION="2020.81"

# !!! NOTE: You don't need to modify this srcipt beyond here !!!
# -------------------- Toolchain Setup ---------------------

TARGET_TRIPLE="${TARGET_ARCH}-linux-gnu"
if [ "$TARGET_ARCH" = "arm" ]; then
    TARGET_TRIPLE="${TARGET_TRIPLE}eabihf"
fi

TARGET_TOOLCHAIN_PREFIX="${TARGET_TRIPLE}-"

# TODO: We assume the host is an x86 machine
if [ "$TARGET_ARCH" = "x86" ]; then
    TARGET_TOOLCHAIN_PREFIX=""
fi

if [ -n "$TARGET_TOOLCHAIN_PREFIX" ]; then
    PACKAGED_TAGET_GCC_TOOLCHAIN="gcc-${TARGET_TRIPLE}"
    PACKAGED_TAGET_GPP_TOOLCHAIN="g++-${TARGET_TRIPLE}"
    
    which $PACKAGED_TAGET_GCC_TOOLCHAIN
    if [ $? -ne 0 ]; then
        echo "Downloading required toolchain: ${PACKAGED_TAGET_GCC_TOOLCHAIN}"
        sudo apt -y install $PACKAGED_TAGET_GCC_TOOLCHAIN
    fi

    which $PACKAGED_TAGET_GCC_TOOLCHAIN
    if [ $? -ne 0 ]; then
        echo "Downloading required toolchain: ${PACKAGED_TAGET_GCC_TOOLCHAIN}"
        sudo apt -y install $PACKAGED_TAGET_GCC_TOOLCHAIN
    fi
fi


# -------------------- Busybox Setup ---------------------
BUSYBOX_DIR="busybox"
BUSYBOX_FILE_EXTENSION="tar.bz2"
BUSYBOX_DOWNLOAD_FILE="busybox-${BUSYBOX_VERSION}.${BUSYBOX_FILE_EXTENSION}"
BUSYBOX_DOWNLOAD_DOMAIN="https://www.busybox.net/downloads"
BUSYBOX_DOWNLOAD_URL="${BUSYBOX_DOWNLOAD_DOMAIN}/${BUSYBOX_DOWNLOAD_FILE}"
BUSYBOX_EXTRACT_DIR="busybox-${BUSYBOX_VERSION}"

echo "Downloading $BUSYBOX_DOWNLOAD_URL"

wget $BUSYBOX_DOWNLOAD_URL

rm -rf $BUSYBOX_DIR
tar -xvf $BUSYBOX_DOWNLOAD_FILE
rm $BUSYBOX_DOWNLOAD_FILE
mv $BUSYBOX_EXTRACT_DIR $BUSYBOX_DIR
cd $BUSYBOX_DIR

# Generate the default busybox .config
if [ -z "$TARGET_TOOLCHAIN_PREFIX" ]; then
    make defconfig
else
    ARCH=$TARGET_ARCH CROSS_COMPILE=$TARGET_TOOLCHAIN_PREFIX make defconfig
fi

# Configure busybox to be built as a static binary
sed -i 's/# CONFIG_STATIC is not set/CONFIG_STATIC=y/' .config

# Build busybox
if [ -z "$TARGET_TOOLCHAIN_PREFIX" ]; then
    make -j8
    make install -j8
else
    ARCH=$TARGET_ARCH CROSS_COMPILE=$TARGET_TOOLCHAIN make -j8
    ARCH=$TARGET_ARCH CROSS_COMPILE=$TARGET_TOOLCHAIN make install -j8
fi

echo $PWD
cd ..
echo $PWD

# -------------------- Dropbear Setup ---------------------
# TODO: Dropbear automation
