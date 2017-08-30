#!/bin/bash
# Michael Jack

# Downloads LibreSSL source and verifys pgp signature
# (Install requires ROOT)
# Installs LibreSSL 2.4.0 (31/5/16)
# Installs to /opt/libressl/

main() {
    getLibreSSL
    installLibreSSL
}

# Varaibles
LIBRESSL_VERSION="2.4.2"

# Functions
getLibreSSL () {

  cd /tmp

  # Dowbload libressl, gpg signature & their public key
  wget http://ftp.openbsd.org/pub/OpenBSD/LibreSSL/libressl-2.4.0.tar.gz
  wget http://ftp.openbsd.org/pub/OpenBSD/LibreSSL/libressl-2.4.0.tar.gz.asc
  wget http://ftp.openbsd.org/pub/OpenBSD/LibreSSL/libressl.asc

  # import libressl public key
  gpg --import libressl.asc

  if gpg --verify libressl-2.4.0.tar.gz.asc;
  then
  	echo "[INFO] GPG Signature verifaction passed"
  	echo "[INFO] Extracting tar.gz archive"
  	tar -zxf libressl-2.4.0.tar.gz
  else
  	echo "[FAILURE] WARNING LibreSSL GPG signature verification failed!"
  	exit 1
  fi
}

installLibreSSL () {

# http://penzin.net/libressl.html

cd libressl-2.4.0/

./configure --prefix=/opt/libressl
make
echo "[INFO] 'make install' & 'ldconfig' requires ROOT"
sudo make install
# Reconfigure dynamic linker run-time bindings
# Installing to /opt do we need this if we're no
# longer replacing the OpenSSL binary?
#sudo ldconfig

# Check if `openssl version` produces "LibreSSL"
if [[ $(/opt/libressl/bin/openssl version | awk '{print $1}') == "LibreSSL" ]] && [[ $(/opt/libressl/bin/openssl version | awk '{print $2}') == $LIBRESSL_VERSION ]]; then
  echo "[INFO] LibreSSL $INSTALLED_LIBRESSL_VERSION installed to /opt/libressl \o/"
else
  echo "[FAILURE] Something went wrong with the LibreSSL install."
  echo "[INFO] The error messages above and/or below should help :)"
  exit 1
fi

}

main "$@"
