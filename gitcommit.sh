#!/bin/bash

if [ "$#" -ge 1 ]; then
	read -p "Te parece correcto ir al repositorio $1? (y/n): " RESP
	if [ "$RESP" == "y" ]; then
		cd $1
		git add .
		read -p "Descripción del commit: " DESC
		git commit -m "$DESC"
		git push origin HEAD
		exit 0
	fi
fi
read -p "¿Quieres realizar el commit en algún repositorio en concreto? (cursus/docs/begin/none): " RESP
case $RESP in
	"cursus")
		cd ./Cursus42/
		git add .
		read -p "Descripción del commit: " DESC
		git commit -m "$DESC"
		git push origin HEAD
		exit 0
		;;
	"docs")
		cd ./Documentacion/
		git add .
		read -p "Descripción del commit: " DESC
		git commit -m "$DESC"
		git push origin HEAD
		exit 0
		;;
	"begin")
		cd ./begin/
		git add .
		read -p "Descripción del commit: " DESC
		git commit -m "$DESC"
		git push origin HEAD
		exit 0
		;;
	"none")
		echo "No se actualizará ningún repositorio"
		exit 0
		;;
	*)
		echo "Opción no válida"
		exit 1
		;;
esac
