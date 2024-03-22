#!/usr/bin/zsh

r=$(echo -e "BpyTop\nDisk_usage\nNavegador\nSonido" | dmenu -i -fn "JetBrains-14" -nb "#222222" -nf "#088080" -sb "#494444" -sf "#0088ee" -p "Sortida:")

case "$r" in
    "BpyTop") kitty -e bpytop ;;
    "Disk_usage" ) kitty -e ncdu ;;
    "Navegador" ) kitty -e links https://duckduckgo.com ;;
    "Sonido" ) kitty -e cava ;;
    *) echo " " ;;
esac

