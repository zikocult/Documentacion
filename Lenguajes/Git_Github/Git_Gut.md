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