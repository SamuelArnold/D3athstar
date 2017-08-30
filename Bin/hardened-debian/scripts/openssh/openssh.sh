#!/bin/bash
# Michael Jack

# Downloads OpenSSH and zlib
# Intstalls zlib and OpenSSH
# Will work as a drop in install, doesn't edit ssh[d]_config

# Imports
#source /scripts/libressl.sh

# Variables
OPENSSHVERSION="7.5p1"
# http://blog.djm.net.au/2013/12/pgp-keys-rotated.html
OPENSSHSIGNINGKEYFINGERPRINT="59C2118ED206D927E667EBE3D3E5F56B6D920D30"
ZLIBVERSION="1.2.11"
INSTALL_DEPENDANCiIES="libncurses5 libncurses5-dev build-essential fakeroot kernel-package gcc-4.9 gcc-4.9-plugin-dev make"

main() {

  sudo apt-get install $INSTALL_DEPENDANCiIES
  cp zlib-$ZLIBVERSION.sha256 /tmp

  getOpenSSH
  getZlib
  installZlib
  installOpenSSH

  # Check that the compiled binary works with currnt /etc/sshd_config
  sudo sshd -t

}

getOpenSSH () {

cd /tmp

# Download OpenSSH, PGP signature and their public key
wget http://ftp.spline.de/pub/OpenBSD/OpenSSH/portable/openssh-$OPENSSHVERSION.tar.gz
wget http://ftp.spline.de/pub/OpenBSD/OpenSSH/portable/openssh-$OPENSSHVERSION.tar.gz.asc

echo "[INFO] Fetching OpenSSH singing key"
if gpg --keyserver hkp://keys.gnupg.net --recv-keys $OPENSSHSIGNINGKEYFINGERPRINT;
then
  echo "[INFO] OpenSSH signing key fetched"
else
  echo "[FAILURE] OpenSSH signing key not downloaded"
  exit 1
fi

if gpg --verify openssh-$OPENSSHVERSION.tar.gz.asc openssh-$OPENSSHVERSION.tar.gz;
then
  echo "[INFO] GPG Signature verification passed"
  # Extract source
  echo "[INFO] Extracting OpenSSH source"
  tar -zxf openssh-$OPENSSHVERSION.tar.gz
else
  echo "[FAILURE] WARNING OpenSSH GPG signature verification failed!"
  exit 1
fi

}

installOpenSSH () {

cd /tmp/openssh-$OPENSSHVERSION

# Install OpenSSL development libraries & header files
# https://packages.debian.org/jessie/libssl-dev
apt-get install libssl-dev -y

# TODO: Add configure flags. --with-ssl-dir=/opt/libressl
./configure --sysconfdir=/etc/ssh
make
sudo make install

}

getZlib () {

# Download zlib tar.gz
# You can double check the MD5 this script verifies at http://www.zlib.net/
if wget -q "http://zlib.net/zlib-$ZLIBVERSION.tar.gz";
then
    echo "[INFO] zlib downloaded"
else
    echo "[FAILURE] Can't Download zlib"
    exit 1
fi

# Compare SHA256 hashes
if sha256sum -c zlib-$ZLIBVERSION.sha256;
then
  echo "[INFO] zlib SHA256 hashes matched"
  echo "[INFO] Extracting zlib source"
  tar -zxf zlib-$ZLIBVERSION.tar.gz
else
  echo "[FAILURE] WARNING zlib SHA256 hashes did NOT match!"
  exit 1
fi

}

installZlib () {

cd /tmp/zlib-$ZLIBVERSION

./configure
make
sudo make install

}

sshCheck () {

if [ sudo sshd -t ];
then
  echo "[INFO] sshd -t PASSED"
  pass
else
  echo "[WARNING] sshd -t FAILED"
  echo "[FATAL] Exiting..."

  exit 1

fi
}

moduliCheck () {

if [ ! -f /etc/ssh/moduli ];
then
  echo "[INFO] Moduli file not found!"
  echo "[INFO] Generating a new moduli file"
  generateModuli
  # Generate new moduli file

else
  echo "[INFO] Moduli file found!"

  echo "[INFO] Current moduli file backed up as /etc/ssh/moduli.backup"
  cp /etc/ssh/moduli /etc/ssh/moduli.backup
  # backup moduli file
  # we do not remove the backup file see: https://github.com/0xmikey/hardened-debian/issues/9

  echo "[INFO] Removing all parameters less than 2000-bits from moduli"
  awk '$5 > 2000' /etc/ssh/moduli > "/etc/ssh/moduli.checked"
  # Remove all parameters less than 2000-bits in size and pipe the rest into a new temp file
  if [ -s /etc/ssh/moduli.checked ];
  then
    echo "[INFO] Installing new moduli file."
    # Replace old moduli file
    mv /etc/ssh/moduli.checked /etc/ssh/moduli
    rm /etc/ssh/moduli.checked

    sshCheck

  else
    echo "[WARNING] Moduli.check EMPTY"
    echo "[WARNING] We trimmed too much"

    echo "[INFO] Generating a new moduli file"
    echo "[WARNING] Will override /etc/ssh/moduli"
    generateModuli
    # Generate new moduli file
  fi

fi

}

generateModuli () {
  # see: https://security.stackexchange.com/questions/79043/is-it-considered-worth-it-to-replace-opensshs-moduli-file
  # WARNING: This function will overwrite whatever file is located at /etc/ssh/moduli at the time this function is executed

  echo "[INFO] About to generate candidate prime numbers to create a new moduli file"
  echo "[INFO] This can take several minutes..."
  sleep 2
  ssh-keygen -G moduli-2048.candidates -b 2048
  # Generate candidate primes for DH-Key Exchange
  # -b 2048 indicates the primes should be 2048-bits in size
  echo "[INFO] About to test candidate primes for primality"
  ssh-keygen -T moduli-2048 -f moduli-2048.candidates
  # Check the candidate primes for primality
  # Will produce a file, moduli-2048, that contains the safe primes

  echo "[INFO] Installing new moduli file."
  mv moduli-2048 /etc/ssh/moduli
  # intsall our safe moduli file

  sshCheck
}



main "$@"
