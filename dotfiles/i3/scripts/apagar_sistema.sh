#!/usr/bin/bash

r=$(echo -e "Apagar\nReiniciar\nLogout\nBloqueja" | dmenu -i -fn "JetBrains-14" -nb "#222222" -nf "#088080" -sb "#494444" -sf "#0088ee" -p "Sortida:")

case "$r" in
    "Apagar") shutdown -h now ;;
    "Reiniciar" ) shutdown -r now ;;
    "Logout" ) i3-msg exit ;;
    "Bloqueja" ) i3lock -n -i ~/Imagenes/Wallmine/wallhaven-o3djo7.png ;;
    *) echo "󰐥 " ;;
esac
