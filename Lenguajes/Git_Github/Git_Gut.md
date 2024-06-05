La mayoría de este documento, está sacado en gran medida del libro **Aprendiendo Git Github ** de  **Miguel Ángel Durán (midudev)**, un gran agradecimiento a él y su esfuerzo:

![[Pasted image 20240531163527.png]]

# Index

- [Instalación](##Instalación)
- [Configuración inicial](##Config_inicial)
- [Trabajo en local](##Trabajo_local)
	- [Directorio de trabajo](###Directorio_de_trabajo)
	- [Area Stagging](###Stagging_area)
	- [Commit](###Commit)
	- [¿Qué es el Head?](###HEAD)
	- [¿Como deshacer mis cambios?](###Deshacer_cambios)
	- [¿Como ignorar archivos](###Ignorar_archivos)
	- [Seguimiento de uno o varios archivos](###Seguimiento)
- [Ramas en Git](##Ramas)
	- [Creación de ramas](###Creación_ramas)
	- [Listando las ramas disponibles](###Listando_ramas)
	- [Trabajando con ramas](###Trabajando_con_ramas)
	- [Fusionando ramas](###Fusionado_ramas)

## Instalación

Como casi siempre, se trataría de escoger el gestor del sistema operativo que estemos usando, voy a poner algunos ejemplos:

```bash
Para MacOS:
brew install git

Para Linux depende de la distribución:
apt-get install git
dnf install git
pacman -S git
```

El caso de Windows deberemos descargar el instalador oficial de:
[https://git-scm.com/download/win](https://git-scm.com/download/win)

## Config_inicial

Debemos configurar el usurio y su correo, para eso lo podemos realizar mediante una configuración global mediante el siguiente comando:

```bash
git config --global user.name "<nombre>"
git config --global user.email "<email>"
```

Con esto quedarán guardado en el archivo $HOME/.gitconfig, que se usará para las configuraciones globales del sistema.

También podemos realizar una configuración para un repositorio en concreto, en este caso, dentro del repositorio, realizaremos los siguientes comandos, que quedarán registrados en el fichero, pero sólo serán usado para ese repositorio

```bash
cd <tur directorio de repositorio>
git config user.name "Guillem"
git config user.email "correo@correo.com"
```

En github se mostrará el nombre y el avatar del usuario que ha realizado el commit

#### Editor por defecto

Git intentará abrir **vim** para que puedas modificar los ficheros cuando encuentra conflictos o para darte la opción de escribir mensajes commit mas largos, para configurar otro editor,  vamos a escribir el siguiente comando según el editor que queramos (después de # es comentario):

```bash
git config --global core.editor "code" # VisualStudio
git config --global core.editor "atom" # Atom
git config --global core.editor "subl" # Sublime text
git config --global core.editor "nano" # Nano
```

#### Comprobación configuración

Tan simple como el comando:

```bash
git config --list
```

Esto nos dará como resultado TODAS las configuraciones que tengamos en el sistema, podemos por ejemplo tener varios pull.rebase diferentes, eso es porque podemos tener diferentes ficheros gitconfig como hemos comentado antes.

Para leer sólo un fichero, debemos usar los argumentos "**--global, --local y --system**"

Con la opción "**--show-scope**", podremos ver de dónde proviene cada configuración (global, local o system)

También podemos saber el valor de una configuración en particular, usando:

``` bash
git config user.email
$ correo@gmail.com
```

## Trabajo_local

Se trabaja de forma local y se puede seguir trabajando sin subir nada a la nube, con lo que nos vamos a enfocar en las tres primeras etapas de un proyecto GIT

![[Pasted image 20240530114551.png]]

#### Iniciar un nuevo proyecto

Para iniciar un proyecto desde 0, es decir, crear un repositorio local, se usa el comando **git init**:

```bash
git init nuevo-proyecto
cd nuevo-proyecto
```

Si lo que se quiere iniciar es un repositorio de una carpeta ya existente, deberemos usar el comando **git init** dentro del directorio del proyecto.

```bash
cd <directorio del proyecto>
git init
```

En cualquiera de los dos se ha creado una rama principal (master a día de hoy), para cambiar el nombre de dicha rama, deberemos usar **--initial-branch**, aunque también puedes cambiar la configuración **init.defaultBranch** para que siempre se cree otra rama:

```bash
git init nuevo-proyecto --initial-branch=main

Para marcar la configuración:
git config --global init.defaultBranch main
```

Si todo ha ido bien, se habrá creado un directorio **.git** dentro del directorio inicializado, en este directorio, es donde git va a gruardar toda la información de tu proyecto (archivos, histórico de cambios, bifurcaciones y mas).

**IMPORTANTE!!**
~~~
No se debe borrar el directorio .git de tu proyecto, si lo borras, no podrás acceder a los datos del repositorio y podrías perder todo lo que hayas hecho.

Al menos debes asegurar que has sincronizado todos los cambios y ramas que te interesen con un repositorio remoto (git push).
~~~

Otra forma sencilla de saber si el proyecto actual tiene un repositorio inicializado correctamente es ejecutar el comando **git status** en el directorio del proyecto.

```bash
# En un directorio que no contiene un repositorio
git status

$ fatal: not a git repository (or any of the parent directories): .git

# En un directorio que contiene un repositorio
git status

$ On branch main
$ No commits yet
$ Nothing to commit (create/copy files and use "git add" to track)
```

### Directorio_de_trabajo

Es simplemente el directorio inicializado donde has creado, crearás y/o modificarás los ficheros.

Con git status veremos el estado en que tenemos los ficheros, nuevos, modificados, etc... para hacer que git status sea un poco menos "verboso" usaremos la opción -s

```bash
# Dentro del directorio inicializado:

touch index.html
touch README.md
git status -s
$ ?? README.md
$ ?? index.html
```

Usando **git add .**,  veremos como cambia y se prepara para el commit:

```bash
git add .
$ A  README.md
$ A  index.html
```

Seguimos con el mismo ejemplo:

```bash
git commit -m "Testeando"
$ [main (commit-raíz) abd2096] Testeando
$  2 files changed, 0 insertions(+), 0
$ deletions(-)
$  create mode 100644 README.md
$  create mode 100644 index.html

git status -s 
# No aparecerá nada hasta que modiquemos algo, en cuyo caso, aparecerían con una M delante, tal que así:

 $ M README.md
 $ M index.html
```

Así tenemos que git status -s nos da estos estados (los iré rellenando según vea mas)

| Modificador | Descripción                                                        |
| ----------- | ------------------------------------------------------------------ |
| ??          | Nuevo fichero, no añadido al stack                                 |
| A           | Fichero añadido preparado para el commit                           |
| M           | Fichero modificado (de color rojo no añadido, color verde añadido) |

#### Deshacer un archivo modificado

Quieres volver a la versión original que tenías en el directorio de trabajo, para ello, debemos haberlo "commiteado" anteriormente.

El comando **git log** nos mostrará los diferentes commits.

```bash
git log                                     
commit 33e4ef019f8166f642ccb46dc0ad7d899ab0bf9b (HEAD -> main)
Author: Guillem <gbarulls@gmail.com>
Date:   Thu May 30 12:30:34 2024 +0200

    Testeando 2

commit abd2096ed3b2684a2b358797210dcd78acf395ca
Author: Guillem <gbarulls@gmail.com>
Date:   Thu May 30 12:18:15 2024 +0200

    Testeando
```

Truqui para ver sólo los 5 últimos commit y sólo el id de los commit (mas adelante le veremos la ultilidad)

```bash
git log -5 | grep ^commit | cut -d" " -f2
```

En este caso, puedes restaurar la versión previa de ese fichero usando el comando **git restore**

Para restaurar la versión anterior de ese fichero, usaremos el comando git restore, vamos a poner algunos ejemplos:

```bash
# Restaura el fichero index.html
git restore index.html 
# Restaura todo el directorio de trabajo
git restore . 
# Restaura todos los archivos terminados en *.js
git restore '*.js'
```

Este comando es relativamente nuevo, pues se ha usado anteriormente el comando **git checkout**.

```bash
# Resttaura el fichero index.html
git checkout -- index.html 
# Restaura todo el directorio de trabajo
git checkout . 
# Restaura todos los archivos terminados en *.js
git restore -- '*.js'
```

#### Si el archivo o directorio no existía anteriormente

Esto significa que queremos limpiar lo que hemos creado. Una opción es simplemente borrar el fichero, otra usar el comando **git clean** que nos permite borrar todos los archivos no rastreados por git.

Este comando tiene varias opciones, pues simplemente sin parámetros no funciona:

| Parámetro | Desciripción                                                                                                                                 |
| --------- | -------------------------------------------------------------------------------------------------------------------------------------------- |
| -n        | para ejecutar un *dry-run*, esto hará que se ejecute el comando y te diga cuál sería el resultado de borrar los archivos, pero SIN BORRARLOS |
| -f        | forzar el borrado de los archivos                                                                                                            |
| -d        | para borrar también directorios que no existían antes                                                                                        |
| -i        | para que te pregunte antes de borrar cada archivo                                                                                            |

**REMEMBER**: Sólo sirve para fichero aún no trackeados (o nunca commiteados)

### Stagging_area

Antes ya he explicado un poco, pero básicamente es preparar los ficheros modificados para confirmar y grabar posteriormente en nuestro repositorio.

Se llama también "Área temporal", ya que es un estado transitorio por el que pasad los archivos que mas adelante vamos a querer grabar en el repositorio local.

El comando a usar para realizar este paso será **git add "archivo"**, añado algunos ejemplos:

```bash
# El archivo creado anteriormente
git add index.html

# Añado varios ficheros a la vez
git add index.html README.md

# Añado todos los ficheros de una extensión en concreto
git add *.c

# Añadir TODOS los ficheros modificados
git add --all
git add -A
# Si estás en el directorio raíz
git add .

# También podemos añadir sólo una carpeta en concreto
git add src
```

#### Sacar archivos de la área de stagging

Para sacar un fichero o los que consideremos de la zona staggint, simplemente ejecutaremos **git reset "archivo"**

También podemos usar la vieja opción (y la que marca git status como buena), que sería **git rm --cached "file"**

El uso es igual que git add, es decir, podemos quitar uno o varios archivos, así como carpetas o extensiones.

### Commit

Los commits sirven para registrar los cambios que se han producido en el repositorio.

*Piensa en los commits como si fuese fotos*, cada foto muestra un estado de todos los archivos de tu repositorio en el momento en que se hizo y cada commit va firmado por el autor, la fecha, la localización y otra información útil.

Si haces mas fotos, pues obtienes un álbum de fotos de tu viaje, este álbum sería el *historial de cambios del repositorio*, que te permitirá entender qué hizo cada commit y en qué estado se encontraba en ese momento.

Para ejemplificar todos los pasos vistos hasta ahora:

![[Pasted image 20240530132219.png]]

Para realizar el commit simplemente ejecutaremos el comando **git commit**, estos nos abrirá el editor para que pongamos el mensaje.

Para añadir el mensaje sin pasar por el editor, podemos añadir la opción -m o --message:

```bash
git commit -m "Add a new search feature"

# Para poner un segundo mensaje ampliando

git commit -m "add search" -m "this feature is awesome"
```

Estos cambios, se graban en el respositorio local, a partir de aquí, para deshacer estos cambios, tendrás que revertirlos grabando un nuevo commit en el historial de cambios del repositorio.

#### Hacer un commit sin pasar por el área de staging

Para hacer eso, podemos usar la opción -a o -all, de esta manera commit preparará todos los ficheros que hayas modificado y los añadirá.

```bash
git commit -all -m "Add new files without staging"
git commit -am "Add new files without staging"
```

**Importante**: Esto sólo funciona para archivos modificados, si has añadido archivos nuevos, no los añadirá, para esto debemos usar git add (as usual)

### HEAD

*HEAD* es el puntero que referencia el punto actual del historial de cambios del repositorio en el que estás trabajando.

Normalmente será el último commit de la rama en la que te encuentras, aunque puedes moverte entre HEADs.

Podemos saber el valor de HEAD con el comando **git symbolic-ref HEAD**

Si lo que necesitas es saber el valor de HEAD y no la rama donde estás, el comando sería **git rev-parse HEAD**

### Deshacer_cambios

A veces queremos tirar para atrás el último commit, queremos hacer un commit de otra cosa o simplemente, porque ahora no tocaba.

Dos formas, dependiendo de si quieres o no mantener los cambios del commit:

*Si quieres mantener los cambios:*

```bash
git reset --soft HEAD~1
```

Con el comando reset hacemos que la rama actual retroceda a la revisión que le indicamos, en este caso le decimos que queremos volver a la versión inmediatamente anterior a la que estamos ahora.

Esto sirve para volver al punto de antes y elminar el commit, pero no eliminamos absolutamente nada.

*Si NO quieres mantener los cambios:*

```bash
git reset --hard HEAD~1
```

Con esto si que realmente eliminamos los cambios que hayamos subido con el commit, es decir, tenemos que estar muy seguros, pues va a modificar los ficheros locales.

*Para arreglar el último commit*

A veces no quieres tirar para atrás el último commit que has hecho, si no que simplemente quieres arreglarlo, con lo que tenemos dos opciones.

```bash
# Arreglar el mensaje que has usado para el último commit
git commit --amend -m "este es el mensaje bueno"

# Añadir nuevos cambios al último commit
git add ficherin.c
git commit --amend -m "mensaje del commit"
```

**Importante**: el parámetro *--amend* sólo funciona con el último commit y siempre y cuando NO esté publicado en el repositorio remoto, si ya has hecho un push, se hará un git revert, pero eso para mas adelante.

### Ignorar_archivos

Para ignorar archivos, se va a ubicar el fichero **.gitignore**, normalmente se coloca en la raíz del repositorio, pero puedes crear uno para cada carpeta si lo deseas. Un ejemplo de contenido:

```bash
node_modules # Ignorar carpeta de módulos
.env # Ignorar fichero con variables de entorno
.DS_Store # Ignorar el fichero de sistema
build/ # Ignorar carpeta generada
```

¿Qué archivos y carpetas se pueden colocar aquí? añado lista de recomendaciones:

- Archivos que tengan credenciales o llaves de API (no deberías subirlas al repositorio, simplemente inyectarlas por variables de entorno)
- Carpetas de configuración de tu editor (/.vscode)
- Archivos de registro (log files)
- Archivos de sistema como .DS_Store (puto fichero de mac)
- Carpetas generadas con archivos estáticos o compilaciones como /dist o /build
- Dependencias que pueden ser descargadas
- Coverage del testing (/coverage)

Echar un vistazo a [gitignore.io](https://www.toptal.com/developers/gitignore)

Hay una manera de ignorar archivos en todos tus repositorios de forma global y es creando el archivo **~/.gitignore_global**.

Esto podría ser un ejemplo de fichero:

```bash
# Archivos y directorios de sistema
.DS_Store
Desktop.ini
Thumbs.db
.Spotlight-V100
.Trashes

# Variables de entorno
.env

# Directorios de instalacio y cache
node_modules
.sass-cache

# Configuracion del editor
### Visual Studio Code ###
.vscode/*
!.vscode/settings.json
!.vscode/tasks.json
!.vscode/launch.json
!.vscode/extensions.json
*.code-workspace
```

Una vez creado, debemos actualizar la configuración de core.excludesfile para que lea de forma global.

```bash
git config --global core.excludesfile ~/.gitignore_global
```

Podemos encontrar una colección de archivos gitignore, hecho por parte de GitHub, en el siguiente enlace:

[Gitignore by GitHub](https://github.com/github/gitignore)

### Seguimiento

Todos los ficheros en si dentro del repositorio, tienen su seguimiento a excepción de como hemos visto antes de si están incluidos en el fichero .gitignore, pero que hacemos si ya hemos añadido un fichero y queremos que no siga subiendo, pues encontramos dos maneras según el caso.

#### De forma manual:

Podemos directamente borrar el fichero del directorio que sean parte del repositorio, añadirlo al fichero .gitignore y luego hacer un commit:

```bash
rm config.local.js
git add config.local.js
git commit -m "Removing no needed files"
```

De esta forma, la próxima vez que añadamos el fichero, ya no se subirá al repositorio ya que lo tendremos ignorado.

#### Usando git....

Esto mismo se puede conseguir usando un simple comando git, siguiendo el ejemplo anterior sería:

```bash
git rm config.local.js
git commit -m "Remove config.local.js to ignore it"
```

Razones para usar este método:

- *rm* es un comando de sistema y no de git.
- *git rm* es sólo un comando y simplifica la tarea de borrar archivos de un repositorio.
- *git rm* va a evitar que se borre si el archivo tiene alguna modificación.
- Puedes usar el parámetro *--dry-run* para ver que ficheros se borrarán

#### Manteniendo el fichero en el directorio de trabajo

Para conseguir eso, debemos realizarlo añadiendo el parámetro --cached a git rm.

```bash
git rm --cached <nombre del archivo>
```

Si fuera necesario borrar una carpeta y todos los ficheros, se deberá añadir el parámetro -r.

## Ramas

Una rama es una versión del repositorio que se crea a partir de un commit.

El término rama de Git diverge de las ramas de un árbol, pues en el caso del árbol, las ramas crecen y nunca vuelven al tronco, en Git, las ramas puede divergir y luego reunirse de nuevo, es mas como una salida de autopista que se puede reconectar con la vía principal.

![[Pasted image 20240531165142.png]]

La creación de ramas nos permite el trabajo en paralelo sobre una misma base de código.

Al grabar cambios con commits en una rama, se genera una bifurcación en el historia de cambios del proyecto.

### Creación_ramas

El comando *git branch* es el que nos permite crear, listar, eliminar y renombrar ramas. Al crear una rama, para movernos a ella, tendremos que usar el comando *git switch*.

```bash
# creamos la rama mi-primera-rama
git branch mi-primera-rama

# cambiamos a la rama mi-primera-rama
git switch mi-primera-rama
$ Switched to branch 'mi-primera-rama'

# para realizar las dos acciones anteriores a la vez (crear y cambiar de rama)
git switch -c mi-primera-rama

# esto es lo que sucede si intentamos crear una rama con el mismo nombre
git switch -c mi-primera-rama
$ fatal: A branch named 'mi-primera-rama' already exists.
```

#### *git checkout*, el comando que hacía demasiadas cosas.

El siguiente comando crearía y cambiaría a mi-primera rama directamente:

```bash
git chekout -b mi-primera-rama
& Switched to a new branch 'mi-primera-rama'
```

Esto no sigue la filosofía Unix de que un programa haga una cosa y la haga bien, por esto se crearon en 2019 los comandos *git switch* y *git restore*, y por compatibilidad git checkout no puede volver al estado anterior, así que es mejor usar ya los comando nuevos y olvidar este comando.

###  Listando_ramas

Sólo se debe ejecutar el comando *git branch*:

```bash
git branch
$ feat/remove-husky-usage
$ feat/remove-not-needed-deps
$ * feat/sui-bundler
$ master
```

La rama que tiene un * significa que actualmente te encuentras en esa rama.

Para averigurar con un comando en que rama estamos sería *git branch --show-current*

Para averiguar las ramas mas recientes, usaremos el parámetro --sort y el valor committerdate para ordenar las ramas por fecha de creación.

```bash
# El comando completo quedaría como:

git branch --sort=-committerdate
```

### Trabajando_con_ramas

Podemos usar [visualizing git](https://git-school.github.io/visualizing-git/) para ver como avanza a mediado que vamos añadiendo comandos, es una gran herramienta para practicar, pero vamos a avanzar paso a paso y de forma lo mas ilustrada posible en este documento.

```bash
# Empezamos con la rama principal master

git branch --show-current
$ master

# grabamos un commit en la rama principal
git commit -am "first commit"
```

![[Pasted image 20240605233836.png]]

Vamos a ir viendo como cambia el puntero HEAD conforme nos vayamos "moviendo"

```bash
# Creamos nuestra primera rama y cambiamos a ella para empezar a trabajar

git switch -c my-branch
$ Switched to a new branch 'my-branch'
```

![[Pasted image 20240605234708.png]]

Como podemos ver el puntero HEAD ahora mismo está en la rama master y my-branch ambas apuntan al mismo commit.

```bash
# estamos en la rama my-branch

git branch --show-current
$ my-branch

# modificamos los ficheros necesarios desde el editor

nvim test.c

# si el fichero fuera nuevo debería añadirlo con git add test.c
# vamos a pensar que sólo es una modificación

git commit -am "branch commit"
$ [my-branch afaf06b] first branch commit
$ 1 file changed, 5 insertions(+), 0 deletions(-)
```

![[Pasted image 20240605235256.png]]

El commit se añade en la rama my-branch. el HEAD apunta a este commit y vemos como este commit tiene una flecha que enlaza con el de master, que es el que fue el origen.

Nos damos cuenta de que en master hay un pequeño bug

```bash
# cambiamos a la rama master
git switch master

# editamos el fichero en el editor..
nvim fichero-bug.c

# grabamos el commit en la rama master
git commit -am "bug fixed"
```

![[Pasted image 20240606000122.png]]

Ahora vemos como las ramas empiezan a divergir.

Hemos encontrado otro pequeño bug en la rama principal que debemos arreglar.

```bash
# editamos claro
nvim otro-fichero-bugeado.c

# grabamos el commit en master
git commit -am "another bug fixed"
```

![[Pasted image 20240606000919.png]]

Con esto podemos ver como se han ido separando las ramas y como con *git switch* podríamos cambiar de una rama a otra, ahora vamos a ver como fusionarlas.

### Fusionado_ramas

Las ramas pueden ser fusionadas o pueden terminar en el olvido para no terminar en ningún lado pues descartamos las modificaciones.

Cuando hablamos de fusión nos referimos a que los cambios que hemos realizado en una rama se integran en otra rama, normalmente este tipo de fusión ocurre de una rama a la rama principal.

*git merge* el comando para fusionar ramas.

El uso es estando en la rama destino, lanzamos el comando y el nombre de la rama, para seguir con el ejemplo anterior, sería algo como git merge my-branch desde la rama main.

```bash
# nos aseguramos de estar en la rama destino
git branch --show-current
$ main

# vamos a incorporar los cambios de my-branch
git merge my-branch
```

![[Pasted image 20240606004302.png]]

Al ejecutar el comando git merge, se crea un nuevo commit que incluye todos los cambios de la rama de origen en la que nos encontramos ahora.

