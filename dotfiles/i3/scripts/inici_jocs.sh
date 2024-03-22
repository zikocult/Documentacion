#!/usr/bin/bash

r=$(echo -e "Steam\nEmulationStation\nDolphin\nRetroArch" | dmenu -i -fn "JetBrains-14" -nb "#222222" -nf "#088080" -sb "#494444" -sf "#0088ee" -p "A jugar!")

case "$r" in
	"Steam" ) steam-runtime;;
    "EmulationStation" ) emulationstation;;
    "Dolphin" ) dolphin-emu ;;
    "RetroArch" ) retroarch;;
    * ) echo "Res a canviar" ;;
esac
