
## 1. Mantenimiento de la fecha y hora del sistema

**Relojes**: el reloj de a BIOS sólo se lee durante el boot, luego usa uno separado de este.

Con el comando **date** podemos ver la fecha y hora de sistema, si le añadimos el parámetro -u lo muestra en formato UTC(GMT+0).

Para modificar el reloj de la BIOS usamos hwclock, con los siguientes parámetros:
 
| Parámetros | Descripción                                           |
|:----------:| ----------------------------------------------------- |
|     -w     | actualiza el reloj de la BIOS con la hora del sistema |
|     -s     | actualiza la hora del sistema con el reloj de la BIOS |
|     -u     | indica que se usa UTC                                 |

**NTP**: Network time protocol, para configurar un sistema que use NTP, necesitaremos modificar el fichero **/etc/ntp.conf** y tener el servicio **ntpd** activo, este servicio usa UDP con el puerto 123.

```
Ejemplo de ntpd.conf:

server es.pool.ntp.org
server 0.pool.ntp.org
driftfile /etc/ntp.drift (almacena los errores)
```

## 2. Configurar y recurrir a los archivos LOG

Guardan el registro de las operaciones del PC, a mayoría se encuentran en /var/log y son controlados por el servicio **syslog**.

El syslog se configura por el archivo **/etc/syslog.conf**, cada rega se separa en selector y acción separados por espacios y tabulaciones:

- **Selector**, en su parte se divide en:
	1. **facility**, que identifica el mensaje de origen
		- auth
		- authpriv
		- cron
		- daemon
		- ftp
		- kern
		- lpr
		- mail
		- news
		- syslog
		- user
		- uucp
		- local0 hasta el 7
	2. **priority**, que varían en menos urgentes a mas urgentes, de menos a mas:
		1. debug
		2. info
		3. notice
		4. warning
		5. err
		6. crit
		7. alert
		8. emerg
- **Action**,  determina el destino dependiendo del mensaje, normalmente los mensajes se envían a /var/log, pero podemos redireccionarlos mediante pipes, consolas, hosts, etc.

Es posible hacer que syslog registre mensajes de otras máquinas de red, para ello iniciamos en el servidor el programa syslogd -r.

Como los logs son ampliados continuamente es recomendable mover os mensajes antiguos a otro ado, esto se hace mediante e comando **logrotate** (se usa normalmente con cron) y su configuración se realiza en **/etc/logrotate.conf**

Podemos también crear entradas manuales de log, conel comando **logger** comando, si añadimos -p podemos indicar faciltiy/priority.

## 3. Fundamentos de MTA: Mail transfer Agent

El programa que controla el envío/recepción de mails se denomina MTA, existen diferentes opciones como son sendmail, postfix, qmail o exim. Funciona como servicio del sistema a través del puerto 25, responsable del protocolo **SMTP**.

El direccionamiento puede definirse en /etc/aliases, si modificamos este, tenemos que ejecutar newaliases para que se apliquen, también es posible reenviar editando el archivo .forward del home.

Para mostrar la cola de correo electrónico y el estado de transferencia usamos el comando **mailq**.

## 4. Configuración de impresoras e impresión

El programa responsable de la impresión de se denomina CUPS y es compatible con herramientas del sistema de impresión antiguo lpd, la configuración de CUPS puede hacerse modificando sus archivos por linea de comandos y por la web (es la mas recoendada)

Para accedere por web usamos http://localhost:631, para que este funcione tiene que estar activo el servidor de impresión /usr/bin/cupsd que inicia en el boot en la mayoría de las distros.

Archivos de configuración de CUPS (/etc/cups):

- clases.conf: define las clases de impresoras locales
- cupsd.conf: configuraciones del daemon cupsd
- mime.convs: define los filtros disponibles para conversión de formatos de archivos
- printers.conf: define los tipos de archivos conocidos
- lpoptions: configuraciones específicas para cada impresora

Para la administración usaremos el comando **lpadmin**:

| Parámetros      | Descripción                                                                |
| --------------- | -------------------------------------------------------------------------- |
| -c clase        | agrega la impresora indicada a una clase, si no existe se creará           |
| -m modelo       | especifica el driver estandar de la impresorara (generalmente archivo ppd) |
| -r clase        | elimina la impresora elegida                                               |
| -v dispositivo  | indica la interfaz que usará la impresora                                  |
| -D info         | descripción textual de la impresora                                        |
| -E              | autoriza a la impresora a recibir trabajos                                 |
| -L localización | descripción textual de la localización de la impresora                     |
| -P archivo ppd  | especifica el driver de la impresora                                       |
| -x nombre       | se elimina la impresora por nombre                                         |

Para ver datos por comandos usaremos **lpingo**:

| Parámetros | Descripción                                                    |
|:----------:| -------------------------------------------------------------- |
|     -v     | muestra la lista de dispositivos de impresión y sus protocolos |
|     -m     | muestra los modelos de impresoras disponibles                  |

Para modificar las opciones de impresión tenemos que ejecutar **lpoptions**, para ver el estado de las impresoras **lpstat -a** y para ver la cola de impresión **lpq** (-a todas las colas del sistema y -P las de la máquina especificada), todas estas colas se almacenan en **/var/spool/cups**

Para **imprimir archivos** usamos el comando **lpr**:

| Parámetros | Descripción                                                         |
|:----------:| ------------------------------------------------------------------- |
|   -Pxxx    | envía el archivo a la cola xxx                                      |
|    -#x     | imprime el documento x veces                                        |
|     -s     | no copia a la cola de impresión, si no que crea un enlace simbólico |

Para cancelar un trabajo de impresión usamos **lprm nº** (si no se indica el nº se cancelará el último mandado) y para cancelar todo **lprm -a**

Una impresora también puede ser configurada para ser compartida por red desde CUPS o desde SAMBA.