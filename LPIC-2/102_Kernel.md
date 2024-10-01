- [[#Introducción]]
- [[#Módulos del kernel]]
	- [[#Vista de los módulos cargados]]
	- [[#Habilitar y deshabilitar módulos]]
	- [[#Verificando los módulos]]
	- [[#udev]]
- [[#Compilación de un Kernel]]
	- [[#Prerequisitos]]
	- [[#Conseguir el código fuente]]
	- [[#Creación fichero configuración]]
	- [[#Compilando el nuevo kernel]]
	- [[#initrd y initramfs]]
	- [[#Compilando módulos del Kernel]]
- [[#Monitorización del Kernel]]
	- [[#/proc]]
	- [[#Cambiando valores en /proc]]
		- [[#Cambiando valores con sysctl]]

## Introducción

- Kernels de los sistemas operativos
	- Permite al software acceder al hardware
	-  Asignar recursos de hardware para cumplir con las solicitudes de software
	- Manejar eventos multi tarea
	- Actuar como policía de tráfico
- El Kernel de Linux
	- Desarrollado por Linus Torvalds
		- Diseñado para emular UNIX
	- Independiente
	- Open source
	- Realizado con el esfuerzo de incontables contribuciones por parte de programadores para formar Linux
- Trabajo del Kernel:
	- No depende del Kernel
		- Aplicaciones
		- Windows managers
		- Herramientas GNU
		- Sistemas de inicio
	- Si depende del Kernel
		- Tratamiento de la memoria
		- Tratamiento de procesos
		- Control del hardware
		- Disk file Systems
- El Kernel
	- Normalmente almacenado en `/boot`
	- Varios posibles nombres del fichero en si
	- Nombres descomprimido
		- `kernel`
		- `vmlinux`
	- Nombres comprimido
		- `vmlinuz` (el mas común)
		- `zImage`
		- `bzImage`
	- Normalmente la compresión es con GNU Zip (gzip)
	- Carga en RAM de una imagen
		- La carga se realiza como un FS por parte de GRUB
		- Lo encontramos como: `/boot/initrd.img`
		- Es sólo la imagen de los módulos necesarios por tu sistema, así que su tamaño dependerá de tu hardware.
- Kernels monolíticos
	- Los kernel monolíticos actúan como un gran proceso únicamente alojado en RAM.
	- Los micro kernels parten el kernel en múltiples procesos.
	- Linux es molítico
	- El kernel de Linux soporta la lectura de módulos que expanden su funcionalidad.
		- Normalmente ubicado en `/lib/modules`
		- `/lib/modules/5.8.0-45-generic/kernel`
	- Documentación del Kernel
		- Documentación instalada
			-  `/usr/src/linux/Documentation/`
			- `/usr/share/doc/linux-doc/`
		- Instalando documentación
			- `sudo apt install linux-doc`
			- `sudo apt install linux-source`
		- Escrito en reStructuredText usando Sphinx
			- `make htmldocs`
			- `make pdfdocs`
		- Se pueden visualizar online en:
			- [https://www.kernel.org/doc/html/latest](https://www.kernel.org/doc/html/latest)
	- Kernel headers
		- Mínimo de ficheros necesarios para compilar módulos
		- Usado para validar las funciones de llamada al kernel
			-  ¿Coincide la salida producida con lo que la función espera?
		- Mucho mas pequeño que el código fuente entero del kernel.

## Módulos del kernel

Los encontraremos en `/lib/modules` en forma de ficheros, así como su precompilado `*.ko`, mas adelante en algún ejemplo, veremos rutas aclaratorias.

Los módulos sirve para no tener todos los drivers de hardware cargados en memoria, sólo los que necesitas, por eso el uso de módulos, que pueden ser habiltados o deshabilitados según sea necesario.

### Vista de los módulos cargados

**lsmod**: este comando nos mostrará una lista de todos los módulos activos en el sistema, como hemos comentado antes, cada sistema dependerá de la cantidad cargados, según la carga de hardware que tenga asociada.

**modinfo**: con este comando podremos ver información de un módulo específico, la manera genérica de uso sería:

```bash
modinfo <module_name>
# Ejemplo
modinfo soundwire_intel
```

**demsg**: Con esto examinaremos los logs y podremos ver los módulos cargados al inicio, así como la detección de hardware.

```bash
# Truqui para ver lo que tenemos habilitado de inicio
dmesg | grep enab
```

### Habilitar y deshabilitar módulos

**insmod**: habilita un módulo de manera temporal, los módulos los cargaremos desde `/lib/modules`. Vamos a realizar un ejemplo:

```bash
# instalamos el módulo ena
sudo insmod /lib/modules/5.8.0-45-generic/kernel/drivers/net/ethernet/amazon/ena/ena.ko
lsmod | grep ena
```

**rmmod**: Deshabilita un módulo cargado, siguiendo el ejemplo anterior:

```bash
sudo rmod ena
lsmod | grep ena
# ya no nos mostrará nada
```

**modprobe**: Habilita y deshabilita módulos sin necesidad de poner todo el path y haciendo todo por si mismo.

>Tiene un tracking de dependencias.

```bash
# Añadimos y removemos con las siguientes lineas
sudo modprobe -a ena
sudo modprobe -r ena
```

### Verificando los módulos

Además del mencionado anteriormente `dmesg`, tenemos varias herramientas para ver el hardware que tenemos instalado:

| Comando | Función                                                        |
| ------- | -------------------------------------------------------------- |
| lsusb   | Lista todo lo que tengamos conectado por USB                   |
| lspci   | Lista todo lo que tengamos conectado a la placa base           |
| lsdev   | Es un listado de todos, se debe instalar el paquete `procinfo` |

### udev

Es el demonio encargado de asignar el nombre a los diferentes componentes, sigue las normas predefinidas en el kernel, estas normas pueden ser reescritas en `/etc/udev/rules.d`

Ejemplo de renombramiento de la tarjeta de red `ens33` a `eth0`

```bash
# El fichero se creará nuevo, no existe por defecto
sudoedit /etc/udev/rules.d/70-persistent-ipoib.rules
# Incluiremos todo los parámetros siguientes al fichero en una sola linea
SUBSYSTEM=="net", ACTION=="add", DRIVERS=="?*", ATTR{address}=="00:0c:29:dd:2e:8e", ATTR{type}=="1", KERNEL=="ens33", NAME="eth0"
# Recargamos udev
sudo udevadm control --reload-rules && udevadm trigger
```

Podemos monitorizar los cambios mediante `udevadm monitor`

## Compilación de un Kernel

Las razones para compilar un kernel pueden ser:

- Habilitar módulos requeridos
- Deshabilitar módulos innecesarios
- Revisión del código de seguridad

Esto nos llevaría a tener que recompilar el kernel cada vez que lo quisieramos actualizar, con lo que es una tarea mas tediosa y a nivel de costes sería alto, pues no es un trabajo de un rato, aún y así, tiene las ventajas antes mencionadas y un tunning perfecto para el sistema si está bien realizado.

Vamos a poner el ejemplo de una máquina **debian**

### Prerequisitos

```bash
# Editar el fichero sources.list para añadir los repositorios
sudo vim /etc/apt/sources.list
# descomentar las siguientes lineas:
deb-src http://archive.ubuntu.com/ubuntu focal main restricted
deb-src http://archive.ubuntu.com/ubuntu focal-updates main restricted
```

```bash
# Instalación de diferentes paquetes necesarios
sudo apt-get update
sudo apt-get install build-dep linux linux-image-$(uname -r)
sudo apt-get install build-essential libncurses5-dev gcc libssl-dev grub2 bc bison flex libelf-dev fakeroot
```

### Conseguir el código fuente

Tenemos dos opciones:

- Desde el repositorio oficial de debian:
	- `sudo apt-get source linux-image-unsigned-$(uname -r)`
- Desde [Kernel.org](https://kernel.org/)
	- Descarga directa
	- Siguiendo el siguiente comando (buscar una carpeta adecuada y modificando la versión de Kernel según necesidad):
		- `cd /usr/src` (esto es un ejemplo de un buen sitio, pero no es necesario)
		- `wget http://cdn.kernel.org/pub/linux/kernel/v5.x/linux-5.9.16.tar.xz`
		- `tar -xvf linux-5.9.16.tar.xz`

### Creación fichero configuración

Podemos directamente modificar el fichero de configuración de forma manual, pero tiene miles de opciones, el fichero sería `/usr/src/linux/.config`

También podemos importar una configuración existente:

```bash
cp /boot/config-5.4.0-67-generic /usr/src/linux-5.9.16/.config
```

O podemos usar las múltiples configuraciones que nos permiten con el make (recomiendo menuconfig), que serían:

- Usar la configuración por defecto
	- `sudo make defconfig`
- Volver a usar una configuración desde una build previa
	- `sudo make oldconfig`
- Usar un text-based UI para crear una configuración
	- `sudo make menuconfig`
- Usar un entorno gráfico
	- `sudo make xconfig`

### Compilando el nuevo kernel

```bash
sudo make -j2 deb-pkg
# la j indica el número de cores que se van a usar para compilar
```

Este proceso lleva mucho tiempo, aprox 2 horas en entornos virtuales y 1 hora en hardware, por eso lo de limitar los cores, pues usaría toda la potencia del equipo.

### Instalar el nuevo kernel

- Automáticamente como paquete:
	- `dpkg -i linux-*.deb`
- Manualmente como fichero.
	- Un fichero `vmlinux` ha sido creado
	- Copiarlo a `/boot` y apuntarlo a GRUB
	- También podemos realizar un simlink o similar

No es necesario recompilar el kernel por cada máquina si tienen el mismo hardware, podemos trasladar el fichero directamente a cada máquina.

### initrd y initramfs

Contienen los ficheros usador por el Kernel durante el boot del sistema, algunos pueden ser requiridos como los controladores de un RAID.

Pueden ser forzados con mkinitrd y mkinitramfs

### Compilando módulos del Kernel

Muchas veces puedes evitar el realizar un kernel customizado, creando un módulo customizado en su lugar, para eso usaremos `DKMS`:
- Dynamic Kernel Module Support
- Permite la compilación dinámica de módulos
- `dkms build -m <module_name> -v <#>`
- `dkms install -m <module_name> -v <#>`

## Monitorización del Kernel

Hay dos carpetas que tienen una función especial en cada sistema:

**/dev**: representación del hardware presente en el sistema.
**/proc**: Carpeta virtual que contiene la representación del kernel y los procesos del sistema

### /proc

- Las carpetas numeradas representan los procesos activos del sistema, dentro podemos encontrar una serie de ficheros interesantes:
	- `cmdline`: muestra el comando ejecutado para arrancar el proceso
	- `cwd`: es la carpeta dónde ha sido ejecutado
	- `exe`: que se está ejecutando con todo su path
	- `environ`: nos mostrará todas las variables de entorno que está usando
	- `status`: información general del estado
- También podemos encontrar varios datos, que podríamos ver con algunas utilidades, pero o si bien no las tenemos instaladas, o tenemos problemas para obtenerlas, podemos consultar estos ficheros, voy a poner unos pocos ejemplos
	- Ejemplo 1:
		- `cat /proc/sys/kernel/version`
		- `uname -v`
	- Ejemplo 2:
		- `cat /proc/uptime`
		- `uptime`
	- Ejemplo 3:
		- `cat /proc/modules`
		- `lsmod`

### Cambiando valores en /proc

Es posible cambiar los valores usando un editor de texto, pero necesitas ser el propietario del proceso o ser root. Es útil si no existe la herramienta adecuada, pero generalmente *no se aconseja*.

#### Cambiando valores con sysctl

Este comando si nos permite cambiar los valores de los parámetros del kernel, vamos a poner algunos ejemplo con sysctl y sus ficheros homólogos:

- Saber el máximo de ficheros abiertos:
	- `cat /proc/sys/fs/file-max`
	- `sysctl fs.file-max`
- Saber la cantidad de ficheros que podemos abrir concurrentemente:
	- `cat /proc/sys/fs/file-nr`
	- `sysctl fs.file-nr`
- Cambiar el máximo de ficheros abiertos:
	- `sudoedit /proc/sys/fs/file-max`
	- `sysctl -w fs.file-max=2000000` (-w escribe)

Para hacer los cambios permanentes debemos realizar las siguientes acciones:

- Modificar el fichero `/etc/sysctl.conf` o añadir un fichero en `/etc/sysctl.d`
	- `sudo vim /etc/sysctl.d/00-custom-settings.conf` (el fichero no existe y podemos poner el nombre que queramos)
	- `fs.file-max=2000000` (esto lo añadiremos dentro del fichero)
	- `sudo sysctl -p` aplicará los cambios en caliente, si no sería necesario reiniciar.