
- [[#Instalación desde el código fuente]]
	- [[#Ejemplo de descarga de código]]
- [[#Realizando backups con TAR]]
- [[#Realizando backups con DD]]
- [[#Realizando backups con rsync]]
- [[#Comunicación con usuarios]]

## Instalación desde el código fuente

Las razones mas importantes para compilar desde el código fuente directamente son:

- Queremos la última versión que ha salido (las distros tardan en ponerlas en sus repositorios)
- El paquete no está disponible
- La distribución no está soportada
- La posible revisión del código por nuestra parte
- Optimización del hardware

Para eso requeriremos

- Compilador (gcc es el mas usado para programas en C, pero puede estar en otros lenguajes)
- Librerías
- Documentación

Para obtener el código fuente lo podemos realizar mediante

- Los repositorios de nuestra distribución si habilitamos los repositorios dónde está alojado el código fuente (en debiant tenemos /etc/sources.list, donde tendremos que descomentar las opciones que dan acceso a los sources)
- GitHub
- Algunas páginas web (ahora veremos un ejemplo)

### Ejemplo de descarga de código

Vamos a instalar `John the Ripper`, que lo encontraremos en:

+ https://www.openwall.com/john/
+ https://www.openwall.com/john/k/john-1.9.0-jumbo-1.tar.gz

Una vez descargado, descargaremos la firma digital (a ser posible no desde la web oficial para evitar problemas de suplantación de identidad)

- `gpg --import openwall-offline-signatures.asc`
- `gpg --verify john-1.9.0-jumbo-1.tar.gz.sign john-1.9.0-jumbo-1.tar.gz`

Con todo esto, vamos a *compilar* nuestro aplicativo:

1. Obtener el código fuente (si no lo hemos descargado directamente de la web)

```bash
wget https://github.com/openwall/john/archive/bleeding-jumbo.tar.gz
```

2. Extraer el código al directorio de trabajo

```bash
tar -xvzf ./bleeding-jumbo.tar.gz
```

3. Realizar las tareas de configuración

```bash
cd john-bleeding-jumbo/src
configure
sudo apt install libssl-dev
configure
```

4. Compilar

```bash
make
```

Ya podemos proceder a *instalar* el software, con lo que tendremos varias opciones:

- Correrlo en el sitio
	- `../run/john`
- Correr el script de instalación
	- `./install.sh`
- Correr el instalador
	- `make install`
- Instalar el paquete según tu distribución (a veces pueden dartelo)
	- `sudo apt install john.deb`

## Realizando backups con TAR

Esta herramienta mueve todos los ficheros dentro de un sólo fichero, en sus inicios fue hecho para poder copiar en cintas de forma secuencial.

>TAR *NO hace compresión*, por eso se junta con gzip por ejemplo, ahora veremos las opciones.

**Compresión**

`tar -czvfp backup.tar.gz ~/Documents`

| opción | acciones              |
| ------ | --------------------- |
| c      | create                |
| z      | compress              |
| v      | verbose               |
| f      | file name             |
| p      | conserva los permisos |

>Luego veremos con mas detalle la conservación de permisos

**Restaurar desde un archivo  \*.tar.gz**

`tar -xvzf backup.tar.gz`

| opción | acciones   |
| ------ | ---------- |
| x      | Extracción |
| z      | Compresión |
| v      | Verbose    |
| f      | File Name  |

**Restaurar los permisos**

Los permisos son restaurados automáticamente si cuando se comprimió se añadió la *opción -p*, pero el owner es una historia diferente, para el owner, la mayoria de las distros (no todas), añaden la opción `--no-same-owner` en caso de que no seas root y `--same-owner` si lo eres, pero podemos forzarlo y este sería el resultado ()

>Si no tiene el owner en el sistema, asignará como propietario al usuario que descomprime, forcemos o no el usuario.

- Si eres root
	- `--same-owner`
	- Intentará mapear el owner a una cuenta existente
	- Si no existe lo asignará al usuario actual
- Si no eres root
	- `--no-same-owner`
	- Hace que el usuario actual sea el nuevo owner de todos los ficheros

## Realizando backups con DD

>Es una herramienta peligrosa, pues tiene la capacidad de borrar un disco entero.

dd = **Disk Duplicator**

Es una herramienta muy antigua, casi de los inicios, originalmente diseñada para convertir ficheros de un formato a otro, pero ahora es usado para clonar discos y particiones enteras.

Está presente en casi todas las distros y es muy usado cuando es necesario una imagen entera del disco (incluye boot record y otra info)

**Clonar un disco**, es sencillo y rápido

```bash
sudo dd if=/dev/sda of=/dev/sdb
```

- *if* -> input file
- *of* -> output file

>Los discos origen pueden estar *online*, pero hay que minimizar las escrituras durante la operación o pueden presentar inconsistencias en los datos, con lo que lo ideal es que estén los discos *offline* (desmontados)

**dd lineas de comando**

| opción       | acción                                                                                                                                             |
| ------------ | -------------------------------------------------------------------------------------------------------------------------------------------------- |
| conv=noerror | Ignora los errores                                                                                                                                 |
| conv=sync    | Sincroniza los datos (asegura una copia perfecta), realiza la copia de forma muy lenta, pero chequea toda la escritura                             |
| bs=64K       | Aumenta el block size a lo que le digamos 512 es el default, normalmente se usan bloque de un mega bs=1M, bloques mas grandes mejoran la velocidad |
| status=progress       | Muestra el progreso de la copia                                                                                                                    |
| count=1      | Empieza desde el primer sector el MBR                                                                                                              |
| bs=512       | Coge sólo los primeros 512K, combinado con count=1 copiará sólo la MBR                                                                             |

**Ejemplos:**

- Backup de una partición a un fichero imagen:

```bash
dd if=/dev/sda1 of=~/part1.img
dd bs=1M conv=sync,noerror status=progress if=/dev/sda1 of=/dev/sdb1
```

- Backup sólo de la MBR:

```bash
dd if=/dev/sda of=~/sda0.img count=1 bs=512
```

>*dd* no comprime absolutamente nada, es sólo una copia sector a sector del disco o partición, con lo que para comprimir, deberemos usar herramientas como gzip, ahora paso algunos ejemplos, pero como anotación, esto nos liberaría todo lo que esté marcado sin info *zero*, es decir, si una partición tiene 2Gb, pero ocupadas tiene 1Gb, dd generará un fichero de 2Gb, con gzip pasaríamos a 1Gb

**Comprimiendo un backup**

Pasaremos la salida no a of= si no que la "pipearemos" a gzip -c:

```bash
sudo dd if=/dev/sdd bs=1M | gzip -c > ~/sdd.img.gz
```

**Restauración de un disco**

Si no está comprimido, simplemente será el proceso inverso:

```bash
dd if=./sda.img of=/dev/sdc
```

Si está comprimido, el pipe irá a la inversa que anteriormente:

```bash
gunzip -c ~/sdd.img.gz | dd of=/dev/sdd bs=1M
```

>Pequeño truco, podemos ver el progreso de una operación dd si no ponemos el status=progress con el siguiente comando

```bash
kill -USR1 $(pgrep -x dd)
```

## Realizando backups con rsync

Sincroniza ficheros entre múltiples sistemas, puede ser usado para sincronización programada y las operaciones pueden ser de una vía o bidireccionales. Puede realizar backups diferenciales.

Su uso general sería:

```bash
rsync <options> <source> <destination>
```

>Nemotecnia para los operandos ms azure, pues las opciones son -azurP, paso a detallar que hace cada una:

| operando  | acción                                               |
| --------- | ---------------------------------------------------- |
| -a        | archivo (copia los atributos)                        |
| -z        | comprime en gzip                                     |
| -u        | salta ficheros que ya estén en destino (diferencial) |
| -r        | recursivo                                            |
| -P        | muestra el progreso                                  |
| -v        | verbose                                              |
| -e        | execute                                              |
| --dry-run | ejecuta un test sin lanzarlo realmente               |

>Para scripts, sacar la P siempre de todos los comandos, queremos que no se vea el progreso

**Backup remotos**
- *Modo listener*
	- Requiere que rsync esté corriendo en el equipo remoto
	- TCP port 873
	- Posible falla con las fechas si los servidores no están sincronizado en tiempo
	- No es seguro

```bash
rsync -asurP /home/ziko/Document ziko@debiantest:/home/ziko
```

- *Modo sobre SSH*
	- Tunel encriptado, proporciona seguridad
	- Al ir por SSH es sencillo que ya esté abierto en los firewalls
	- Requiere que la comunicación sea mediante *certificados* para que vaya bien

```bash
rsync -azurP -e ssh /home/ziko/Documents ziko@debiantest:/home/ziko
# Para pasar un puerto pasamos la opción a ssh
rsync -azurP -e 'ssh -p 4242' /home/ziko/Documents ziko@debiantest:/home/ziko
```

**Include/Exclude**

- Se pueden especificar ciertos ficheros para que se traten de forma diferente
- Puedes combinar *include y exclude*, se aplicará en el orden que lo pongas
- Transfiere todo excepto los pdf:
	- `rsync -azurP --exclude="*.pdf" --include=".*"/home/ziko/Documents ziko@debiantest:/home/ziko`
- No transfieras nada a excepción de los PDF:
	- Include debe ir antes
	- `rsync -azurP --include="*.pdf" --exclude=".*"/home/ziko/Documents ziko@debiantest:/home/ziko

**Manteniendo permisos**

- Se requiere ser *root*
- `-ogA`

| comando | permisos          |
| ------- | ----------------- |
| -o      | Owner             |
| -g      | Group             |
| -p      | Permissions       |
| -A      | ACLs (implies -p) |

## Comunicación con usuarios

Es muy útil cuando varias personas están usando un sistema, pues puede comunicar cambios como:
- Reinicio de servicios
- Actualización de software
- Montaje y desmontaje de discos
- Configuraciones de red
- Mantenimientos programados

Tenemos los *banners*, que se mostrarán en el login del usuario y tenemos de tres tipos:
- `/etc/issue`
	- Se muestra a usuarios locales antes de iniciar sesión (consola)
>poco útil, pues sólo se muestra en local
- `/etc/issue.net`
	- Se muestra en remoto a los usuarios antes de iniciar sesión (telent)
>telnet es jodidamente inseguro, con lo que esto está mas que desfasado
- `/etc/motd` (message of the day)
	- Se muestra a todos los usuarios después de logearse al sistema
>El mas usado por los problemas anteriormente mencionados

También podemos *escribir directamente en los terminales* de los usuarios, eso es mas útil si la gente ya está logeada y es mas inmediato:

- Podemos usar el comando *`wall`*
- Los mensajes deben estar habilitados
	- suelen estar habilitados por defecto
	- `mesg` nos mostrará el estado, básicamente:
		- mostrará el mensaje *"es n"* si está deshabilitado
		- mostrará el mensaje *"es y"* si está habilitado
	- `mesg y` o `mesg n` para cambiar este parámetro
	- Para mandar un mensaje
		- Encontrar el terminal ID de un usuario
			- `w` o `who`
		- Abrimos una conexión
			- `wall ziko pts/0`
		- Escribimos el mensaje
		- `Ctrl-D` para finalizarlo
- Notificaciones de sistema con `wall`
	- Algunos comandos se integran con las notificaciones de `wall`
	- Ejemplo: `shutdown`

```bash
sudo shutdown -r +10 "El sistema se apagará en 10 minutos"
# Si desearamos cancelar este reinicio programado
sudo shutdown -c
```