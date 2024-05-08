
## 1. Fundamentos de los protocolos de internet

Dirección IP está en formato X.X.X.X que es la expresión decimal de la dirección de red binaria, cada interfaz de red debe tener una dirección IP única.

Ejemplo conversión IP:
```
192.168.1.1 = 11000000.10101000.00000001.00000001
```

**Clases de red**: existen rangos específicos que no deben aplicarse a las LAN:
- **Clase A**: 1.0.0.0 a 127.0.0.0 8 bits de red y 24 hosts
- **Clase B**: 128.0.0.0 a 191.255.0.0 16 bits de red y 16 de hosts.
- **Clase C**: 192.0.0.0 a 223.255.255.0 24 bits de red y 8 de hosts.

Para que los datos puedan encaminarse correctamente por la red, la interfaz de red necesita conocer los siguientes datos:

- IP propia
- IP destino
- a que red pertenece, para ello necesitan conocer su máscara de red, para calcularlo, lo pasaremos a binario y si coinciden los bits de red, es la misma.

Una dirección puede venir en formato abreviado, por ejemplo:

```
192.168.1.129/25 que nos indica:
	- IP = 192.168.1.129
	- mask = 255.255.255.128
	- broadcast = 192.168.1.255
```

**Subredes**: una red puede dividirse en varias redefiniendo su máscara de red, de esta manera una red puede dividirse en redes menores (sin clase) denominadas CIDR, pongamos un ejemplo.

```
Red 192.168.1.0 y mask 255.255.255.0

Esta red puede dividirse en dos al activar el primer bit del cuarto octeto de la máscara, con lo que los primeros 25 bits serían para red, si usamos 26 bits, dividiríamos la red en 4.
```

![[Pasted image 20240503194922.png]]

**Rutas estándar**: cuando el destino no está en la misma red, es necesario establecer una ruta por donde se encaminarán los datos de este tipo, una **puerta de enlace**.

- IPv4 se trata de una versión de 32 bits, formada por 4 grupos de 8 bits.
- IPv6 es de 128 bits, con lo que permite muchas mas direcciones IP, está formada por ocho grupos de cuatro números hexadecimales.

**Protocolos de red**: constituyern el lenguaje utilizado para la comunicación de dos máquinas:

- **IP**: protocolo base usado en TCP, UDP e ICMP para el enrutamiento.
- **TCP**: transfer control protocol, usado para el control del formato y la integridad del dato.
- **UDP**: user datagram protocol, igual que TCP, pero los controles sufren intervención de la app.
- **ICMP**: internet control message protocol, permite la comunicación de enrutadores y host para identificar y comprobar el estado de funcionamiento de la red.

#### Puertos TCP y UDP
Los protocolos que hacen posible la comunicación de los servicios de red, asignando un puerto específico a cada uno de estos. Es necesario que los pcs conectados respeten los nº de puertos correctos para cada servicio.

IANA (internet assigned numbers authority) es la entidad que controla la lista oficial de puertos usados, voy a poner una tabla con algunos de los mas relevantes.


| **Puerto** |     **Servicio**      |
|:----------:|:---------------------:|
|     20     | FTP (puerto de datos) |
|     21     |          FTP          |
|     22     |          SSH          |
|     23     |        Telnet         |
|     25     |         SMTP          |
|     53     |          DNS          |
|     80     |         HTTP          |
|    110     |         POP3          |
|    119     |     NNTP (usenet)     |
|    139     |        Netbios        |
|    143     |         IMAP          |
|    161     |         SNMP          |
|    443     |         HTTPS         |
|    465     |         SMTPS         |
|    993     |         IMAPs         |
|    995     |         POP3S         |

Podemos encontrar la lista almacenada en **/etc/services**, el límite sería de 65535 puertos.

## 2. Configuración básica de red

Aunque los protocolos sean los misms para los distintos SO, hay distintas herramientas a usar.

#### Archivos de configuración

Todas las configuraciones quedan almacendas en archivos de textos en el directorio /etc:


| **Fichero**   | **Uso**                                                                          |
| ------------- | -------------------------------------------------------------------------------- |
| hostname      | nombre de la máquina local                                                       |
| hosts         | asigna ips a nombres                                                             |
| nsswitch.conf | indica donde debe el sistema empezar a buscar recursos. Claves, files, nis y DNS |
| resolv.conf   | donde se almacenan los DNS                                                       |

#### Configuración a través de IFCONFIG


| Parámetro                               | Descripción                                                             |
| --------------------------------------- | ----------------------------------------------------------------------- |
| interfaz down                           | desactiva la interfaz (también ifdown interfaz)                         |
| interfaz direcciónIP netmask Máscara up | asigna esa ip y máscara a la interfaz (también ifup interfaz lo activa) |
| sin argumentos                          | muestra la información de los interfaces de red                         |
| interfaz                                | muestra la info de esa interfaz en concreto                             |

#### Configuración de rutas, comando ROUTE


| Parámetro                                    | Descripción                                                                                                                                                   |
| -------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| -n                                           | muestra la tabla de rutas, el campo flags muestra el estado de la ruta                                                                                        |
| add -net Ip_red netmask máscara dev interfaz | crea una ruta para el interfaz determinado, para esa red y esa máscara                                                                                        |
| add default gw puertadeenlace                | añade una ruta estándar a esa IP. Otra forma sería "route add -net 0.0.0.0 dev Interfaz", que crea una ruta para cualquier red que no tenga ruta especificada |
| default gw puertadeenlace                    | borra la ruta estándar por la máquina puertadeenlace                                                                                                          |

Con el comando **ping** podemos comprobar el funcionamiento de la red.

## 3. Soluciones para problemas simples de red

#### Inspección de la configuración de red


| Comando      | Uso                                                                                                   |
| ------------ | ----------------------------------------------------------------------------------------------------- |
| ifconfig     | verificamos la configuración del interfaz                                                             |
| ping         | para ver si hay conectividad                                                                          |
| route        | para ver las rutas estén correctas                                                                    |
| host dominio | para hacer consultas de dns para ver si estas funcionan, podemos usar dig que es un poco mas completo |
| netstat      | Analisis de tráfico                                                                                   |
| traceroute   | muestra las rutas recorridas por un paquete hasta su destino, con -n mostramos sólo las IP            |
| ip           | con la opción a haría lo mismo que ifconfig, ifconfig empieza a estar deprecado y sustituido por IP   |

Ampliando netstat:
- -n: muestra sólo las IPs
- -t: muestra sólo TCP
- -c muestra continuamente las nuevas conexiones
- -i: muestra información de todas las redes activas y sus estadísticas
- -r muestra la tabla de rutas del sistema

#### Configuración de DNS del cliente

- Hay que verificar **/etc/nsswitch.conf** y verificar que en el apartado host esté puesto el DNS.
- Verificamos el archivo **/etc/hosts** para verificar que no tenga redirecciones erroneas.
- Verificamos el archivo **/etc/resolv.conf** para verificar que tenga dns asignado.

#### Agentes de configuación de red

- **nmtui**, es una herramienta de terminal, en modo "gráfico", para configurar cualquier parte de la interfaz que sea necesaria
- **nmcli**, herramienta linea de comando
	- nmcli connection show
	- nmcli connection delete "name"
	- nmcli connection add ..........
