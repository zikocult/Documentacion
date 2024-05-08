
## 1. Instalar y configurar X11

El entorno de ventanas se llama X11 pero es conocido como X. Es posible hacer login en una sesión de X11 por red o mostrar una ventana de un programa en otro PC.

La configuración del X11 se realiza automáticamente durante la instalación de la distro. Podemos ver la compatibilidad de hardware en http://www.x.org/wiki/Projects/Drivers. Si un dispositivo no es totalmente compatible podemos usarlo en modo VESA que casi todos los dispositivos son compatibles.

Para la instalación si no se realiza desde la distro, pues podemos usar cualquier gestor de paquetes como apt o yum.

**Configuración de X11R6**

Configurar manualmente significa editar /etc/X11/xorg.conf donde se encuentra toda la configuración, para generar un archivo básico se usa X -configure y el servidor X probará el driver y guardará el resultado en xorg.conf.new en /

**Secciones de xorg.conf**

Se divide en secciones en el formato:
```
Section "nombre seccion"
	Item_1 "valor item1"
	Item_2 "valor item2"
Endsection
```

La mayoría de las secciones ya no son necesarias por la configuración se realiza de forma automática, las diferentes secciones son:


| Sección      | Descripción                                          |
| ------------ | ---------------------------------------------------- |
| Files        | Caminos para archivos necesarios como FontPath       |
| ServerFlags  | Opciones globales en formato Option "Nombre" "Valor" |
| Module       | Carga dinámica de módulos, Load "nombre_modulo"      |
| InputDevice  | Dispositovs de entrada, con Identifier y Driver      |
| Monitor      | Con varias secciones                                 |
| Screen       | Agrega el dispositivo y el monitor                   |
| Display      | Subsección de Screen                                 |
| ServerLayout | Agrega screen e InputDevice                          |

**Fuentes**

X11 suministra las fuentes usadas por las aplicaciones, existen dos sistemas:

- Core: Las fuentes se manipulan en el servidor X
- Xft: es mas avanzado y permite fuentes Type1, OpenTye y usar anti-alising

Para instalar fuentes xft basta con copiarlas a /usr/share/fonts o a ~/fonts y luego actualizar la caché con fc-cache. El comportamiento de las funciones de xft puede modificarse en /etc/fonts/fonts.conf.

**Servidor de fuentes xfs**: en entornos de red es posible tener  un único serviodr de fuentes que las compartirá con las demás máquinas. El puerto estándar es el 7100 para configurar una máquina para que las use hace falta configurar el FontPath "tcp/ipdelservidor:7100"

Variable **DISPLAY**
Permite que las ventanas de las aplicaciones se muestren en un servidor X remoto. A partir de esta variable de entorno DISPLAY, el servidor de ventanas identifica donde debe mostrarse.

La variable se copone de :nombre_o_IPmaquina.display de la máquina. En una máquina con un sólo display, la variable sera :0.0

Para abrir una ventana remota primero hay que redefinir la variable display en la máquina remota, ej export DISPLAY=192.168.1.3:0.0, con esto cualquier programa ejecutado después de cambio se enviaría a esa máquina pero no se mostrará hasta que esta lo permita, para ello se escribiría xhost +192.168.1.1

## 2. Configuración del gestor de login gráfico

Al iniciar X11 se iniciará la pantalla de Login con su gestor de pantalla, los 3 principales son:

- **xdm**: estándar del X, archivo de config /etc/X11/xdm/* . También permite el login por red usando el protocolo XDMCP (desactivado por defecto) configurable en /etc/X11/xdm/Xacces.
- **gdm**: Es el estándar de GNOME, archivo de config en /etc/gdm/.
- **sddm**: Es el estándar de KDE, archivo de config en /etc/systemd/system/display-manager.service