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

TARGET_ARCH="x86"

# You can find the latest version number at
#     https://www.busybox.net/downloads
#
# You only need to specify the version number
# Example: If the latest release is:
#    busybox-1.32.0.tar.bz2
# then, BUSYBOX_VERSION="1.32.0"


BUSYBOX_VERSION="1.32.0"

# You can find the latest version number at:
#     https://matt.ucc.asn.au/dropbear/releases
#
# You only need to specify the version number
# Example: If the latest release is:
#    dropbear-2020.81.tar.bz2
# then, DROPBEAR_VERSION="2020.81"

DROPBEAR_VERSION="2020.81"

# You can find the latest version number at:
#     http://ftp.gnu.org/gnu/glibc
#
# You only need to specify the version number
# Example: If the latest release is:
#    glibc-2.32.tar.bz2
# then, GLIBC_VERSION="2.32"

GLIBC_VERSION="2.32"


# !!! NOTE: You don't need to modify this srcipt beyond here !!!



# Bail out on first error
set -e

# Create initramfs directory
INITRAMFS_DIR="${PWD}/initramfs"
INIT_FILE="${INITRAMFS_DIR}/init"

rm -rf $INITRAMFS_DIR
mkdir $INITRAMFS_DIR

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
    
    # which $PACKAGED_TAGET_GCC_TOOLCHAIN
    # if [ $? -ne 0 ]; then
        echo "Downloading required toolchain: ${PACKAGED_TAGET_GCC_TOOLCHAIN}"
        sudo apt -y install $PACKAGED_TAGET_GCC_TOOLCHAIN
    # fi

    # which $PACKAGED_TAGET_GCC_TOOLCHAIN
    # if [ $? -ne 0 ]; then
        echo "Downloading required toolchain: ${PACKAGED_TAGET_GCC_TOOLCHAIN}"
        sudo apt -y install $PACKAGED_TAGET_GCC_TOOLCHAIN
    # fi
fi


# -------------------- Busybox Setup ---------------------
BUSYBOX_DIR="${PWD}/busybox"
BUSYBOX_OUT_DIR="${BUSYBOX_DIR}/_install"
BUSYBOX_FILE_EXTENSION="tar.bz2"
BUSYBOX_DOWNLOAD_FILE="busybox-${BUSYBOX_VERSION}.${BUSYBOX_FILE_EXTENSION}"
BUSYBOX_DOWNLOAD_DOMAIN="https://www.busybox.net/downloads"
BUSYBOX_DOWNLOAD_URL="${BUSYBOX_DOWNLOAD_DOMAIN}/${BUSYBOX_DOWNLOAD_FILE}"
BUSYBOX_EXTRACT_DIR="busybox-${BUSYBOX_VERSION}"

# echo "Downloading $BUSYBOX_DOWNLOAD_URL"

# wget $BUSYBOX_DOWNLOAD_URL

# rm -rf $BUSYBOX_DIR
# tar -xvf $BUSYBOX_DOWNLOAD_FILE
# rm $BUSYBOX_DOWNLOAD_FILE
# mv $BUSYBOX_EXTRACT_DIR $BUSYBOX_DIR

# cd $BUSYBOX_DIR

# # Generate the default busybox .config
# if [ -z "$TARGET_TOOLCHAIN_PREFIX" ]; then
#     make defconfig
# else
#     ARCH=$TARGET_ARCH CROSS_COMPILE=$TARGET_TOOLCHAIN_PREFIX make defconfig
# fi

# # Configure busybox to be built as a static binary
# sed -i 's/# CONFIG_STATIC is not set/CONFIG_STATIC=y/' .config

# # Build busybox
# if [ -z "$TARGET_TOOLCHAIN_PREFIX" ]; then
#     make -j8
#     make install -j8
# else
#     ARCH=$TARGET_ARCH CROSS_COMPILE=$TARGET_TOOLCHAIN make -j8
#     ARCH=$TARGET_ARCH CROSS_COMPILE=$TARGET_TOOLCHAIN make install -j8
# fi

# cd ..


# -------------------- Dropbear Setup ---------------------
DROPBEAR_DIR="${PWD}/dropbear"
DROPBEAR_OUT_DIR="${DROPBEAR_DIR}/out"
DROPBEAR_FILE_EXTENSION="tar.bz2"
DROPBEAR_DOWNLOAD_FILE="dropbear-${DROPBEAR_VERSION}.${DROPBEAR_FILE_EXTENSION}"
DROPBEAR_DOWNLOAD_DOMAIN="https://matt.ucc.asn.au/dropbear/releases"
DROPBEAR_DOWNLOAD_URL="${DROPBEAR_DOWNLOAD_DOMAIN}/${DROPBEAR_DOWNLOAD_FILE}"
DROPBEAR_EXTRACT_DIR="dropbear-${DROPBEAR_VERSION}"

# echo "Downloading $DROPBEAR_DOWNLOAD_URL"

# wget $DROPBEAR_DOWNLOAD_URL

# rm -rf $DROPBEAR_DIR
# tar -xvf $DROPBEAR_DOWNLOAD_FILE
# rm $DROPBEAR_DOWNLOAD_FILE
# mv $DROPBEAR_EXTRACT_DIR $DROPBEAR_DIR

# cd $DROPBEAR_DIR

# # Create an out directory
# rm -rf $DROPBEAR_OUT_DIR
# mkdir $DROPBEAR_OUT_DIR

# # Configure dropbear
# if [ -z "$TARGET_TOOLCHAIN_PREFIX" ]; then
#     ./configure --enable-static --disable-zlib --prefix="${DROPBEAR_OUT_DIR}"
# else
#     ./configure --host=$TARGET_TRIPLE --enable-static --disable-zlib --prefix="${DROPBEAR_OUT_DIR}" CC="${TARGET_TOOLCHAIN_PREFIX}gcc" LD="${TARGET_TOOLCHAIN_PREFIX}ld"
# fi

# # Make dropbear
# make -j8
# time make -j8 install

# cd ..


# -------------------- glibc Setup ---------------------
# We need latest gawk to compile gcc
sudo apt install gawk

GLIBC_DIR="${PWD}/glibc"
GLIBC_OUT_DIR="${GLIBC_DIR}/out"
GLIBC_FILE_EXTENSION="tar.bz2"
GLIBC_DOWNLOAD_FILE="glibc-${GLIBC_VERSION}.${GLIBC_FILE_EXTENSION}"
GLIBC_DOWNLOAD_DOMAIN="http://ftp.gnu.org/gnu/glibc"
GLIBC_DOWNLOAD_URL="${GLIBC_DOWNLOAD_DOMAIN}/${GLIBC_DOWNLOAD_FILE}"
GLIBC_EXTRACT_DIR="glibc-${GLIBC_VERSION}"

echo "Downloading $GLIBC_DOWNLOAD_URL"

wget $GLIBC_DOWNLOAD_URL

rm -rf $GLIBC_DIR
tar -xvf $GLIBC_DOWNLOAD_FILE
rm $GLIBC_DOWNLOAD_FILE
mv $GLIBC_EXTRACT_DIR $GLIBC_DIR

cd $GLIBC_DIR

# Create an out directory
rm -rf $GLIBC_OUT_DIR
mkdir $GLIBC_OUT_DIR

cd $GLIBC_OUT_DIR

# Configure glibc
if [ -z "$TARGET_TOOLCHAIN_PREFIX" ]; then
    ${GLIBC_DIR}/configure --enable-static --disable-zlib --prefix="${GLIBC_OUT_DIR}" --enable-add-ons
else
    ${GLIBC_DIR}/configure --host=$TARGET_TRIPLE --enable-static --disable-zlib --prefix="${GLIBC_OUT_DIR}" --enable-add-ons CC="${TARGET_TOOLCHAIN_PREFIX}gcc" LD="${TARGET_TOOLCHAIN_PREFIX}ld"
fi

# Make glibc
make -j8
time make install install_root=${INITRAMFS_DIR} -j8

cd $GLIBC_DIR
cd ..


# -------------------- Initramfs Setup ---------------------
cd $INITRAMFS_DIR


# Prepare basic structure and copy basic files and bins
# This assumes dropbear and busybox are built static
mkdir -p ${INITRAMFS_DIR}/{bin,dev,etc/dropbear,lib64,mnt/root,proc,root/.ssh,sys,usr/sbin,var/log,var/run,home/root}
cp -a ${BUSYBOX_OUT_DIR}/* ${INITRAMFS_DIR}/
cp -a ${DROPBEAR_OUT_DIR}/* ${INITRAMFS_DIR}/
cp -a /etc/localtime ${INITRAMFS_DIR}/etc/

echo "HERE !!!"

# Copy the authorized keys for your regular user you administrate with
cp $HOME/.ssh/authorized_keys ${INITRAMFS_DIR}/root/.ssh/authorize_keys
chmod 700 ${INITRAMFS_DIR}/root/.ssh
chmod 600 ${INITRAMFS_DIR}/root/.ssh/authorize_keys

# Generate SSH server keys
HOST_RSA_KEY="/etc/ssh/ssh_host_rsa_key"
HOST_DSA_KEY="/etc/ssh/ssh_host_dsa_key"
HOST_ECDSA_KEY="/etc/ssh/ssh_host_ecdsa_key"

if [ ! -f "$HOST_RSA_KEY" ]; then
    sudo ssh-keygen -f $HOST_RSA_KEY -N '' -t rsa
fi
if [ ! -f "$HOST_DSA_KEY" ]; then
    sudo ssh-keygen -f $HOST_DSA_KEY -N '' -t dsa
fi
if [ ! -f "$HOST_ECDSA_KEY" ]; then
    sudo ssh-keygen -f $HOST_ECDSA_KEY -N '' -t ecdsa -b 521
fi

# Copy OpenSSH's host keys to keep both initramfs' and regular ssh signed the same
# otherwise openssh clients will see different host keys and chicken out. Here we only copy the
# ecdsa host key, because ecdsa is default with OpenSSH. For RSA and others, copy adequate keyfile.
sudo -s -- <<EOF
${INITRAMFS_DIR}/bin/dropbearconvert openssh dropbear ${HOST_RSA_KEY} ${INITRAMFS_DIR}/etc/dropbear/dropbear_rsa_host_key
${INITRAMFS_DIR}/bin/dropbearconvert openssh dropbear ${HOST_DSA_KEY} ${INITRAMFS_DIR}/etc/dropbear/dropbear_dsa_host_key
${INITRAMFS_DIR}/bin/dropbearconvert openssh dropbear ${HOST_ECDSA_KEY} ${INITRAMFS_DIR}/etc/dropbear/dropbear_ecdsa_host_key
EOF

# These two libs are needed for dropbear, even if it's built statically, because we don't use PAM
# and dropbear uses libnss to find user to authenticate against
# TODO: Determine if this is needed
# cp -L /lib64/libnss_compat.so.2 ${INITRAMFS}/lib64/
# cp -L /lib64/libnss_files.so.2 ${INITRAMFS}/lib64

# Basic system defaults
echo "root:x:0:0:root:/root:/bin/sh" > ${INITRAMFS_DIR}/etc/passwd
echo "root:*:::::::" > ${INITRAMFS_DIR}/etc/shadow
echo "root:x:0:root" > ${INITRAMFS_DIR}/etc/group
echo "/bin/sh" > ${INITRAMFS_DIR}/etc/shells
chmod 640 ${INITRAMFS_DIR}/etc/shadow

cat << EOF > ${INITRAMFS_DIR}/etc/nsswitch.conf
passwd:	files
shadow:	files
group:	files
EOF

# # For each of the non-static binary listed above, copy the required libs
# # Note: lddtree belongs to app-misc/pax-utils the newer versions of which
# # can automatically copy the whole lib tree with --copy-to-tree option
# for B in $BINS; do
# 	for L in $(lddtree -l $B); do
# 		DIR=$(dirname $L)
# 		mkdir -p ${INITRAMFS_DIR}${DIR}
# 		cp -L $L ${INITRAMFS_DIR}${L}
# 	done
# done

# Basic INIT SCRIPT
cat << EOF > ${INIT_FILE}
#!/bin/busybox sh

# # These defaults should rarely change between machines so they're coded here instead of
# # taking values from the kernel command line. You might wish to use a nonstandard SSH port, tho'.
# # We use "root" for the root mapper to be consistent with genkernel's implementation that
# # unlocks the root into /dev/mapper/root, but really it's arbitrary and could be anything
# NET_NIC="eth0"
# SSH_PORT="22"
# MAPPER="root"

# /bin/busybox mkdir -p /usr/sbin /usr/bin /sbin /bin
# /bin/busybox --install -s
# touch /var/log/lastlog

mount -t devtmpfs none /dev
mount -t proc proc /proc
mount -t sysfs none /sys

# # Root partition and networking could be different between machines so take those configs from the
# # kernel command line
# for x in \$(cat /proc/cmdline); do
#    case "\${x}" in
#       crypt_root=*)
#          CRYPT_ROOT=\${x#*=}
#       ;;
#       net_ipv4=*)
#          NET_IPv4=\${x#*=}
#       ;;
#       net_gw=*)
#          NET_GW=\${x#*=}
#       ;;
#    esac
# done

# # Bootstrap the network
# ifconfig ${NET_NIC} \${NET_IPv4}
# route add default gw \${NET_GW}

# # Fix for no dropbear
# if ! [ -d /dev/pts ]; then mkdir /dev/pts; fi
# mount -t devpts none /dev/pts

# ifconfig eth0 up
# udhcpc -i eth0 -t 5 -q -s /bin/simple.script

# # Start dropbear sshd
# /sbin/dropbear -s -g -p $SSH_PORT -B

# sleep 1
# clear
# echo "Waiting for root unlock..."

# # Wait for the unlocked root mapper to appear
# while [ ! -e /dev/mapper/${MAPPER} ]; do
# 	sleep 1
# done
# mount -o ro /dev/mapper/${MAPPER} /mnt/root

cat <<!

[ INFO ] : Started dropbear"

[ INFO ] : Boot took $(cut -d' ' -f1 /proc/uptime) seconds
    _  _
   / /(_)_ __  _   ___  __
  / / | | '_ \| | | \ \/ /
 / /__| | | | | |_| |>  <
 \____/_|_| |_|\__,_/_/\_\


[ INFO ] : Starting BusyBox . . .

!

exec /bin/sh

EOF


# Make init executable
chmod +x $INIT_FILE

# Create initramfs cpio
sudo -s -- <<EOF
find . -print0 | cpio --null -ov --format=newc | gzip -9 > ../initramfs.cpio.gz
EOF

cd ..

# ---------------------------------------------------------------
