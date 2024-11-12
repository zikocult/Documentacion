
- [[#Configurando un RAID]]
	- [[#Creación de un RAID por software]]
- [[#Soporte a discos IDE y SATA]]
- [[#Soporte a discos SSD]]
	- [[#SSD]]
	- [[#NVMe]]
- [[#iSCSI and SAN Storage]]
	- [[#Accediendo a los SAN por red]]
	- [[#Usando iSCSI]]
- [[#Logical Volume Manager (LVM)]]

## Configurando un RAID

Siempre es mejor un RAID por Hardware, pues tiene su propia controladora y por software lo debe manejar el Kernel de Linux, realizando gasto a la CPU. En el caso de ser un RAID por hardware, Linux lo verá como un solo disco.

MD = multiple dives `/dev/md0`

*MD Raid*, es el que controla los RAIDS de Linux, soporta los diferentes tipos de RAID, que son:
- RAID 0 Stripe
- RAID 1 Mirror
- RAID 4 Parity disk
- RAID 5 Parity stripe
- RAID 6 Double Parity
- RAID 10 Striped mirrors

El software a instalar es el paquete `mdadm`

>Si los discos ya habían estado anteriormente en un RAID, antes de configurarlos, habrá que borrarlos por completo, pues almacenan información en el `superblock`, al inicio del disco.

Para borrar el `superblock` usaremos el siguiente comando:

```bash
sudo mdadm --zero-superblock /dev/sdb /dev/sdc /dev/sdd /dev/sde /dev/sdf
```

### Creación de un RAID por software

Vamos a poner un par de ejemplos ilustrativos de la creación de algunos tipos de RAID:

La siguiente orden creará un *RAID1* (un mirror), creando así `/dev/md0`

```bash
sudo mdadm --create --verbose /dev/md0 --level=1 --raid-devices=2 /dev/sdb /dev/sdc
```

Vamos a desglosar las opciones en esta creación:

| Comando        | Descripción                                                                                                  |
| -------------- | ------------------------------------------------------------------------------------------------------------ |
| --create       | Opción para crear el RAID desde discos no usados                                                             |
| --verbose      | Mas info durante la creación                                                                                 |
| /dev/md0       | Punto dónde se montará                                                                                       |
| --level=x      | X será el tipo de RAID (0, 1, 5, ...)                                                                        |
| --raid-devices | Dispositivos que usará el raid, es diferente la cantidad de discos según el tipo de RAID que vayamos a crear |

A parte de la opción create (la opción principal de mdadm), tendremos otras opciones como son, en todos los casos, justo después irá el `device`, algunos casos tienen opciones que mencionaré a continuación:

| Opción            | Descripción                                               |
| ----------------- | --------------------------------------------------------- |
| --assemble        | Vuelve a ensamblar un array creado anteriormente          |
| --build           | Crea o ensambla un array sin metadata                     |
| --manage          | Realiza cambios en un array existente                     |
| --grow options    | Reasigna tamaños a un array activo                        |
| --incremental     | Añade o quita un disco de un array                        |
| --monitor options | Monitorea los cambios en el array                         |
| --misc options    | Reporta o modifica varias md relativas a los dispositivos |

Añado otro comando ilustrativo para la creación de un RAID5 (en este caso son necesarios 3 discos):

```bash
sudo mdadm --create --verbose /dev/md0 --level=1 --raid-devices=2 /dev/sdb /dev/sdc
```

Una vez creado, verificaremos la instalación, las formas mas típicas son:

```bash
lsblk
cat /proc/mdstat
```

Ya con esto, montaremos los discos a nuestro sistema, voy a poner el ejemplo del RAID5, pues es un poco mas complejo (no mucho), pero mas ilustrativo:

```bash
sudo mkfs.ext4 /dev/md0
sudo mkdir /mnt/raid1 /mnt/raid5
sudo mount /dev/md1 /mnt/raid5
df -h
```

>Cuidado, pues UDEV puede renombrar después del primer boot, así que es recomendable reiniciar una vez creado antes de incluirlo en fstab.

Es recomendable usar aliases en `/dev/md`:
- /dev/md/Atenea:0

## Soporte a discos IDE y SATA

Los discos IDE y SATA son identificados automáticamente por el Kernel del sistema, pero es recomendable hacer un poco de mejora (aunque en la mayoría de los casos no es necesario). Se detectan automáticamente en `/dev`.

*Identificación*, para ello podemos usar algunas herramientas básicas:
- `lsblk`
- `sudo lshw -class disk`
	- IDE y SATA ambos son identificados como discos ATA

![[Pasted image 20241108183647.png]]

Para cambiar algún **parámetro de los discos**, permitiendo mejorar los discos para un trabajo específico, usaremos el software `hdparm`

```bash
sudo apt install hdparm
sudo hdparm -I /dev/sda #-I information
```

*Ejemplo* de habilitar o deshabilitar la escritura de la cache.
- La escritura de la caché no es deseable en algunas bases de datos
- Para configurarla, seguiremos unos sencillos pasos
	- Checkear que la escritura está soportada
		- `sudo hdparm -W /dev/sda`
	- Habilitarla
		- `sudo hdparm -W 1 /dev/sda`
	- Deshabilitarla
		- `sudo hdparm -W 0 /dev/sda`

**SMART** -> **S**elf-**M**onitoring **A**nalysis and **R**eporting **T**echnology

Para ver el estado de SMART en los discos deberemos instalar `smartmontools`, para comprobar el estado, simplemente ejecutaremos:

```bash
sudo smartctl -i /dev/sda
#Así haremos una query del estado de salud del disco
sudo smartctl -H /dev/sda
```

Podemos también ejecutar un *test* SMAR para ver con mas detalle, para eso haremos:

```bash
sudo smartctl -t <test> /dev/sda
#test = short (1-2 minutos) // long (10+ minutos)
sudo smartclt -a /dev/sda #para ver los resultados del test
```

## Soporte a discos SSD

>Primero que todo aclarar que los discos SSD y NVMe son diferentes y se tratarán con diferentes aplicaciones, ahora lo veremos.

### SSD

Lo discos SSD (Solid-state Disks), tienen las siguientes características:
- La mayoría son como los discos SATA
- Alta fragmentación de datos
- Escritura amplificada
- TRIM (equivalente a la desfragmentación de los discos normales)

**TRIM**: no todos los discos admiten TRIM, debemos verificar si así es con el siguiente comando:

```bash
sudo hdparm -I /dev/sda | grep TRIM
```

Para realizar trim a un disco de manera manual:

```bash
sudo fstrim -v </mountpoint>
```

### NVMe

Sus características serían:
- Non-volatile memory express
- Namespaces
- Sin interfaz AHCI, así que las herramientas habituales no funcionarán
- Implementa DSM Deallocate en vez de TRIM
	- Data Set Management (DSM)

Para trabajar con los discos NVMe, usaremos el paquete `nvme-cli`, con el que podremos realizar el siguiente comando para ver el estado de SMART:

```bash
sudo nvme smart-log /dev/nvme0n1
```

Como podemos ver en el anterior comando, la notación de las particiones es particular, pues se marcará como `nvme<número de disco>n<número de partición>` 

## iSCSI and SAN Storage

Los SAN van por fibra para aprovechar su velocidad. Los SAN permiten añadir discos e*n un pool externo y compartido.*

Pueden ir por TCP también usando el protocolo *FCOE* (fiber channel over ethernet), pero no es recomendable, pues perderíamos velocidad, aunque siempre es una opción. *HBA* (Host Bus Adapter, diseñado para los SAN), plataforma entre el controlador de discos y la NIC (la tarjeta de red Network Interface Component).

Los SAN se muestran como discos locales, normalmente necesitan poca o ninguna configurarión.

### Accediendo a los SAN por red

- **iSCI** (internet scsi), el protocolo se encapsula en TCP/IP, tiene un rendimiento moderado, adecuado para LAN.
- **FCOE** (comentado antes), pobre rendimiento,  adecuado para la replicación entre localizaciones.
- **AoE** (ATA over Ethernet), ATA protocol corre sobre la capa 2 (data link layer), no es enrutable, pero tiene un buen rendimiento.

### Usando iSCSI

Para ello necesitaremos el paquete `tgt`, habilitaremos el servicio en el servidor y configuraremos el fichero `/etc/tgt/conf.d/tgt.conf`

```bash
sudo apt install tgt -y
sudo systemctl enable --now tgt
sudoedit /etc/tgt/conf.d/tgt.conf
```

Un ejemplo de fichero podría ser:

```bash
<target iqn.ziko-server:storage>
	backing-store /dev/sdc
	initiator-adress 10.0.222.50
</target>
```

>Típicamente el firewall se deberá por el puerto `3260 TCP`, pero para asegurar por el puerto que va, sería conveniente usar el comando `ss -natp` para ver el puerto que está usando (`sudo ufw allow 3260/TCP`)

Para verificar la instalación, podemos usar los siguientes comando: 

```bash
sudo systemctl restart tgt
sudo tgtadm --node target --op show
sudo ss -natp
sudo ufw allow 3260 comment 'iSCSI target'
```

Para **configurar el cliente**, necesitaremos del cliente `open-iscsi`, descubriremos en nuestra red los discos configurados con `sudo iscsiadm -m discovery -t st -p 10.222.51` y editaremos el fichero `/etc/iscsi/initatorname.iscsi`

```bash
sudo iscsiadm -m discovery -t st -p <IP>
sudo edit /etc/iscsi/initatorname.iscsi
# InitiatorName=iqn.ziko-server:storage
```

Para que el *inicio sea automático*:

```bash
sudoedit /etc/iscsi/nodes/iqn.ziko-server\:storage/10.0.222.51\,3260\,1/default
# Cambiar en este fichero las opciones node.startup a automaticç
node.startup = automatic
```

>Para verificar la instalación realizaremos los siguientes comandos:

```bash
sudo systemctl restart open-iscsi iscsid
sudo iscsiadm -m session -o show
sudo iscsiadm -m session -P3
sudo iscsiadm -m session -P3 | grep scsi
lsblk
```

Configurando la *autentificación del server*
	+ `sudoedit /etc/tgt/conf.d/tgt.conf`
		- `incominguser donslaptop password123`
		- `outgoinguser dpserver password123`
	+ `sudo systemctl restart tgt`

Configurando la *autentificación del cliente*
	+ `sudoedit /etc/iscsi/nodes/iqn.dons-server\:storage/10.0.222.51\,3260\,1/default`
	+ Change: 
		- `node.session.auth.authmethod = None`
	+ To:
	
```
node.session.auth.authmethod = CHAP
node.session.auth.username = donslaptop
node.session.auth.password = password123
node.session.auth.username_in = dpserver
node.session.auth.password_in = password123
```


## Logical Volume Manager (LVM)

Normalmente viene instalado por defecto en casi todas las distribuciones actuales y se trata de una manera segura de manipular la información de los discos. En el caso que no estuviera instalado, el paquete a instalar sería `lvm2`, que nos da las herramientas que a continuación se irán citando.

Contiene 3 niveles de configuración, voy a incluir un nivel extra, que es el montado, pero ya no depende de la herramienta:
1. Volúmenes físicos
2. Grupos de discos
3. Agrupar en los grupos (LVM)

Vamos a realizar un ejemplo donde veremos los 3 niveles en la creación, mas tarde veremos que para borrarlos, debemos seguir estos 3 niveles, pero a la inversa, de 3 a 1.

*Creación de volúmenes físicos*

```bash
pvcreate /dev/sdb /dev/sdc
# Dos comandos para ver si se han creado correctamente
pvdisplay 
pvs
```

*Creando un grupo de volumen*

```bash
vgcreate vg1 /dev/sdb /dev/sdc
# Dos comandos para ver si se han creado correctamente
vgdisplay
vgs
```

*Creando  los grupos (LVM)*

>Nota: después de -L pondremos el tamaño que queremos asignar al volumen, no necesariamente todo el espacio disponible.

```bash
lvcreate -L 250G vg1 -n website
# Dos comandos para ver si se han creado correctamente
lvdisplay
lvs
```

*Montando los LVM*

>Primero deberemos darle un formato

```bash
mkfs.ext4 /dev/vg1/website
mount /dev/vg1/website /mnt/website #La carpeta debe existir
lsblk -f
```

Para hacerlo persistente, añadiremos la siguiente linea a /etc/fstab (pongo opciones por defecto, pero podemos poner cualquier otra si es necesario)

```
/dev/vg1/website /mnt/website ext4 defaults 0 0
```

*Añadiendo un nuevo disco y algo de espacio a la LVM*

Seguiremos los siguientes pasos, siguiendo con el ejemplo que he ido trazando:

```bash
fdisk /dev/sdd
partprobe
pvcreate /dev/sdd
vgextend vg1 /dev/sdd
lvresize -L +50G /dev/vg1/website
df -h
# Esto hará los cambios visibles para el sistema
resize2fs /dev/vg1/website 
lvdisplay
```

*Removiendo todo*

>Como he comentado al inicio, ahora para tirarlo todo, debemos seguir los pasos a la inversa, siguiendo con el ejemplo, haremos:

```bash
# Desmontamos
umount /dev/vg1/website
# Borramos la LVM
lvremove /dev/vg1/website
# Quitamos el grupo
vgremove /dev/vg1
# Sacamos los discos
pvremove /dev/sdb /dev/sdc /dev/sdd
```