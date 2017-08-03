#!/bin/bash

clear
echo -e "\e[41m                                                                       "
echo -e "\e[41mD3athStar created By Sam Arnold                                        "
echo -e "\e[41m                                                                       "
echo -e "\e[47m=============================================================          "
echo -e "\e[104mPlease choose an option                                               "
echo -e "\e[104m0-  Exit                - leave program                               "
echo -e "\e[104m1-  Update / Upgrade    - checks for updates in OS and tools          "
echo -e "\e[104m2-  CHKrootkit          - Checks for rootkits                         "
echo -e "\e[104m3-  RKHunter            - Checks for rootkits                         "
echo -e "\e[104m4-  Lynis               - Checks how harden the system is             "
echo -e "\e[104m5-  RubberGlue          - TCP Honey Pot                               "
echo -e "\e[104m6-  Port Proof          - Lists all ports as open and listening       "
echo -e "\e[47m=============================================================          "
echo -e "\e[49m                                                                       "


#MyExit="false"
#echo $MyExit
read -p "Your First choice:  " UserChoice

    while [[ "$UserChoice" != "0" ]]
            do
               


            if [ "$UserChoice" -eq "1" ]
			then
				echo -e "\e[42mUpgrade / Update Begin"
				echo -e "\e[49m"
				#update and upgrade
				#apt-get upgrade -y
				#apt-get update -y
				#apt-get update --fix-missing -y
				echo -e "\e[42m============Complete!============="
				echo -e "\e[49m"
			fi

            if [ "$UserChoice" -eq "2" ]
            then
                echo -e "\e[42mCheck for Rootkits"
				echo -e "\e[49m"
                apt-get install chkrootkit
                sudo chkrootkit
                echo -e "\e[42m============Complete!============="
				echo -e "\e[49m"
            fi

			if [ "$UserChoice" -eq "3" ]
            then
                echo -e "\e[42mCheck for Rootkits"
				echo -e "\e[49m"
                sudo apt-get install rkhunter
                sudo rkhunter --propupd
				sudo rkhunter --update
				sudo rkhunter --checkall
                echo -e "\e[42m============Complete!============="
				echo -e "\e[49m"
            fi
			
			
			
			 if [ "$UserChoice" -eq "4" ]
				then
					echo "lynis"
					apt-get install lynis
					lynis --update 
					lynis audit system
					echo "===== Complete ======="
			fi

			
			
			if [ "$UserChoice" -eq "5" ]
				then
					echo "Rubber Glue Honey Pot"
					read -p "What Port do you want...:" RubberGluemyportnum
					cp -a ./Bin/RubberGlue /opt/RubberGlue
					echo "If Blinking I am running! DONT EXIT"
					python /opt/RubberGlue/rubberglue.py $RubberGluemyportnum
					echo "===== Complete ======="
			fi
			
				if [ "$UserChoice" -eq "6" ]
				then
					echo "PortProof"
					sudo mkdir  /opt/portspoof
					sudo cp -a ./Bin/portspoof /opt/portspoof
					myvar="$PWD"
					cd /opt/portspoof
					./configure; make; make install
					iptables -t nat -A PREROUTING -p tcp -m tcp --dport 1:65535 -j REDIRECT --to-ports 4444
					sudo portspoof -s /usr/local/etc/portspoof_signatures -D
					cd "$myvar"
					echo "===== Complete ======="
				fi
				
				
				if [ "$UserChoice" -eq "7" ]
				then
					echo "Human.py"
					echo $PWD
					sudo cp -a ./Bin/human.py /opt/human.py > /dev/null 2>&1
					myvar="$PWD"
					cd /opt/human.py
					read -p "User to Monitor : " HumanPyUser
					echo "Running...do not exit"
					echo "Monitoring user... " $HumanPyUser
					echo "Report saved /var/log/human"
					echo ""
					echo "===== Start ======="
					echo ""
					sudo python ./human.py $HumanPyUser
					echo ""
					cd "$myvar"
					echo "===== Complete ======="
				fi
			
			
			if [ "$UserChoice" -eq "40" ]
				then
					echo "OSChemeleon"
					cp -a ./Bin/oschameleon /opt/oschameleon
					myvar="$PWD"
					cd /opt/oschameleon
					
					apt-get install python-nfqueue
					apt-get install python-scapy
					apt-get install python-gevent
					apt-get install python-netifaces
					echo -e "\e[42m====Install Dependecies Complete!============="
					echo -e "\e[49m"
					
					sudo python /opt/oschameleon/setup.py build
  				    sudo python /opt/oschameleon/setup.py install
					sudo python /opt/oschameleon/setup.py build
					echo -e "\e[42m====Build install Complete!============="
					echo -e "\e[49m"
						
					cd /opt/oschameleon/oschameleon
					sudo python /opt/oschameleon/oschameleon/oschameleonRun.py --template /opt/oschameleon/oschameleon/template/windows_7_SP1.txt
					#sudo python /opt/oschameleon/oschameleon/osfuscation.py
					cd "$myvar"
					echo "===== Complete ======="
			fi
				echo -e "\nInput Another choice or please choose 0 to exit\n"
                read -p "Your choice:  " UserChoice

	    #finish asking for user input
    done
