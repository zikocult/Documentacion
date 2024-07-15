#!/bin/bash

STATUS=$(systemctl status ollama | grep Active | awk '{ print $2 }')

if [ "$STATUS" = "active" ]; then
	cowsay -f sodomized 'Skynet is already running, what do you want to do?'
	echo " "
	echo "	0. Run and do nothing"
	echo "	1. Stop Skynet and save the world"
	echo "	2. Keep skynet running and talk to him"
	echo " "
	read -p "Waiting for your choice: " CHOICE
	case $CHOICE in
		0)
			cowsay -f tux "Good bye human, I will be back!"
			;;
		1)
			sudo -p "$(cowsay -f tux 'If you want to stop skynet give me the password... MOOO!')" systemctl stop ollama
			;;
		2)
			kitty -e oterm
			;;
		*)
			cowsay -f sodomized "Invalid choice!"
			exit 1
			;;
	esac
elif [ "$STATUS" = "inactive" ]; then
	sudo -p "$(cowsay -f sodomized 'If you want to start skynet give me the password... MOOO!')" systemctl start ollama
	oterm
fi
exit 0
