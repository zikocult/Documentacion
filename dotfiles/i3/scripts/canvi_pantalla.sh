#!/usr/bin/bash

r=$(echo -e "Simple\nDoble_dreta\nDoble_esquerra\nAltres" | dmenu -i -fn "JetBrains-14" -nb "#222222" -nf "#088080" -sb "#494444" -sf "#0088ee" -p "Canvi pantalla:")

case "$r" in
    "Simple") xrandr --output "eDP1" --auto --output "HDMI2" --off ;;
    "Doble_dreta" ) xrandr --output "eDP1" --auto --output "HDMI2" --auto --primary --right-of "eDP1" ;;
    "Doble_esquerra" ) xrandr --output "eDP1" --auto --output "HDMI2" --auto --primary --left-of "eDP1" ;;
    "Altres" ) arandr ;;
    *) echo "󰍹 " ;;
esac
