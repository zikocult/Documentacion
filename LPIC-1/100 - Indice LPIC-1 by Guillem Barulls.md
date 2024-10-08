- [101 - Arquitectura de sistema](101_Arquitectura.md)
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
- [102 - Instalación de Linux y administración de paquetes](102_Instalacion_administracion.md)
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
-  [103 - Comandos GNU y Unix](103_comandos.md)
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
- [104 - Dispositivos, sistemas de archivos y FHS](104_Sistema_archivos.md)
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

&nbsp;
- [105 - Shells, scripts y administración de datos](105_Shells_scripts_y_admin_datos.md)
	- Personalizar y trabajar en el entorno de shell
		- Variables
			- Globales
			- Locales
		- Funciones
		- Archivos de configuración de bash
	- Editar y escribir scripts simples
		- Definición del interpretador
		- Variables especiales
		- IF then else
		- Case
		- Sustitución de comandos
		- Operaciones matemáticas
		- For
		- Until
		- While
	- Administración datos SQL
		- Interactuar con los datos
		- Consultas de datos
		- Modificación y borrado
		- Relación de tablas

&nbsp;
- [106 - Interfaces de usuario y escritorio](106_Interfaces_de_usuario_y_de_escritorio.md)
	- Instalar y configurar X11
		- Hardware
		- Instalación y configuración
		- Xorg.conf
		- Fuentes
		- DISPLAY
	- Configuración del gestor de login gráfico
	- Accesibilidad

&nbsp;
- [107 - Tareas administrativas](107_Tareas_administrativas.md)
	- Cuentas de usuarios
	- Grupos de usuarios
	- Automatizar y programar tareas
		- AT
		- Cron
	- Localización e internacionalización

&nbsp;
- [108 - Servicios esenciales del sistema](108_Servicios_esenciales_del_sistema.md)
	- Mantenimiento de la fecha y hora del sistema
	- Configurar y recurrir a los archivos LOG
	- Fundamentos MTA: Mail Transfer Agent
	- Configuración de impresoras e impresión (CUPS)

&nbsp;
- [109 - Fundamentos de red](109_Fundamentos_de_red.md)
	- Fundamentos de los protocolos de internet (IP)
	- Configuración básica de red
	- Soluciones de problemas simples

&nbsp;
- [110 - Seguridad](110_Seguridad.md)
	- Permisos y root
		- Verificación de permisos
		- Acceso como root
	- Red y seguridad del host
		- Verificación puertos abiertos en el sistema
		- Desactivación de servicios de red
		- TCP_Wrapers
	- Protección de datos con encriptación
		- Openssh
		- Túneles encriptados
		- X remoto por SSH
		- Firma GnuPG

## EXTRA

![[terminal-cheatsheet.pdf]]