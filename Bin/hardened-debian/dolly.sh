#!/bin/bash
# mikey

if [[ $_ != $0 ]]
# https://stackoverflow.com/questions/2683279/how-to-detect-if-a-script-is-being-sourced
# https://unix.stackexchange.com/questions/280453/understand-the-meaning-of
then
     cd ../
     rm -rf hardened-debian/
     git clone -b grsec-hardened-stable-kernel git@github.com:0xmikey/hardened-debian.git
     cd hardened-debian/
else
    echo "[i] Usage: . dolly.sh"
    exit 1

fi
