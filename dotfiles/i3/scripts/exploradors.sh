#!/bin/bash

r=$(echo -e "Ranger\nMidnight\nKrusader" | dmenu -i -fn "JetBrains-14" -nb "#222222" -nf "#088080" -sb "#494444" -sf "#0088ee" -p "Sortida:")

case "$r" in
    "Ranger") kitty -e bash ranger ;;
    "Midnight" ) kitty -e mc ;;
    "Krusader" ) krusader ;;
    *) echo " " ;;
esac

