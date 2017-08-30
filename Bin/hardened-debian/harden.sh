#!/bin/bash

# Michael Jack
# Basic debian hardening steps

# Variables
OS_CODENAME=$(lsb_release -c | awk '{print $2}')
OSID=$(lsb_release -i | awk '{print $3}')
# REQUIREDOS_CODENAME="jessie"
# REQUIREDOSID="Debian"
INSTALLPACKAGES="needrestart apt-transport-https unattended-upgrades"

# Check if ROOT
if [[ $EUID -ne 0 ]]; then
    echo "[FAILURE] This script must be run as ROOT, 'sudo !!' to run it again as ROOT :)" 1>&2
    exit 1
fi

# Check if Debian jessie
#if [[ $OSID != "Debian" ]] && [[ $OS_CODENAME != "jessie" ]]; then
#	echo "[FAILURE] This is $OSID $OS_CODENAME, this script has only been tested on Debian jessie"
#        exit 1
#fi

# TODO: Non-root user should be mandatory?
echo "[QUESTION] Add a non-root user? [Y/n]"
read ROOTANSWER
if [[ $ROOTANSWER == "yes" ]] || [[ $ROOTANSWER == "y" ]] || [[ $ROOTANSWER == "" ]]; then
        echo "[QUESTION] Username for non-root user?"
        read NONROOTUSERNAME
        adduser $NONROOTUSERNAME
        # Adduser to sudo group
        adduser $NONROOTUSERNAME sudo
else
        echo "[WARNING] Working as a non-root users is highly recomended"
fi

# Copy configs to /tmp
# Order: unattended-upgrades, ssh, sshd.
cp etc/apt/apt.conf.d/20auto-upgrades /tmp
cp etc/ssh/ssh_config                     /tmp
cp etc/ssh/sshd_config                    /tmp

# drop into /tmp before we pull anything on to the box
cd /tmp

echo "[INFO] Updating your system"
sleep 2
# re-synchronize the package index files from their sources, always do this before upgrade
apt-get update
# install the newest versions of all packages currently installed on the system
apt-get upgrade -y

# Install required packages here
echo "[INFO] Installing packages $INSTALL_PACKAGES"
sleep 2
apt-get install $INSTALL_PACKAGES -y

echo "[INFO] Clearing up package cache & unneeded dependancies"
# Clears local cache of package files that can no longer be downloaded
apt-get autoclean -y

# Removes packages installed to satisfy deps but are no longer needed
apt-get autoremove -y

echo "[INFO] Enabling unattended-upgrades"
cp /tmp/20auto-upgrades /etc/apt/apt.conf.d/20auto-upgrades

echo "[INFO] Installing SSH configurations"
sleep 2
cp /tmp/ssh_config /etc/ssh/
cp /tmp/sshd_config /etc/ssh

# Check sshd_config syntax
# if correct reload the ssh service so config chnages take effect

echo "[INFO] You should now populate fields like ip address and allowed users in /etc/ssh/sshd_config"
echo "[INFO] Once you're done with sshd_config run sshd -t to check the syntax of sshd_config"
echo "[INFO] If sshd -t returns no errors run service ssh reload to enable to the configuration"
echo "[INFO] Finished :)"
# TODO: iptables firewall rules
# TODO: iptables-restore
