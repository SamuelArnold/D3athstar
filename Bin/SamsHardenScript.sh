#!/bin/bash
########################################
# Created By Sam Arnold  on 8/5/17
# Goal: to Create a s script to Harden 
# Debian - Linux to Lynis Hardening Tests
#
########################################
#
#
#
###########################
#Fix: Install Some Security programs
###########################
echo -e "###########################"
echo -e "Fix: Install some Programs to harden the machine"
echo -e "###########################\n"
sudo apt-get install libpam-tmpdir 
sudo apt-get install libpam-usb 
sudo apt-get install apt-listbugs  # Really cool. Will show you programs with bugs
sudo apt-get install needrestart 
sudo apt-get install debsecan 
sudo apt-get install debsums 
sudo apt-get install needrestart 
sudo apt-get install libpam-usb pamusb-common
sudo apt-get install debian-goodies 
sudo apt-get install debsecan  #might want to run deb scan after?
sudo apt-get install debsums 
sudo apt-get install pam_cracklib # or pam_passwdqc 

#Set up Fail To ban
sudo apt-get install fail2ban
sudo apt-get install sendmail
sudo systemctl start fail2ban endmail-bin
sudo systemctl enable fail2ban
sudo systemctl start sendmail
sudo systemctl enable sendmail
sudo ufw allow ssh # allow SSH through firewall
sudo ufw enable # allow ssh through Firewall
cp /etc/fail2ban/fail2ban.conf /etc/fail2ban/fail2ban.local
cp /etc/fail2ban/jail.conf /etc/fail2ban/jail.local

sudo auditctl -a exit,always -F path=/etc/passwd -F perm=wa  #audit password
sudo apt-get install libapache2-mod-security2 libapache2-modsecurity libapache2-mod-e vasive 
#sudo sysctl -e  -p /etc/sysctl.conf
#sudo echo -e "search test.com" >>  /etc/resolv.conf 
#
#
#
###########################
#Fix: harden Some kernal 
###########################
echo -e "###########################"
echo -e "#harden Some kernelsss boys"
echo -e "###########################\n" 
sudo cp sysctl.conf /etc/sysctl.conf # Change Configuration to Lynis standards + 10 pts 
sudo sysctl -e  -p /etc/sysctl.conf
#sudo sysctl -p
#sudo umask 027
#
#
#
# do more stuff here. https://www.rosehosting.com/blog/how-to-install-mod_security-and-mod_evasive-on-an-ubuntu-14-04-vps
echo -e "###########################"
echo -e "Do Some Apache Garbage I Forgot to do."
echo -e "###########################\n"
sudo service apache2 restart 
export TMOUT=120 # Change logout time 
#
#
#
###########################
#App Armor????
###########################
#Get app Armor Start App Armor
#apt-get install -y apparmor-profiles apparmor apparmor-utils
#sudo add-apt-repository ppa:apparmor-upload/apparmor-2.8
#app Armor Start
#rcapparmor start
#aa-status
#systemctl status apparmor  # Checks status of the AppArmor service and tells you if it is enabled on boot
#systemctl start apparmor  # Starts the service
#systemctl enable apparmor  # Makes apparmor start on boot
#sudo sysctl -e  -p /etc/sysctl.conf
#
#
#
###########################
##Fix: Require the root password to enter single user mode. 
#Modify /etc/inittab to force login during single user mode. Warning: Don’t loose the root password. Ever.
###########################
echo -e "###########################"
echo -e " Require the root password to enter single user mode."
echo -e "###########################\n"
echo "# Require the root pw when booting into single user mode" >> /etc/inittab
echo "~~:S:wait:/sbin/sulogin" >> /etc/inittab
#
#
#
###########################
##Fix:Use configuration files in /etc/modprobe.d to disable the usb-storage modules from loading into the kernel.
###########################
echo -e "###########################"
echo -e "Use configuration files in /etc/modprobe.d to disable the usb-storage and Firewire modules from loading into the kernel."
echo -e "###########################\n"
echo "Disabling USB Mass Storage" > /etc/modprobe.d/blacklist-usbstorage
echo "blacklist usb-storage" >> /etc/modprobe.d/blacklist-usbstorage
echo "Disabling Firewire" > /etc/modprobe.d/blacklist-firewire
echo "blacklist firewire_core" >> /etc/modprobe.d/blacklist-firewire
echo "blacklist firewire_ohci" >> /etc/modprobe.d/blacklist-firewire
#
#
#
###########################
#Fix: Disable unnecessary services. 
#Remove any services from this command that you may need in your environment.
###########################
echo -e "###########################"
echo -e "#Disable unnecessary services."
echo -e "###########################\n"
#for SERVICE in      avahi-daemon    \
#                    bluetooth       \
#                    gpm             \
#                    hidd            \
#                    iscsi           \
#                    iscsid          \
#                    isdn            \
#                    mdmonitor       \
#                    pcscd           \
#                    smartd          
#do
#    chkconfig $SERVICE off
#    service $SERVICE stop >/dev/null 2>&amp;1
#    echo "    $SERVICE disabled."
#done
#
#
#
###########################
#Fix: Add Banner To SSH 
#Add to /etc/issue.net and /etc/motd 
###########################
echo -e "###########################"
echo -e "#Add Banner To SSH"
echo -e "###########################\n"
echo -e "############################################################\nALERT! You are entering into a secured area! Your IP, Login\nTime, Username has been noted and has been sent to the server \nadministrator! This service is restricted to authorized users \n only. All activities on this system are logged.Unauthorized \n access will be fully investigated and reported to the \n appropriate law enforcement agencies \n ############################################################\n" > /etc/issue
echo -e "############################################################\nALERT! You are entering into a secured area! Your IP, Login\nTime, Username has been noted and has been sent to the server \nadministrator! This service is restricted to authorized users \n only. All activities on this system are logged.Unauthorized \n access will be fully investigated and reported to the \n appropriate law enforcement agencies \n ############################################################\n" > /etc/issue.net
echo -e "############################################################\nALERT! You are entering into a secured area! Your IP, Login\nTime, Username has been noted and has been sent to the server \nadministrator! This service is restricted to authorized users \n only. All activities on this system are logged.Unauthorized \n access will be fully investigated and reported to the \n appropriate law enforcement agencies \n ############################################################\n" > /etc/motd
sudo systemctl restart sshd
#
#
#
###########################
#Fix: Set up Auditd
#
###########################
echo -e "###########################"
echo -e "#Set up Auditd"
echo -e "###########################\n"
sudo apt-get install auditd audispd-plugins
echo '-a exit,always -F arch=b64 -F euid=0 -S execve' >> /etc/audit/audit.rules
echo '-a exit,always -F arch=b32 -F euid=0 -S execve' >> /etc/audit/audit.rules
echo "# This is an example configuration suitable for most systems
# Before running with this configuration:
# - Remove or comment items which are not applicable
# - Check paths of binaries and files

###################
# Remove any existing rules
###################

-D

###################
# Buffer Size
###################
# Might need to be increased, depending on the load of your system.
-b 8192

###################
# Failure Mode
###################
# 0=Silent
# 1=printk, print failure message
# 2=panic, halt system
-f 1

###################
# Audit the audit logs.
###################
-w /var/log/audit/ -k auditlog

###################
## Auditd configuration
###################
## Modifications to audit configuration that occur while the audit (check your paths)
-w /etc/audit/ -p wa -k auditconfig
-w /etc/libaudit.conf -p wa -k auditconfig
-w /etc/audisp/ -p wa -k audispconfig

###################
# Monitor for use of audit management tools
###################
# Check your paths
-w /sbin/auditctl -p x -k audittools
-w /sbin/auditd -p x -k audittools

###################
# Special files
###################
-a exit,always -F arch=b32 -S mknod -S mknodat -k specialfiles
-a exit,always -F arch=b64 -S mknod -S mknodat -k specialfiles

###################
# Mount operations
###################
-a exit,always -F arch=b32 -S mount -S umount -S umount2 -k mount
-a exit,always -F arch=b64 -S mount -S umount2 -k mount

###################
# Changes to the time
###################
-a exit,always -F arch=b32 -S adjtimex -S settimeofday -S stime -S clock_settime -k time
-a exit,always -F arch=b64 -S adjtimex -S settimeofday -S clock_settime -k time
-w /etc/localtime -p wa -k localtime

###################
# Use of stunnel
###################
-w /usr/sbin/stunnel -p x -k stunnel

###################
# Schedule jobs
###################
-w /etc/cron.allow -p wa -k cron
-w /etc/cron.deny -p wa -k cron
-w /etc/cron.d/ -p wa -k cron
-w /etc/cron.daily/ -p wa -k cron
-w /etc/cron.hourly/ -p wa -k cron
-w /etc/cron.monthly/ -p wa -k cron
-w /etc/cron.weekly/ -p wa -k cron
-w /etc/crontab -p wa -k cron
-w /var/spool/cron/crontabs/ -k cron

## user, group, password databases
-w /etc/group -p wa -k etcgroup
-w /etc/passwd -p wa -k etcpasswd
-w /etc/gshadow -k etcgroup
-w /etc/shadow -k etcpasswd
-w /etc/security/opasswd -k opasswd

###################
# Monitor usage of passwd command
###################
-w /usr/bin/passwd -p x -k passwd_modification

###################
# Monitor user/group tools
###################
-w /usr/sbin/groupadd -p x -k group_modification
-w /usr/sbin/groupmod -p x -k group_modification
-w /usr/sbin/addgroup -p x -k group_modification
-w /usr/sbin/useradd -p x -k user_modification
-w /usr/sbin/usermod -p x -k user_modification
-w /usr/sbin/adduser -p x -k user_modification

###################
# Login configuration and stored info
###################
-w /etc/login.defs -p wa -k login
-w /etc/securetty -p wa -k login
-w /var/log/faillog -p wa -k login
-w /var/log/lastlog -p wa -k login
-w /var/log/tallylog -p wa -k login

###################
# Network configuration
###################
-w /etc/hosts -p wa -k hosts
-w /etc/network/ -p wa -k network

###################
## system startup scripts
###################
-w /etc/inittab -p wa -k init
-w /etc/init.d/ -p wa -k init
-w /etc/init/ -p wa -k init

###################
# Library search paths
###################
-w /etc/ld.so.conf -p wa -k libpath

###################
# Kernel parameters and modules
###################
-w /etc/sysctl.conf -p wa -k sysctl
-w /etc/modprobe.conf -p wa -k modprobe
###################

###################
# PAM configuration
###################
-w /etc/pam.d/ -p wa -k pam
-w /etc/security/limits.conf -p wa  -k pam
-w /etc/security/pam_env.conf -p wa -k pam
-w /etc/security/namespace.conf -p wa -k pam
-w /etc/security/namespace.init -p wa -k pam

###################
# Puppet (SSL)
###################
-w /etc/puppetlabs/puppet/ssl -p wa -k puppet_ssl

###################
# Postfix configuration
###################
-w /etc/aliases -p wa -k mail
-w /etc/postfix/ -p wa -k mail
###################

###################
# SSH configuration
###################
-w /etc/ssh/sshd_config -k sshd

###################
# Hostname
###################
-a exit,always -F arch=b32 -S sethostname -k hostname
-a exit,always -F arch=b64 -S sethostname -k hostname

###################
# Changes to issue
###################
-w /etc/issue -p wa -k etcissue
-w /etc/issue.net -p wa -k etcissue

###################
# Log all commands executed by root
###################
-a exit,always -F arch=b64 -F euid=0 -S execve -k rootcmd
-a exit,always -F arch=b32 -F euid=0 -S execve -k rootcmd

###################
## Capture all failures to access on critical elements
###################
-a exit,always -F arch=b64 -S open -F dir=/etc -F success=0 -k unauthedfileacess
-a exit,always -F arch=b64 -S open -F dir=/bin -F success=0 -k unauthedfileacess
-a exit,always -F arch=b64 -S open -F dir=/home -F success=0 -k unauthedfileacess
-a exit,always -F arch=b64 -S open -F dir=/sbin -F success=0 -k unauthedfileacess
-a exit,always -F arch=b64 -S open -F dir=/srv -F success=0 -k unauthedfileacess
-a exit,always -F arch=b64 -S open -F dir=/usr/bin -F success=0 -k unauthedfileacess
-a exit,always -F arch=b64 -S open -F dir=/usr/local/bin -F success=0 -k unauthedfileacess
-a exit,always -F arch=b64 -S open -F dir=/usr/sbin -F success=0 -k unauthedfileacess
-a exit,always -F arch=b64 -S open -F dir=/var -F success=0 -k unauthedfileacess

###################
## su/sudo
###################
-w /bin/su -p x -k priv_esc
-w /usr/bin/sudo -p x -k priv_esc
-w /etc/sudoers -p rw -k priv_esc

###################
# Poweroff/reboot tools
###################
-w /sbin/halt -p x -k power
-w /sbin/poweroff -p x -k power
-w /sbin/reboot -p x -k power
-w /sbin/shutdown -p x -k power

###################
# Make the configuration immutable
###################
-e 2

# EOF" >/etc/audit/rules.d/audit.rules
service auditd restart
#
#
#
###########################
#Fix:  SET up AIDE.
#
###########################
echo -e "###########################"
echo -e "#SET up AIDE."
echo -e "###########################\n"
apt-get install aide
sudo update-aide.conf
ls /var/lib/aide
sudo mv /var/lib/aide/aide.db.new /var/lib/aide/aide.db
sudo aide --init
sudo aide --check
#
#
#
###########################
#Fix:  SET up Compilers to root only?
#
###########################
echo -e "###########################"
echo -e "#SET up Compilers to root only?"
echo -e "###########################\n"
sudo chmod o-rx /usr/bin/as
#
#
#
###########################
#Fix:  SET up ARP WATCH
#
###########################
echo -e "###########################"
echo -e "#SET up ARPWATCH"
echo -e "###########################\n"
sudo apt-get install arpwatch # Monitors ARP attacks monitor it with ARP -A 
sudo systemctl enable arpwatch
sudo systemctl start arpwatch
###########################
#Fix:  Name Server
#
###########################
echo -e "###########################"
echo -e "#Configure up 2 DNS Servers"
echo -e "###########################\n"
# Google IPv4 nameservers
echo "nameserver 8.8.8.8" > /etc/resolv.conf
echo "nameserver 8.8.4.4" >> /etc/resolv.conf


###
# Default run level? 
###
echo "env DEFAULT_RUNLEVEL=2"> /etc/init/rc-sysinit.conf 




##
#
##
if grep -q "deb http://security.debian.org/" /etc/apt/sources.list; then
    echo "found"
else
    echo "not found"
	echo "deb http://security.debian.org/ stretch/updates main contrib non-free"  >> /etc/apt/sources.list
	echo "deb-src http://security.debian.org/ stretch/updates main contrib non-free"  >> /etc/apt/sources.list
fi
###########################
#Fix:  process accounting
#
###########################
echo -e "###########################"
echo -e "#process accounting"
echo -e "###########################\n"
sudo apt-get install acct
sudo systemctl enable psacct.service
sudo systemctl start psacct.service
apt-get install sysstat
echo '#
# Default settings for /etc/init.d/sysstat, /etc/cron.d/sysstat
# and /etc/cron.daily/sysstat files
#

# Should sadc collect system activity informations? Valid values
# are "true" and "false". Please do not put other values, they
# will be overwritten by debconf!
ENABLED="true" ' > /etc/default/sysstat
service sysstat restart
###########################
#Fix: To decrease the impact of a full /tmp file system, place /tmp on a separated partition
#
###########################
 sudo systemctl enable tmp.mount
#
#
#
echo -e "###########################"
echo -e "#Clean up"
echo -e "###########################\n"
sudo apt-get autoremove 
sudo apt-get update && sudo apt-get dist-upgrade 
sudo aptitude purge $(dpkg -l | tail -n +6 | grep -v '^ii' | awk '{print $2}')
sudo aptitude purge