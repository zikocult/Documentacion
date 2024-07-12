Dejaré un par de scripts útiles para el día a día, fácilmente modificables según la necesidad:

Para controlar los *pull* de tus diferentes directorios:

```bash
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
```

Para realizar un *commit --> push* con facilidad si lo tenemos todo claro.

```bash
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
```