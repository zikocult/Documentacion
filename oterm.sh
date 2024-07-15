#!/bin/bash

STATUS=$(systemctl status ollama | grep Active | awk '{ print $2 }')

if [ "$STATUS" = "active" ]; then
	kitty -e oterm
elif [ "$STATUS" = "inactive" ]; then
	kitty -e sudo -p "$(cowsay -f sodomized 'If you want to start skynet give me the password... MOOO!')" systemctl start ollama
	kitty -e oterm
fi
