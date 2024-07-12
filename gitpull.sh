#!/bin/bash

if [ $# -ge 1 ]; then
	read -p "¿Quieres hacer un pull del repositorio $1? (y/n): " respuesta
	if [ $respuesta == "y" ]; then
		cd $1
		git pull
		exit 0
	fi
fi
read -p "¿Quieres realizar un pull de alguno o todos los repositorios? (y/a/n): " respuesta
if [ $respuesta == "n" ]; then
	exit 1
elif [ $respuesta == "a" ]; then
	cd ./Cursus42/
	git pull
	cd ../Documentacion/
	git pull
	cd ../begin/
	git pull
	exit 0
fi
read -p "¿Pues que repositorio quieres actualizar? (cursus/docs/begin/all/none): " respuesta
case $respuesta in
	"cursus") cd ./Cursus42/ && git pull ;;
	"begin") cd ./begin/ && git pull ;;
	"docs") cd ./Documentacion/ && git pull ;;
	"all") cd ./Cursus42/ && git pull && cd ../Documentacion/ && git pull && cd ../begin/ && git pull && exit 0 ;;
	"none") echo "No se ha actualizado ningun repositorio" && exit 1 ;;
	*) echo "No has introducido una respuesta valida" && exit 1 ;;
esac
