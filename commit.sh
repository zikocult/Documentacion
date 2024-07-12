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
echo "¿Quieres realizar el commit en algún repositorio en concreto?"
echo "	1: Cursus42"
echo "	2: Documentacion"
echo "	3: begin"
echo "	4: Ninguno"
echo " "
read -p "Respuesta: " RESP
case $RESP in
	"1")
		cd ./Cursus42/
		git add .
		read -p "Descripción del commit: " DESC
		git commit -m "$DESC"
		git push origin HEAD
		exit 0
		;;
	"2")
		cd ./Documentacion/
		git add .
		read -p "Descripción del commit: " DESC
		git commit -m "$DESC"
		git push origin HEAD
		exit 0
		;;
	"3")
		cd ./begin/
		git add .
		read -p "Descripción del commit: " DESC
		git commit -m "$DESC"
		git push origin HEAD
		exit 0
		;;
	"4")
		echo "No se actualizará ningún repositorio"
		exit 0
		;;
	*)
		echo "Opción no válida"
		exit 1
		;;
esac
