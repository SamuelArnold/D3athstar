#!/bin/bash

echo "HI"
########################################
# Created By Sam Arnold  on 8/5/17
# Goal: to Teach Linux
#
########################################
#
#
#
###########################
#Fix: Install Some Security programs
###########################
echo -e "###########################"
echo -e "1 List Basic commands"
echo -e "2 Quiz on commands"
echo -e "###########################"

read -p "Your First choice:  " UserChoice
 while [[ "$UserChoice" != "0" ]]
            do
               
            if [ "$UserChoice" -eq "1" ]
			then
				echo -e "\e[42mLearn Basic Linux Commands"
				echo -e "\e[49m"
				
				#find Command 
				echo -e "ls"
				echo -e "     Shows files in current directory\n"
				echo -e '     Example: ls -lastX' 
				echo -e '     				Shows hidden files and shows date of Current Working Directory \n \n'
				
				#find Command 
				echo -e "find"
				echo -e '     Locate files on the system\n'
				echo -e '     Example: find $HOME -name ".*" -ls'
				echo -e '     		   Finds hidden files \n \n'
				
				#find Service
				echo -e "service"
				echo -e '     Locate files on the system\n'
				echo -e '     Example: service --status all'
				echo -e '     		   show running services \n \n'
				
				#NetStat
				echo -e "netstat"
				echo -e '     View Network Stastics\n'
				echo -e '     Example 1: 	 netstat -tulpn'
				echo -e '     		   show TCP traffic \n'
				echo -e '     Example 2: 	 netstat -tl |grep ssh'
				echo -e '     		    show SSH connections \n \n'
	
				echo -e "\e[42m========================="
				echo -e "\e[49m"
				
				echo -e "
				Important Log files to check 
				======================================
				/var/log/message – Where whole system logs or current activity logs are available.
				/var/log/auth.log – Authentication logs.
				/var/log/kern.log – Kernel logs.
				/var/log/cron.log – Crond logs (cron job).
				/var/log/maillog – Mail server logs.
				/var/log/boot.log – System boot log.
				/var/log/mysqld.log – MySQL database server log file.
				/var/log/secure – Authentication log.
				/var/log/utmp or /var/log/wtmp : Login records file.
				/var/log/yum.log: Yum log files. 
				=======================================\n\n"
				
				
				echo -e "
				Important files to check 
				======================================
				/etc/sysctl.conf   - modify kernal mode and parameters
				/etc/modprobe.conf   - modify kernal mode and parameters
				/etc/inittab  - system Start up
				/etc/init.d/ - system Start up
				/etc/init/ - system Start up
				/etc/ssh/sshd_config - ssh 
				/etc/ssh/ssh_config - ssh 
				/etc/resolv.conf  - DNS Servers Set up.
				=======================================\n\n"
				
				
			fi
			
			echo -e "\nInput Another choice or please choose 0 to exit\n"
            read -p "Your choice:  " UserChoice

			#finish asking for user input
			done
