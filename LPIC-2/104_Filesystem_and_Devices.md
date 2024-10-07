- [[#Fstab Configuration]]
	- [[#Información requerida]]
	- [[#Modificando fstab]]
	- [[#Errores comunes de fstab]]
- [[#Memoria SWAP]]
	- [[#Crear nuevo espacio de Swap]]
	- [[#Modificar la swap]]
- [[#Montaje de unidades con SystemD]]
- [[#BRTFS]]
	- [[#Subvolumes y snapshots]]
- [[#Trabajando con almacenamiento encriptado]]
	

## Fstab Configuration

Se trata de un fichero que describe en forma de tabla los filesystems que queremos montar durante el inicio del sistema, el fichero se trata de `/etc/fstab` y ha estado en los sistemas Unix desde hace muchos años.

Muestro un ejemplo de mi fstab que tengo en el sistema.

![[Pasted image 20241007120032.png]]

### Información requerida

En el pantallazo, en la primera linea podemos ver un poco el orden que requiere este fichero en cada linea, vamos a desglosar algunos conceptos y después lo pondré en el orden exacto con todos sus detalles.

- La localización del punto de montaje
	- Se trata de una carpeta dónde querremos montar el contenido del filesystem
	- Esta carpeta debe estar creada
- Tipo de FileSystem
	- ext4, xfs, vfat, ntfs, btrfs y un largo etc.
	- Necesitamos tener el módulo de Kernel cargado en InitRam para que fstab pueda montar durante el boot.
- Identificar el file system, tenemos varias formas:
	- Nombre del dispositivo (p.e /dev/sda1)
	- Etiqueta del dispositivo o label (p.e Storage)
	- UUID del dispositivo (p.e c326c39c-ca50-445f-9f18-520439b86c01)
	- Esta información la obtendremos con los comandos:
		- `lsblk -f`
		- `blkid`
- ¿Qué es UUID (Universally Unique Identifiers)?
	- Es un identificador único
		- Los nombres o las etiquetas, comunmente pueden ser duplicadas y fallaría el montaje.
	- Se asigna al volumen al formatearlo.
	- Permite identificar el volumen aún si lo movemos entre sistemas.

### Modificando fstab

- Campos de `fstab`:
	1. ID del dispositivo:
		- /dev/sda1
		- LABEL=Storage
		- UUID=c326c39c-ca50-445f-9f18-520439b86c01
	2. El punto de montaje
		- /mnt/storage
	3. Tipo de file system:
		- ext4
		- xfs
		- auto (no se recomienda, pues si hay un problema en el fs, tendremos problemas al realizar un check del mismo)
	4. Opciones:
		- Mútiples opciones, voy a enumerar unas pocas, pero recomendable leer la documentación oficial para revisarlas todas:
			- defaults (el mas usado)
			- ro (Read only)
			- user (permite a los usuarios montar el fs)
			- nofail (no se detiene si el fs no existe o ha desaparecido)
			- noauto (no monta el dispositivo automáticamente al inicio o al realizar un `mount -a` )
	5. Configuración de volcado:
		- Actualmente en desuso, se usaba antes para la automatización de los backup, en casi todos los casos será un 0, pero este es el significado
			- 0 -> no vuelques
			- 1 -> vuelca
	6. Chequeo del file system en caso de error:
		- 0 -> No lo chequees
		- 1 -> Root file system (fs crítico para el sistema, chequear primero)
		- 2 -> Otros file systems no críticos (chequear después)

### Errores comunes de fstab

1. Fallo al iniciar
2. Fallo al montar (revisar todas las opciones, carpetas de montaje, etc)
3. Corrupción del disco
4. Montado como Read Only

La forma mas común de testear la modificación del fichero antes de reiniciar sería `sudo mount -a`, que realizará un montaje de todos los sistemas que tengamos en fstab y nos devolverá un error en caso que lo haya.

## Memoria SWAP

La swap no es estrictamente necesaria, es una memoria virtual que se usa cuando nos quedamos sin memoria, puede ser un disco, un volumen o un fichero.

Monitorizando la memoria podremos ver el estado de la ram, dos comando muy usados son `free -h` o `swapon -s`

En caso que el sistema vaya corto de memoria será necesario encontrar el problema que consume toda la memoria, aumentar la cantidad de RAM física y añadir espacio SWAP.

Para determinar la cantidad de RAM, hay varias políticas a seguir, añado link de Ubuntu con las propias de Canonical: [Ubuntu SwapFaq](https://help.ubuntu.com/community/SwapFaq)

Aunque las reglas generales suelen ser:
	- Mínimo 1 Gb de Swap
	- Cuando haya dudas que la Swap tenga el mismo tamaño que la RAM del sistema.

### Crear nuevo espacio de Swap

Como hemos dicho antes, tenemos varias opciones, sea en un disco o en un fichero, así que vamos a ver cada caso:

- Si queremos que sea en un disco:
	- Debemos preparar una partición
	- Formatear la partición con el comando `mkswap /dev/sda1`
- Si queremos que se en un fichero
	- Usaremos la herramienta dd, en este caso voy a crear un fichero de 2 Gb en /var/swap:
		- `sudo dd if=/dev/zero of/var/swap bs=1M count=2048`
		- `sudo chmod 600 /var/swap`
		- `sudo mkswap /var/swap`
- Una vez creada, sea por disco o por fichero, debemos activarla, para ello usaremos el comando `swapon` según el caso:
	- `sudo swapon /var/swap`
	- `sudo swapon /dev/sda1`
- Ya sólo nos queda añadir esta nueva Swap a **fstab**, pues en caso contrario desaparecerá en el siguiente reinicio, las lineas a añadir serían:
	- `/var/swap swap swap defaults 0 0`
	- `/dev/sda1 swap swap defaults 0 0`

### Modificar la swap

Los pasos generales serían:

- Deshabilitar la memoria swap (con `sudo swapoff /dev/sda1`)
- Modificarla siguiendo los pasos anteriores
- Rehabilitarla

>Cuidado! trabajar sin swap, puede ocasionar que el sistema se cuelgue, con lo que es recomendable asegurar que tenemos una segunda fuente de swap, para conocer si tenemos en el sistema mas swaps, podemos verlo con `swapon -s`

En caso de tener varias swap, tendremos prioridades para cada una de ellas, las prioridades van de 0 a 32.767 y la swap será usada de mayor a menor prioridad, podría llegar a ser simultanea si la prioridad es la misma.

Seteamos la priodirdad de dos formas:
	- `sudo swapon -p 10 /dev/sda1`
	- En el fichero *fstab*, usando "pri=10" en el campo opciones.

## Montaje de unidades con SystemD

Las unidades de SystemD se agrupan en ficheros de texto simples, pueden definir servicios, puertos, tiempos, montajes, etc.

Sería similar a *fstab*, pero con las diferencias, de que cada unidad es un fichero individual y que el formato de opciones es vertical.

Beneficios de usar Systemd:
	- Jerarquia de dependencias
	- Sin esperas para montar un disco
	- Fácil de montar y desmontar usando `systemctl`

Para crear este fichero tenemos algunas "normas":
- El fichero deberá estar en la carpeta /etc/systemd/system
- El nombre del fichero será el punto de montaje, cambiando "/" por "-", por ejemplo: /mnt/sdb1 -> mnt-sdb1
- La extensión del fichero ser `*.mount`
- El fichero estará partido en al menos 3 bloques:
	- **[Unit]** -> Información genérica de lo que vamos a montar
		- *Description*=XXXX
	- **[Mount]** -> Opciones del montaje
		- *What*=/dev/sdb1
			- Este tiene un pequeño truco si queremos identificarlo por UUID y es el siguiente:
			- `What=/dev/disk/by-uuid/e57fc491-4a19-4f68-bac2-0fbd4c63a6be`
			- En la carpeta mostrada estarán todos los fs con un link a su UUID.
		- *Where*=/mnt/sdb1 -> Carpeta dónde queremos montarlo
		- *Type*=ext4 (etc..)
		- *Options*=defaults (las mismas que fstab)
	- **[Install]** -> el target al que querramos que se agregue
		- *WantedBy*=multi-user.target

	![[Pasted image 20241007132005.png]]

- Una vez tengamos el fichero, vamos a testear que todo es correcto y a añadirlo al inicio del sistema, para ello realizaremos las siguientes acciones:
	1. `systemctl daemon-reload` -> esto se debe hacer siempre que hagamos modificaciones en la carpeta `/etc/systemd/system` para que systemd obtenga los datos de los nuevos ficheros.
	2. `systemctl start mnt-sdb1.mount`
	3. `systemctl status mnt-sdb1.mount` -> si no nos da error ya debería estar montado, si no volvemos al punto de la modificación del fichero
	4. `systemctl enable mnt-sdb1.mount` -> y ya tendríamos el nuevo fs preparado para el siguiente arranque.

## BRTFS

File system bastante reciente, no llega a los 10 años de antigüedad, diseñado por Oracle con algunas funciones en mente como son:

- Copy on write (COW)
- RAID
- LVM
- Snapshots

Para usar las utilidades del propio fs, necesitaremos instalar el paquete `btrfs-progs`

```bash
sudo apt install btrfs-progs
sudo dnf install btrfs-progs
```

El formateo se realiza mediante `mkfs.btrfs`, puedes formatear una partición anteriormente creada o directamente un disco entero y funciona correctamente igual.

```bash
sudo mkfs.btrfs /dev/sdd1
sudo mkfs.btrfs /dev/sdd
```

Para comprobar el estado de los sistemas, tenemos las siguientes utilidades:

```bash
lsblk -f
sudo btrfs filesystem show
```

Creación de un **RAID1 o mirror**:

```bash
sudo mkfs.btrfs -m raid1 -d raid1 /dev/sda /dev/sdb

# -m Metadata
# -d Data
```

- Una vez realizado, podemos montar cualquiera de los de forma normal
- Btrfs manejará el mirror

### Subvolumes y snapshots

- Diseñados para facilitar los backups
- Normalmente para configurar las políticas de snapshots
- Similar a una partición
- Es una pieza del fs
- Parece un subdirectorio
- Se monta como un disco, pero es una construcción lógica
- Puede ser montado de forma independiente del resto del disco

* Creando un subvolumen:
	+ Primero debemos montar el volumen padre
		- `sudo mount /dev/sda /mnt/database`
	+ Creamos un par de subvolumenes:
		- `sudo btrfs subvolume create /mnt/database/db`
		- `sudo btrfs subvolume create /mnt/database/tl`
	+ Listamos los subvolumenes
		- `ls -la /mnt/database`
		- `sudo btrfs subvolume list -t /mnt/database`
			- `-t` lo muestra como una tabla
* Creando snapshots
	+ Los snapshots son subvolumenes
	+ Contienen un "point-in-time" de la información
	+ Ejecutaremos los siguientes comandos para realizar un snapshot del anteriormente creado db.
		- `sudo mkdir /mnt/data/snapshots`
		- `sudo btrfs subvolume snapshot /mnt/database/db /mnt/database/snapshots/db20241007`

>Es recomandable realizar los snapshots en otro disco físico, por si ocurriera un problema con el propio disco.

## Trabajando con almacenamiento encriptado

Vamos a trabajar en este caso con **LUKS** (Linux Unified Key Setup), tendría las sigüientes caraterísticas:

- Usa una llave maestra para encriptar una partición
- Múltiples llaves de usuario puede ser usadas para desencriptar la llave maestra
	- 8 o menos usuarios es lo recomendado
- Encripta el dispositivo entero
- Si se realiza la encriptación durante la instalación del SO, la encriptación es de 512bit AES
	- Para encriptar durante la instalación, le daremos a `Installation Destination`
	- Seleccionaremos el disco a encriptar
	- Check en `Encrypt my data` y aceptar
	- Entramos la pass phrase
	- Completamos la instalación de forma normal
- Habilitandola desde el cliente, por defecto es de 256bit AES

Para verificar que los discos no están encriptados usaremos `lsblk -f`, nos mostrará los tipos usuales (ext4, xfs, etc)

Se realizará un backup de la información del disco y se desmontará.

Usualmente, se recomienda borrar el disco con `shred`, proceso extremadamente largo, usualmente hora y media con hardware físico y unas 3 horas virtualizado:

```bash
shred -v --iterations=1 /dev/sdd1
```

Para instalar todo lo necesario necesitaremos el paquete `cryptsetup-bin` (si no hemos realizado la encriptación durante la instalación)

```bash
sudo apt install cryptsetup-bin
sudo dnf install cryptsetup
```

Inicializamos el dispositivo:

```bash
sudo cryptsetup -v luksFormat /dev/sdd1
#Durante el proceso introduciremos la pas phrase
```

Si ahora realizamos un `lsblk -f`, nos encontraremos que el tipo es algo como **crypto_LUKS**

Para abrir los dispositivos, introduciremos el siguiente comando:

```bash
sudo cryptsetup luksOpen <device> <alias>
sudo cryptsetup luksOpen /dev/sdd1 storage
```

\<alias> es el nombre que le daremos al disco encriptado, esto lo podemos encontrar en `/dev/mapper/alias`, en el caso del ejemplo `/dev/mapper/storage`

Para formatear, tendremos que apuntar a este "alias", para ello realizaremos este secuencia de comandos y quedará montado en nuestro sistema:

```bash
sudo mkfs.ext4 /dev/mapper/storage
sudo mkdir /mnt/storage
sudo mount /dev/mapper/storage /mnt/storage
# Dar permisos en la carpeta si es necesario que accedan usuarios
```

Esto desaparecerá en el primer arranque, con lo que deberíamos volver a abrir y montarlo, para ello, realizaremos una entrada en el fichero `/etc/crypttab`, si no existe se deberá crear y todo lo que tenemos que poner en él es lo siguiente:

```bash
storage /dev/sdc1 password1234
# No es recomendable añadir la password en este fichero, pero se puede realizar, si no lo añadimos, nos preguntará por la key en el arranque del sistema
```

Y añadir una linea en fstab tal que:

```bash
/dev/mapper/storage	/mnt/storage	ext4	defaults	0	0
```

Para añadir nuevas claves para usuarios realizaremos el siguiente comando:

```bash
cryptsetup luksAddKey /dev/sdc1
```

Y para eliminarlas:

```bash
cryptsetup luksRemoveKey /dev/sdc1
```