#!/bin/bash
# Dmenu script para lanzar aplicaciones, ejemplo básico, lanzamiento en terminal

declare -a options=(
"spotify
htop
arandr
salir")

choice=$(echo -e "${options[@]}" | dmenu -l -i -p 'Programas de prueba: ' )

#Missatge de despedida random
if [ "$choice" == 'salir' ]; then
    echo "Fins aviat"
fi 

#Execució mitjançant exec
if [ "$choice" == 'spotify' ]; then
    exec spotify
fi

#Executa a través de terminal de la teva elecció
if [ "$choice" == 'htop' ]; then
    exec kitty -e htop
fi

#Execució a piñón
if [ "$choice" == 'arandr' ]; then
    arandr
fi


