#!/bin/bash


#update and upgrade
#apt-get upgrade -y
#apt-get update -y
#apt-get update --fix-missing -y
echo "Please choose an option"
echo "0-Exit"
echo "1- Update / Upgrade"
MyExit="false"
echo $MyExit
read -p "Your choice:  " UserChoice
            while [[ "$UserChoice" != "0" ]]
            do
                echo -e "\nInput Another choice or please choose 0 to exit\n"
                read -p "Your choice:  " UserChoice


            if [ "$UserChoice" -eq "1" ]
	    then
		echo "Upgrade / Update begin"
		#update and upgrade
		#apt-get upgrade -y
		#apt-get update -y
		#apt-get update --fix-missing -y
		echo "Upgraded Complete"
	    fi

            if [ "$UserChoice" -eq "2" ]
            then
                echo "Check for Rootkits"
                apt-get install chkrootkit
                sudo chkrootkit
                echo "===== Complete ======="
            fi

	     if [ "$UserChoice" -eq "3" ]
            then
                echo "Check for Rootkits"
                apt-get install lynis
                lynis --update 
                lynis audit system
                echo "===== Complete ======="
            fi



	    #finish asking for user input
	    done
