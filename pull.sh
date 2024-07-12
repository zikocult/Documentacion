#!/bin/bash

if [ $# -ge 1 ]; then
	read -p "¿Quieres hacer un pull del repositorio $1? (y/n): " respuesta
	if [ $respuesta == "y" ]; then
		cd $1
		git pull
		exit 0
	fi
fi
echo "¿Cuál es el repositorio que quieres actualizar?"
echo "	1: Cursus42"
echo "	2: Documentacion"
echo "	3: begin"
echo "	4: Todos los repositorios"
echo "	5: Ningun repositorio"
echo " "
read -p "Respuesta: " respuesta
case $respuesta in
	"1") cd ./Cursus42/ && git pull ;;
	"2") cd ./begin/ && git pull ;;
	"3") cd ./Documentacion/ && git pull ;;
	"4") cd ./Cursus42/ && git pull && cd ../Documentacion/ && git pull && cd ../begin/ && git pull && exit 0 ;;
	"5") echo "No se ha actualizado ningun repositorio" && exit 1 ;;
	*) echo "No has introducido una respuesta valida" && exit 1 ;;
esac
