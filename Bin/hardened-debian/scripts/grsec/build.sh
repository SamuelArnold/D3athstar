#!/bin/bash

# Michael Jack
# Mostly based on the below guide by @micahflee
# Guide: https://micahflee.com/2016/01/debian-grsecurity/

# Downloads linux stable kernel & grsec patch,
# verifys PGP signatures. If valid pacths the
# kernel with grsec testing patch, compiles
# kernel and outputs .deb


## - - - Variables - - - ##

KERNEL_VERSION="4.9.23"
GRSEC_VERSION="3.1-4.9.23-201704181901"
# Kernel signing key info: https://kernel.org/category/signatures.html
# Greg Kroah-Hartman (Linux kernel stable release signing key)
KERNEL_SIGNING_FINGERPRINT="647F28654894E3BD457199BE38DBBDC86092693E"
CURRENT_KERNEL_RELEASE=$(uname -r)
TEMPDIR=("/tmp/harden-debian")
INSTALL_DEPENDANCiIES="libncurses5 libncurses5-dev build-essential fakeroot kernel-package gcc-4.9 gcc-4.9-plugin-dev make"


## - - - Setup - - - ##

# Shout at User
echo "[WARNING] This script will need your attention during its execution"
echo "[WARNING] You might want to stick around."
# Stall for 5 seconds so user can be shouted at
sleep 5

# !!! Starts doing shit to box here !!!

# Create a folder in /tmp to make our mess in
if [ ! -d "$TEMPDIR" ]
then
    mkdir $TEMPDIR
else
    rm -r $TEMPDIR
    mkdir $TEMPDIR
fi

# Copy our configs etc to /tmp/harden-debian
cp .config $TEMPDIR

# Drop into /tmp to start working
cd $TEMPDIR

# Intall compiling dependancies
# TODO: Reenable this when auto compiling is implimented
# WARNING sudo is used here
echo "[INFO] Installing compiling dependancies using apt-get install -y which requires ROOT"
# At the momennt Jessie repos don't carry the gcc-5.x packages, latest is 4.9
# However testing & unstable repos carry the 5.x package. Possible TODO ??

export DEBIAN_FRONTEND=noninteractive
# Forces default answers to be used for any questions asked by installers
# needed in addition to -y see: https://github.com/0xmikey/hardened-debian/issues/11
sudo apt-get install $INSTALL_DEPENDANCiIES -y
export DEBIAN_FRONTEND=''
# Unexport this so it doesn't mess with any kerenl config menus later

## - - - Downloads & Verification - - - ##

# grsec patch, signature & signing keya
if [ ! -f "grsecurity-$GRSEC_VERSION.patch" ] && [ ! -f "grsecurity-$GRSEC_VERSION.patch.sig" ]
then
wget https://grsecurity.net/test/grsecurity-$GRSEC_VERSION.patch
wget https://grsecurity.net/test/grsecurity-$GRSEC_VERSION.patch.sig

fi

# Kernel source, signature & signing key
if [ ! -a "linux-$KERNEL_VERSION.tar.xz" ]
then
  wget https://cdn.kernel.org/pub/linux/kernel/v4.x/linux-$KERNEL_VERSION.tar.xz
  wget https://cdn.kernel.org/pub/linux/kernel/v4.x/linux-$KERNEL_VERSION.tar.sign
fi

sleep 2


# Kernel signing key info: https://kernel.org/category/signatures.html
echo "[INFO] Fetching kernel singing key"
if gpg --keyserver hkp://keys.gnupg.net --recv-keys $KERNEL_SIGNING_FINGERPRINT;
then
  echo "[INFO] Kernel signing key fetched"
else
  echo "[FAILURE] Kernel signing key not downloaded"
  exit 1
fi

# Import grsec signing key into gpg keyring
# Current key as of June 10 2016
echo "[INFO] Trying to acquire grsec siging key"
if gpg --import spender-gpg-key.asc;
then
    echo "[INFO] Imported grsec siging key"
    if gpg --verify grsecurity-$GRSEC_VERSION.patch.sig grsecurity-$GRSEC_VERSION.patch;
    then
        echo "[INFO] GPG Signature verification passed"
    else
        echo "[FAILURE] WARNING grsec GPG signature verification failed!"
        exit 1
    fi
else
    echo "[INFO] No grsec signing key, attempting to download it."
    if wget https://grsecurity.net/spender-gpg-key.asc;
    then
        if gpg --import spender-gpg-key.asc;
        then
            echo "[INFO] Imported grsec siging key"
            if gpg --verify grsecurity-$GRSEC_VERSION.patch.sig grsecurity-$GRSEC_VERSION.patch;
            then
                echo "[INFO] GPG Signature verification passed"
            else
                echo "[FAILURE] WARNING grsec GPG signature verification failed!"
                exit 1
            fi
        else
            echo "[FAILURE] Can't import grsec GPG key"
            exit 1
        fi
    else
        echo "[FAILURE] Can't download grsec GPG key"
        exit 1
fi

# relax, take it easy
sleep 2

## - - - Extraction & Patching - - - ##

# Extract kernel source
echo "[INFO] Extracting kernel source"

if [ ! -a "linux-$KERNEL_VERSION" ]
then
  xz -d linux-$KERNEL_VERSION.tar.xz
fi

if gpg --verify linux-$KERNEL_VERSION.tar.sign linux-$KERNEL_VERSION.tar;
then
  echo "[INFO] kernel GPG Signature verification passed"
  # Extract the .tar and drop into the newly created directory
  tar -xf linux-$KERNEL_VERSION.tar
  cd linux-$KERNEL_VERSION

  # Patch kernel with grsec
  echo "[INFO] Patching kernel source with grsec"
  patch -p1 < ../grsecurity-$GRSEC_VERSION.patch

  echo "[INFO] Coping current kernel configuration into .config"
  echo "[INFO] We will use it as a base to configure grsec"
  cp /boot/config-$CURRENT_KERNEL_RELEASE .config
else
  echo "[FAILURE] WARNING kernel GPG signature verification failed!"
  exit 1
fi

## - - - Compiling - - - ##

cp $TEMPDIR/.config $TEMPDIR/linux-$KERNEL_VERSION

echo "[WARNING] We are about to compile the patched kernel, this will take long time."
echo "[INFO]    When finished you should have a .deb file."
sleep 5
#export CONCURRENCY_LEVEL="$(grep -c '^processor' /proc/cpuinfo)"
# Use all CPU cores while compiling

fakeroot make clean
fakeroot make deb-pkg --initrd kernel_image
# Fake root enviroment so we don't have to use sudo
# https://wiki.debian.org/FakeRoot

# sudo dpkg -i linux-image-$KERNEL_VERSION-grsec_$KERNEL_VERSION-grsec-10.00.Custom_amd64.deb

echo "[INFO] I've yet to automate configuring the kernel, you can follow the"
echo "[INFO] rest of @micahflee guide: https://micahflee.com/2016/01/debian-grsecurity/"
echo "[INFO] This script has completed up to the make menuconfig command in the guide"

exit 0
