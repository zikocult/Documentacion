
## 1. Permisos y root

#### Verificación de permisos

Archivos con permiso SUID y SGID garantizan privilegios especiales a quien los ejecutan, un comando modificado que contenga ese permiso especial podrá dar acceso de root a un usuario común. Por lo tanto hay que monitorear que archivos tienen esos permisos, para ellos usaremos el siguiente comando:

```bash
find / -perm -4000 -or -perm -2000
```

Varios comandos deben tener estos permisos especiales, para facilitar el chequeo podemos generar una lista detallada (recomendable diariamente con cron):

```bash
find / \( -perm -4000 -or -perm -2000 \) -exec ls -l '{}' \; > /var/log/setuid-$(date +%F)
```

Esto generará un fichero que podremos comprar con el de días anteriores con el comando diff entre ambos ficheros.

Otra búsqueda a realizar es la de archivos con permisos de escritura para todos los usuarios excepto en /dev, ya que podrían modificarse para ser viable invasiones o daños. Para buscar esos archivos ejecutaríamos

```bash
find / -path /dev -prune -perm -2 -not -type l
```

Para buscar archivos sin dueño o sin grupo usamos:

```bash
find / \( -nouser -o -nogroup \)

```

También hay que revisar que las contraseñas de los usuarios estén en /etc/shadow. Retoque de contraseñas con el comando:

```bash
passwd parámetros usuario/grupo
```

Los parámetros mas usados de passwd serían:


| Parámetro | Descripción                                                                                                                       |
|:---------:| --------------------------------------------------------------------------------------------------------------------------------- |
|    -e     | Provoca la expiración inmediata de la contraseña                                                                                  |
|    -d     | borra la contraseña de la cuenta                                                                                                  |
|    -g     | modifica la contraseña del grupo seleccionado. Seguido de -r borra la contraseña, con -R restringe el acceso a todos los usuarios |
|    -l     | desactiva una cuenta                                                                                                              |
|    -u     | activa una cuenta                                                                                                                 |
|    -S     | nos indica el estado de una cuenta, paso a detallar el formato que usa                                                            |

- passwd -S
	- Login
	- P (tiene pass) /NP (no tiene pass)/L (cuenta bloqueada)
	- Fecha del último cambio de pass
	- Límite mínimo de días de contraseña
	- Límite máximo de días de contraseña
	- Días de aviso
	- Límite de días de inactividad desde que la contraseña caduca hasta qeu se bloquee la cuenta

~~~
Los atributos de las contraseñas se cambian con el comando **chage** (ver temas anteriores)
~~~


#### Acceso como root

Para accionar como root se usa el comando su, si no se pode argumentos, esta nueva sesión heredará las configuraciones de entorno y variables de la sesión donde se ejecuta

Si usamos su -l o su - se creará una nueva sesión totalmente distinta.

El comando sudo permite a un usuario o grupo realizar tareas antes reservadas a root, para ello estos usuarios tienen que pertenecer al grupo admin o sudo.

#### Limitaciones de recursos

Los usuarios pueden provocar lentitud o paradas del sistema para el uso de los recursos, por ello debemos limitar la cantidad de recursos máximos que pueden usar en el sistema, se hace a través del comando **ulimit** y este actúa a nivel de sesión de bash, por lo que sólo afecta a los procesos activos en esa  sesión.

Se debe establecer en cada recursu un límite soft (-S) que es el nivel de alerta y un límite hard (-H) que es el valor máximo.

Tiene los siguiente parámetros:


| parámetro | uso                                                                                                                              |
|:---------:| -------------------------------------------------------------------------------------------------------------------------------- |
|    -a     | muestra los límites actuales                                                                                                     |
|    -f     | especifica el nº máximo de archivos que podrá haber en la sesión de shell, es la opción por defecto si no se añade nada a ulimit |
|    -u     | número máximo de procesos disponibles para el usuario                                                                            |
|    -v     | valor máximo de memoria virtual disponible para el shell                                                                         |

## 2. Red y seguridad del host

#### Verificación de los puertos abiertos en el sistema

Usamos el programa **nmap**, por ejemplo nmap localhost y mostrará todos los puertos abiertos del equipo local, también podemos hacer esto con **netstat**

También podemos descubrir los puertos abiertos de un objetivo.

```bash
nmap -o IP_LAN
nmap -v -A <IP>
```

Con **netstat -l** obtenemos los puertos esperando conexiones del sistema local.

```bash
esto es la forma mas habitual de usar, las opciones mas comunes (no es broma :) )
netstat -putona
```

Para identificar que programa y usuario están usando un puerto usamos **lsof**, también sirve para ver quien está usando un fichero en concreto y desmontarlo si fuera necesario.

```bash
lsof -i máquina:puerto

con el siguiente veríamos que está usando el usuario x
lsof -u ziko

excluimos del listado los fichero abiertos por un usuario
sudo lsof +D /home -u ^ziko
```

Es un comando muy completo que debería tener un punto a parte para estudiarlo correctamente.

**fuser**, ve los procesos usados por cada usuario y puede desmontarlos.

```bash
para ver los procesos que está corriendo el usuario activo
fuser -v .

Con el siguiente veríamos que usuarios están usando un puerto en particular
fuser -v -n tcp 8002

Y con el siguiente mataríamos el proceso:
fuser -k 8002/tcp

Para ver las señales de sistema que podemos usar
fuser -l
```


#### Desactivación de servicios de red

Puede haber servicios de red que no usemos y es recomendable tener desactivados, para ello finalizamos el servicio y ejectuamos chmod -x script para quitar el permiso de ejecución.

Para servicios que no queramos que inicie por inted, comentamos la linea con #, y xinietd cambiamos disable a yes. 

Los correspondientes ficheros los encontraremos en **/etc/inetd.conf y /etc/xinetd.conf**, estos ficheros puede que esten fragmentados en la carpeta **/etc/inetd.d o /etc/xinetd.d**

Normalmente los servicio se interrumpen por medio del propio script que los inicia, pero poniendo el argumento stop, p.e /etc/init.d/samba stop.

Podemos bloquear el acceso al sistema de todos los usuarios excepto de root creando el archivo **/etc/nologin**, al intentar entrar los usuarios normales se les mostrará el contenido de ese archivo.

#### TCP Wrapers

Se usa para controlar el acceso a los servicios disponibles, este control se realiza por reglas en **/etc/allow y /etc/deny** que contiene direcciones remotas que podrán o no acceder a la máquina local. Primero se mira el allow y después el deny, pero si no consta en ninguno, se autoriza el acceso.

Se escribe en formato servicio:host:comando:

- **Servicio**: es uno o mas nombres de daemons de servicios.
- **Host**: es una o varias direcciones, puede ser dominio, ip completa o incompleta con *
- **Comando**: es un comando opcional que hará que se cumpla la regla.

En host y servicio pueden usarse instrucciones especiales como: ALL, LOCAL, KNOW, UNKNOW y PARANOID.

Ejemplo de regla para autorizar todos los serivicios para 192.168.1.0 excepto para .20:

```bash
En /etc/hosts.allow:
ALL:192.168.1.* EXCEPT 192.168.1.20

En /etc/hosts.deny
ALL:ALL (bloquea todo los servicios a toda dirección que no esté en allow)
```

## 3. Protección de datos con encriptación

#### OpenSSH
Es el sustituto de herramientas antiguas como rlong, rcp, telnet, etc.

El programa cliente es el paquete ssh y cuya configuración como cliente se encuentra en /etc/ssh/ssh_config.

Para conectar por ssh usamos: **ssh usario@ip**

Las claves se generan automáticamente por el servidor ssh y dependiendo de la encriptación se almacenan en distintos sitios.


| formato | clave privada             | clave pública                 |
| ------- | ------------------------- | ----------------------------- |
| RSA     | /etc/ssh/ssh_host_rsa_key | /etc/ssh/ssh_host_rsa_key.pub |
| DSA     | /etc/ssh/ssh_host_dsa_key | /etc/ssh/ssh_host_dsa_key.pub |

Cuando el cliente se conecta por primera vez, le pregunta si acepta la clave pública y si la acepta la almacenará en ~/.shh/know_hosts, que puede incluirse en /etc/know_hosts para que valga para todos los usuarios.

Además de las claves anteriores, cada usuario puede tener su clave pública y privada para garantizar la autenticidad y poder acceder sin necesitar de suministrar la contraseña de login.

Para acceder sin contraseña, es necesario crear la clave pública y primaria, la pública debe inclurse en el authorized_keys del host destino.

Estas claves se generan mediante el comando ssh-keygen:

```bash
creación clave dsa 1024 bits
ssh-keygen -t dsa -b 1024 

creación clave rsa 4096 bits
ssh-keygen -r rsa -b 4096
```


| Formato | Clave privada | Clave pública     |
| ------- | ------------- | ----------------- |
| RSA     | ~/.ssh/id_rsa | ~/.ssh/id_rsa.pub |
| DSA     | ~/.ssh/id_dsa | ~/.ssh/id_dsa.pub |

Podmoes añadir estas claves en el host remoto de diferentes maneras, añado ambas para el caso de usuario ziko en la máquina 192.168.1.1:

```bash
cat ~/.ssh/id_dsa.pub | ssh ziko@192.168.1.1 "cat >> ~/.ssh/authorized_keys"
ssh_copy_id -p [puerto] -i id_rsa.pub ziko@192.168.1.1
```

#### Túneles enciptados

SSH además de abrir sesiones rrmotas de shell, puede usarse como vehículo de otras conexiones, esto se conoce como un túnel SSH.

Una vez creado otro programa podrá comunicarse con la máquina remota por medio de este túnel de forma segura, como por ejemplo VNC que envía datos de forma insegura, pero podemos crear un túnel al puerto 5900 (VNC) de una máquina a otra para que de esta manera los datos estén protegidos.

Para crer túneles usaremos:

```bash
ssh -L puerto local:puerto remoto
```

Un ejemplo, dónde además de la -L añadimos -f que indica que se inicie en segundo plano y con -N indicamos que no debe abrirse sesión de shell en la máquina remota:

```bash
ssh -fNL 5900:localhost 5900:ziko@192.168.1.1
```

#### X remotor por SSH

Podemos abrir ventanas de una aplicación remota mediante ssh usando -X, ejemplos para iniciar VirtualBox

```bash
ssh -X ziko@192.168.1.1 (luego ejectuamos VirtualBox)
ssh -X ziko@192.168.1.1 "Virtualbox"
```

#### Firma GnuPG

Es una implementación de código abierto del estándar OpenPGP, con él es posible firmar y codificar archivos y mensajes, garantizando su autenticidad.

Esto se realiza mediante el concepto de clave pública y clave secreta (sólo la tiene el propioetario)

El comando para realizar funciones de GnuPG es gpg:


| comando                                                          | descripción                                                                                                                       |
| ---------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------- |
| gpg --gen-key                                                    | genera clave, se recomienda DSA, también nos pide caducidad y longitud.                                                           |
| gpg --list-keys                                                  | lista las claves que s3e encuentran en ~/.gnupg/                                                                                  |
| gpg --export                                                     | exporta la clave pública para dársela a los demás y que puedean autenticar. P.E. gpg --output archivo.gpg --export laIDaexportar. |
| gpg --send-keys IDkey                                            | envia a un servidor de claves, por defecto es key.gnupg.net pero podemos cambiarlo con ~/.gnupg/gpg.config                        |
| gpg --import nombre.gpg                                          | importa la clave                                                                                                                  |
| gpg --recv-keys idclave                                          | importa la clave desde el servidor de claves, esta clave es almacenada en ~/.gnupg/pubring.gpg                                    |
| gpg --sign-key idclave                                           | fir la clave para garantizar su autenticidad                                                                                      |
| gpg --output documento.gpg --sign documento                      | Firmar un documento con gpg, el archivo firmado se le enviará a la persona mediante la clave pública del autor                    |
| gpg --output documento --decrypt documento.gpg                   | Paso contrario, sirve para asegurar la autoría                                                                                    |
| gpg --output documento.gpg --encrypt --recipient phess documento | Encripta un documento                                                                                                             |
| gpg --output documento --decrypt documento.gpg                   | Desencripta un documento                                                                                                          |

