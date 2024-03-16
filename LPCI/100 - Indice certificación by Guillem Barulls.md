1. [101 - Arquitectura de sistema](./101_Arquitectura)
	- Identificar y editar configuraciones de hardware
		- Activación de dispositivos
		- Inspección de dispositivos
		- Tipos de dispositivo
		- Dispositivos de almacenamiento
	- Inicio (boot) del sistema
		- Cargador de boot (Bootloader)
	- Cambiar runlevels, apagar y reiniciar el sistema
		- Los niveles de ejecución
		- Numeración de los runlevels
		- SysVinit
		- SystemD
		- Apagar y reiniciar

&nbsp;
- [102 - Instalación de Linux y administración de paquetes](./102_Instalacion_administracion.md)
	- Dimensionar las particiones del disco
		- Sistema archivos raíz
		- Orden de montaje a partir del Boot
		- Linux exige al menos dos particiones
	- Instalar gestor de arranque
		- Lilo
		- Grub
		- Dispositivo arranque alternativo
	- Control de bibliotecas compartidas (LDD)
		- Identificar bibliotecas compartidas
		- Localización de las bibliotecas
	- Utilización del sistema de paquetes DEBIAN (apt y dpkg)
	- Utilización del sistema de paquetes Red Hat (rpm, yum / dnf y zipper)
	- Virtualización  en Linux
		- D-Bus Machine ID
		- Acceso seguro (SSH)

&nbsp;
-  [103 - Comandos GNU y Unix](./103_comandos.md)
	- Trabajar en la línea de comandos
		- Shell Bash
		- Variables
		- Comandos secuenciales
		- Referencias y manuales
		- Impresión de manuales
	- Procesar cadenas de texto por medio de filtros
	- Administración básica de archivos
		- Directorios y archivos
		- Manipulación archivos y directorios
		- Empaquetar archivos
		- Carácteres comodín (file globbing)
		- Búsqueda de archivos
	- Flujos pipes (tuberías) y redireccionamientos de salida
		- Redireccionamiento
		- Tubería (pipe)
		- Sustitución de comandos
	- Crear, monitorear y finalizar procesos
		- Monitorear procesos
		- Tareas en primer y segundo plano
	- Modificar la prioridad de ejecución de un proceso
	- Buscar en archivos de texto usando expresiones regulares
		- Expresiones regulares
		- Grep
		- SED
	- VI

&nbsp;
- [104 - Dispositivos, sistemas de archivos y FHS](./104_Sistema_archivos.md)
	- Crear particiones y sistemas de archivos
		- fdisk
		- PARTED
		- Creación del sistema de archivos
		- Partición Swap
	- Mantenimiento de la integridad de sistemas de archivos
		- Chequeo sistema archivos
		- Correción del sistema de archivos
		- Análisis del espacio de disco
	- Control y montaje de los sistemas de archivos
		- Fstab
		- Montaje manual de sistemas de archivos
	- Administrar cuotas de disco
	- Controlar permisos y propiedades de los archivos
		- Modificación de permisos
		- Permisos octales
		- Umask
		- Setuid, sguid y sticky bit
		- Modificar dueños y grupos de archivos
	- Archivos de sistema, ordenación y localización
		- Directorios que residen obligatoriamente en raíz
		- Directorios que pueden ser puntos de montaje
		- Localización de archivos

 