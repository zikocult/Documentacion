- [[#Introducción]]
- [[#SystemD init]]
- [[#SysV init]]
- [[#System Recovery with GRUB]]
	- [[#Corrigiendo los menús de GRUB]]
	- [[#Recuperando un GRUB dañado en un sistema]]
- [[#Personalización InitRAM disk]]
	- [[#Modificación y empaquetado initrd]]

## Introducción

Actualmente casi todos los sistemas modernos usan `systemd`, pero aún podemos encontrar algunos sistemas que usan `sysv`, con lo que vamos a revisar ambos.

## SystemD init

Para identificar que estamos en una distro con Systemd, buscaremos el PID 1 con `ps aux`, que nos identificará el primer proceso que haya ejecutado el sistema (owner root) y haremos un ls al comando que nos muestre, quedándonos algo así (variará según la distribución que estemos usando, pero lo que queremos encontrar es el symlink), para identificar a systemd.

```bash
ps aux | grep head
ls -l /sbin/init
$ /sbin/init => /lib/systemd/systemd
```

>Nota: También podemos mirar si tenemos el comando `systemctl`, ejecutarlo sin ningún parámetro y si es así, nos devolverá todas las unidades del sistema

Systemd, hace correr los daemons del sistema, que son servicios y aplicaciones que corren en el background del sistema.

Las `unit files` definen los servicios, los podemos identificar en `/lib/systemd/system`, tendrán la extensión **\*.target**

Los `target`definen una colección de unidades a ejecutar y establecen unas dependencias y jerarquía de ejecución, el target inicial lo podemos encontrar ejecutando `systemclt get-default`, que por defecto tendrá dos valores:

- graphical.target (entornos gráficos con X)
- multi-user.target (entornos sin gráficos, sólo consola)

Para cambiar este target inicial, podemos ejecutar `systemctl set-default <target que queramos>` o en su defecto, cambiar el symlink que tenemos en `/lib/systemd/system`, denominado `default.target`, borrándolo y rehaciéndolo al target que nosotros consideremos (graphic or multi-user)

Systemctl puede habilitar, arrancar, parar o deshabilitar cualquier servicio, para ello tenemos las siguientes opciones:

| Comando                      | Descripción                                                                 |
| ---------------------------- | --------------------------------------------------------------------------- |
| systemctl start <servicio>   | Arranca un servicio, no rearrancará en el siguiente inicio de la máquina    |
| systemctl restart <servicio> | Para y arranca un servicio (la forma de restart está marcada en los target) |
| systemctl stop <servicio>    | Para un servicio en ejecución                                               |
| systemctl enable <servicio>  | Habilita un servicio para que arranque con el sistema, no lo arranca.       |
| systemctl disable <servicio> | Deshabilita un servicio para el arranque del sistema, no lo detiene.        |

La creación de nuevas unidades debe ser emplazada en `/etc/systemd/system/`, en la carpeta que corresponda a nuestro default, las carpetas tendrán terminaciones **\*.wants**.

Para relanzar las nuevas unidades, haremos un `systemctl daemon-reload`

## SysV init

Este sistema empieza a estar deprecado, casi todos los sistemas modernos usan ya systemd.

En este caso, para identificarlo, debemos saber que `SysVinit` corre el script `/etc/rc.d/rc.sysinit` o en algún sistema muy antiguo `/etc/rc.local` cuando init finaliza.

Sysv usa un sistema de runlevels, que básicamente es una ejecución de scripts que están en las carpetas `/etc/rc.d/rcX`, donde X es el runlevel que vamos a tener.

Cada runlevel debe ser usable por él mismo, eso quiere decir, que contendrá los scripts necesarios para arrancar el sistema en el modo que requiera y sólo contendrán symlinks a `/etc/init.d`

| Runlevel | Descripción                                |
| -------- | ------------------------------------------ |
| 0        | Apagar                                     |
| 1        | Single user mode                           |
| 2        | Multiuser text mode with no network        |
| 3        | Multiuser text mode with network           |
| 4        | Unused (se usa para algun runlevel custom) |
| 5        | Multiuser with GUI                         |
| 6        | Reboot                                     |

>Puede variar según las distros, pero es lo mas común está distribución de runlevels

Para verificar el runlevel tenemos dos opciones:

- `runlevel`
	- Esto nos devolverá un valor p.e `N 5`
	- `N` significa que no ha sido modificado desde el arranque
	- `5` significa el actual runlevel es 5
- `who -r`
	- Nos muestra el actual runlevel

Para cambiar el runlevel en caliente, sólo debemos ejecutar `init X`, siendo X el runlevel requerido, pero sería conveniente hacer un `who` para ver quien está en el sistema y un `who -r` para ver el runlevel actual.

El runlevel definido por defecto, se configuraría en el fichero `/etc/inittab`.

>No podemos asignar los runlevel 0 o 6, pues son usados para apagar o reiniciar el sistema

Para configurar un servicio, tenemos las siguientes herramientas:

| Comando                        | Descripción                                                                                               |
| ------------------------------ | --------------------------------------------------------------------------------------------------------- |
| chkconfig httpd <on\|off>      | Configura un servicio para que arranque con el sistema, por defecto lo pondrá en 2345                     |
| chkconfig --list               | Nos lista los servicios configurados                                                                      |
| chkconfig --level 35 httpd on  | Es un ejemplo, pero con este ejemplo, ponemos el servicio httpd a arrancar en los runlevels 35 únicamente |
| chkconfig --level 24 httpd off | En este caso quitaríamos el servicio httpd a arrancar en los runlevels 24 únicamente                      |
| service httpd start            | Arranca el servicio httpd                                                                                 |
| service httpd stop             | Para el servicio httpd                                                                                    |
| service httpd restart          | Rearranca el servicio httpd                                                                               |
| service httpd status           | Mira el estado del servicio httpd                                                                         |


## System Recovery with GRUB 

**GR**and **U**nified **B**ootloader (GRUB), es un gestor de arranque Open Source.

Funciones:
- Múltiples arquitecturas
- Menús gráficos
- Modo rescate
- Módulos

Los menús de entrada apuntan a los diferentes sistemas del disco, exactamente a sus kernels.

Los principales puntos de error con GRUB son:

- El arranque dual con otros sistemas operativos pueden reescribir la instalación de GRUB (sobretodo Windows) o pueden directamente no detectarlos por alguna razón por lo tanto no actualizar la lista de sistemas.
- El error humano a la hora de tipar los diferentes ficheros de configuración suele ser un punto dónde podemos encontrar errores también, así como las versiones de Kernel hard codeadas, que no serán actualizadas.
- La encriptación de discos puede reescribir a GRUB también.

Para modificar los parámetros de GRUB lo haremos modificando el fichero `/etc/default/grub`, una vez lo hayamos modificado, deberemos recargar el fichero de configuración, las órdenes cambiarán según la distro:

```bash
# Debian y derivados
sudo update-grub2 
# RH y Arch Linux
sudo grub-mkconfig -o /boot/grub/grub.cfg 
# Podemos cambiar el path de -o si antes queremos ver el fichero generado
```

El fichero de configuración está en la carpeta `/boot/grub` o `/boot/grub2` y se llamará `grub.cfg`

>Este fichero no debe ser editado directamente (aunque yo lo he hecho y funciona)

### Corrigiendo los menús de GRUB

Tenemos diferentes configuraciones de diferentes distros:
- `/boot/grub/menu.lst` 
- `/boot/grub/grub.conf`
- `/etc/default/grub`

Voy a poner un ejemplo de Debian:

El menú es automáticamente generado al arrancar, pero hay scripts que lo generan en `/etc/grub.d`.

Debemos copiar la entrada existente del menuentry que queremos cambiar realizando los siguientes pasos:

```bash
less /boot/grub/grub.cfg
# Buscar por menuentry y copiar en el siguiente fichero
sudoedit /etc/grub.d/40_custom
# Realizar en este punto un update
sudo update-grub
sudo grub-mkconfig # Test, aún no lo subimos
sudo grub-mkconfig -o /boot/grub/grub.cfg # Ahora si, definitivo
```

Ejemplo de menuentry:

```
menuentry 'Ubuntu (Init Test)' --class ubuntu --class gnu-linux --class gnu --class os $menuentry_id_option 'gnulinux-simple-a8af722f-c40a-4f72-844b-8afbbaa6b742' {
        recordfail
        load_video
        gfxmode $linux_gfx_mode
        insmod gzio
        if [ x$grub_platform = xxen ]; then insmod xzio; insmod lzopio; fi
        insmod part_msdos
        insmod ext2
        insmod raid10
        set root='hd0,msdos5'
        if [ x$feature_platform_search_hint = xy ]; then
          search --no-floppy --fs-uuid --set=root --hint-bios=hd0,msdos5 --hint-efi=hd0,msdos5     --hint-baremetal=ahci0,msdos5  a8af722f-c40a-4f72-844b-8afbbaa6b742
        else
          search --no-floppy --fs-uuid --set=root a8af722f-c40a-4f72-844b-8afbbaa6b742
        fi
        linux   /boot/vmlinuz-5.8.0-55-generic root=UUID=a8af722f-c40a-4f72-844b-8afbbaa6b742 r    o find_preseed=/preseed.cfg auto noprompt priority=critical locale=en_US quiet
        initrd  /boot/initrd.img-5.8.0-55-don
}
```

### Recuperando un GRUB dañado en un sistema

1. Arrancar con un LiveCD o con otro sistema operativo Linux.
2. Buscar el disco apropiado, se recomienda `lsblk -f` o `blkid` para conseguir los UUID de los discos.
3. Montar el disco: `sudo mount /dev/sda1 /mnt/sda1`
4. Reinstalar GRUB: `sudo grub-install --root-directory=/mnt/sda1 /dev/sda`
5. Desmontar el disco: `sudo umount /dev/sda1`
6. Reiniciar el sistema

## Personalización InitRAM disk

InitRam contiene todos los ficheros necesarios para arrancar el sistema, en si podríamos decir que es un pequeño sistema operativo, que ronda los 50 Mb. 

Sólo está presente durante el arranque, se carga y se borra de la memoria después de que el arranque sea finalizado.

**¿Por qué modificar initrd?** No todos los módulos del kernel se leen en el momento del arranque, ni todos los módulos están presentes en initrd, la mayoría están almacenados en la partición root, con lo que puede causar problemas si necesitas drivers para tus discos, NIC/iSCSI o similares.

Localizar initrd es sencillo, aunque varía el nombre final según la distribución:

Sistemas basados en **Red Hat**:

El fichero lo encontraremos en `/boot/initramfs-version.img`, para generar el fichero por defecto realizaremos:

```bash
mkinitrd
mkinitrd /boot/initramfs-<version> <version>
# P.e - mkinitrd /boot/initramfs-4.18.0-193.14.3.el8_2.x86_64.img 4.18.0-193.14.3.el8_2.x86_64
# Usa uname -r para saber la versión actual
mkinitrd /boot/initrd-$(uname -r) $(uname -r)
```

Sistemas basados en **Debian**:

El fichero lo encontraremos en `/boot/initrd-version.img`, para generar el fichero por defecto realizaremos:

```bash
mkinitramfs
mkinitramfs -o /boot/initramfs-<version> <version>
# P.e - mkinitramfs -o /boot/initramfs-4.18.0-193.14.3.el8_2.x86_64.img 4.18.0-193.14.3.el8_2.x86_64
mkinitramfs -o /boot/initrd-$(uname -r) $(uname -r)
```

Para poder examinar el contenido de initrd, estará comprimido con `cpio` para el microcódigo y `gzip` para el resto.

Lo extraeremos con la siguiente orden:

```bash
unmkinitramfs /boot/initrd.img-$(uname -r) initramfs/
```

La estructura de la carpeta descomprimida será:

- `/initramfs`
	+ `/early - x86_64 microcode (AMD)`
	+ `/early2 - x86 microcode (Intel)`
	+ `/main/lib/firmware`
	+ `/main/lib/modules`

### Modificación y empaquetado initrd

Necesitamos editar el fichero `/etc/initramfs-tools/modules` y añadir simplemente la linea con el nombre del módulo que necesitemos, por ejemplo `raid10`, `btrfs`, ...

Realizaremos entonces un update al actual initramfs `update-initramfs -u`, preferiblemente lo crearemos en una nueva ubicación `update-initramfs -c -b ~/`, si lo que queremos es crear una versión específica `update-initramfs -c -k 5.8.0-55-generic -b ~/`

>Revisar `/lib/modules/*` para la versión del formato.

En este punto y ya con nuestro nuevo initramfs, debemos actualizar GRUB tal como hemos visto anteriormente, copio un ejemplo sacado de la documentación oficial del curso:

* Updating GRUB
	+ Different configurations for different distros
		`/boot/grub/menu.lst` 
		`/boot/grub/grub.conf`
		`/etc/default/grub`
* Example: Ubuntu
	+ Menu is automatically generated at boot
	+ Uses scripts in `/etc/grub.d` to build
	+ Copy an existing entry
		- `less /boot/grub/grub.cfg`
		- Search for `menuentry`
	+ `sudoedit /etc/grub.d/40_custom`
	+ Push the Update
		- `sudo update-grub`
		- `sudo grub-mkconfig`
			+ Displays potential config
		- `sudo grub-mkconfig -o /boot/grub/grub.cfg`
			+ Installs the config