Fue una pequeña charla en la que aprendimos los comandos básicos, voy a dejarlos por escrito a modo resumen rápido.

Para iniciar el repositorio.

```bash
git init
```

Comando básico que nos muestra el punto en el que estamos

```bash
git bash
```

Añadimos al stage ficheros creados o modificados

```bash
git add .

# si queremos excluir los ocultos
git add *
```

Para realizar los commit

```bash
git commit -m "mensaje"

# Si son ficheros que ya están en seguimiento podemos añadirlos sin pasar por el git add tal que
git commit -am "mensaje"
```

Para ver los commits

```bash
git log

# Para verlos de una forma reducida
git log --oneline
```

El comando multi herramienta, hace de todo, pero no del todo bien, en breve quedará en desuso

Esto creará una rama (sin las comillas) y te moverá a ella

```bash
git checkout -b "nueva rama"
```

Para saber en que rama estamos y la creación en si

```bash
git branch

# Para la creación sólo sería poner el nombre de la rama al final del comando, pero no nos moverá a ella como checkout

git branch "nueva rama"
```

**Fast forward**: es mover una rama al último commit de otra, para realizarlos, haríamos:

Voy a realizar el ejemplo, quieriendo fusionar la rama de desarrollo (llamada dev) en master

```bash
# Nos movemos a la rama "final"
git switch master
git merge dev
```

Si queremos deshacer los cambios de un commit, podemos usar lo siguiente

```bash
# Recordar que podemos ver los commits y sus SHA con git log --oneline
# Esto borraría incluso los archivos creados, n sería el número de commits que quiero tirar atrás
git reset --hard HEAD~n

# En cambio esto nos borraría el commit, pero no borraría los archivos, sólo los devolvería al stage
git reset --soft HEAD~n
```

Recomendación de software:

- git graph (extensión de VsCode)
- gitkraken (versión gráfica para Linux)

Para ver de modo "gráfico" en terminal, podemos poner el comando:

```bash
git log --oneline --all --graph
```

Debemos intentar limpiar lo mas posibles las ramas que vayamos dejando vacías.

Podemos deshacer un merge haciendo un *git reset*, teniendo en cuenta que si hemos borrado la rama mergeada, quedará huerfana.

Podemos quitar los commits con la opción hard como hemos visto antes.

Para coger un commit y subirlo a la parte de otra rama que consideremos, usaremos:

```bash
git cherry-pick "SHA del commit dónde queremos mover la rama"
```

Para subir una rama a otra justo al inicio

```bash
git rebase

# modo interactivo
git rebase -i
```

A partir de aquí se aceleró la conferencia para terminarla lo antes posible, anoté los siguientes comandos como pude pero **se deberán revisar por mi parte**

```bash
git flow

# Para ver donde clonamos y cambiarlo si fuera necesario
git remote -v 
git remote add origin
git remote set-url origin
```

Los **HOOK**, tenemos ejemplos en los .git de los repos, son scripts para realizar acciones concretas.