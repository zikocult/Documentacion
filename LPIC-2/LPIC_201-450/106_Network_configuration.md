- [[#Configurando adaptadores físicos]]
	- [[#DHCP]]
	- [[#Reiniciando/configurando los servicios de red]]
	- [[#Configuración usando configuraciones globales]]
	- [[#Configurando usando NetworkManager]]
- [[#Configurando adaptadores wireless]]
- [[#Solventar problemas de red]]
- [[#Problemas con la resolución de nombre]]

## Configurando adaptadores físicos

Para ver la configuración tenemos varias herramientas / comando:

```bash
ifconfig
ip addr
ip route
```

### DHCP

La configuración DHCP, nos hará que automáticamente un servidor dé las opciones de configuración de red a la máquina, con lo que no haremos mucho, sólo tendremos que revisar que todo es correcto, aún y así, podemos necesitar de los siguientes comando:

```bash
# DHCP release:
sudo dhclient -r
# DHCP renew:
sudo dhclient
```

### Reiniciando/configurando los servicios de red

>La mayoría de los cambio necesitan de un reinicio de los servicio de red, para ello deberemos tener claro si usamos systemd o initd, las dos opciones son:

```bash
service network restart
systemctl restart network-manager
```

Hay varios ficheros dónde encontraremos la configuración de la red, dependiendo de la distribución:

*RHEL/CentOS*

```bash
#Estarán en la carpeta /etc/sysconfig/network-scripts
sudoedit /etc/sysconfig/network-scripts/ifcfg-enl
```

Esta sería la forma del fichero:

```
DEVICE=eno1
TYPE=Ethernet
BOOTPROTO=none
IPADDR0=192.168.0.2
PREFIX0=24
GATEWAY0=192.168.0.1
ONBOOT=yes
```

>También podemos reescribir la configuración con **`NetworkManager`**

>Yo he encontrado la configuación en otro lado, adjunto una serie de pantallazos ilustrativos.

![[Pasted image 20241111125751.png]]

>Esta es mi conexión cableada en un `Fedora`:

![[Pasted image 20241111130044.png]]

>Dentro de la carpeta mostrada, encontraremos cada una de las configuraciones de red, yo me he encontrado todos los SSID guardados en el portátil `(arch BTW)` como una configuración de red individual cada una.

>Los archivos individuales son ficheros planos, contienen inclusive los passkey (he señalado borrando la mía de ejemplo), pero sólo los puede leer y/o acceder a la carpeta *root*

![[Pasted image 20241111131334.png]]

*Debian*

```bash
sudoedit /etc/network/interfaces
```

Esta sería la forma del fichero:

```
auto eno1
iface eno1 inet static
  address 192.168.0.2
  netmask 255.255.255.0
  gateway 192.168.0.1
```

>También podemos reescribir la configuración con **`NetPlan`**

>Pongo también el pantallazo de Debian, es una interfaz de Vbox, pero se puede ver como está la configuración hecha:

![[Pasted image 20241111132133.png]]

La convención de los *nombres de las interfaces*:

- Primera parte del nombre
	- `en` = Ethernet
	- `wl` = Wireless
	- `ww` = Cellular (WWAN)
- Segunda parte del nombre
	- `o` = On-board
	- `p` = PCI card
	- `s` = Hotplug slot

### Configuración usando configuraciones globales

*Name Lookups*

- `/etc/resolv.conf`
	+ DNS Servers
	+ May be managed by NetworkManager or systemd-resolvd
- `/etc/hosts`
	+ Overrides DNS
- Network Manager
	- NM copies DNS settings from the interface config or DHCP
- systemd-resolvd
	- Viewing Settings
        + `resolvectl status`
        + `cat /etc/systemd/resolved.conf`
    - Changing settings
        + `sudoedit /etc/resolvconf/resolv.conf.d/head`
        + `nameserver 4.2.2.1`
        + `sudo systemctl restart systemd-resolved`
        
*Host Name*

- `/etc/hostname`
	- `hostname <name>` is not normally persistent
		 - Defines a machines hostname
      - To modify:
          + `hostnamectl set-hostname <name>`
      - To verify:
	         + `hostnamectl status`

### Configurando usando NetworkManager

*Viendo el estado*

```bash
nmcli device status
nmcli device show <int name>
nmcli connection show
nmcli connection show <int name>
```

*Reseteando un adaptador*

```bash
nmcli connection reload
nmcli connection down <int name>
nmcli connection up <int name>
```

*Configurando un adaptador*

```bash
nmcli connection edit <int name>
set connection.autoconnect yes
set ipv4.method manual
set ipv4.addr 192.168.0.2/24
set ipv4.dns 8.8.8.8
set ipv4.gateway 192.168.0.1
save <temporary/persistent>
quit
```

## Configurando adaptadores wireless

>Prácticamente todo lo que está aquí relacionado, ya lo tenemos visto en el apartado anterior, sólo vamos a tener que realizar la primera configuración, que es la conexión al `SSID`, el nombre de la red WiFi y la configuración del `WPA Supplicant`, una vez conectado, todo el resto es igual.

**Identificar tu adaptador WiFi**

Para saber el nombre de los adaptadores y sus estadísticas, podemos usar varios comandos:

```bash
sudo ip addr
sudo nmcli connection show
sudo nmcli device status
```

Encontramos las redes wifi:

```bash
sudo nmcli dev wifi list
```

**Conectado a la red WiFi**

Creamos la conexión:

```bash
sudo nmcli con add con-name <nombre que quieras darle> ifname <tu dispositivo sacado anteriormente> type wifi ssid <SSID obtenido de la lista>

# Ejemplo para seguir con él
sudo nmcli con add con-name Ziko ifname wlp2s0 type wifi ssid Ziko-Home
```

Seteamos la WPA2 passwords

```bash
# Le decimos que tipo de seguridad va a usar
sudo nmcli con modify Ziko wifi-sec.key-mgmt wpa-psk
# Le damos la password
sudo nmcli con modify Ziko wifi-sec.psk <password>
```

Habilitamos la conexión:

```bash
sudo nmcli con up Ziko
```

>Para el examen también piden la conexión realizarla con `iw`, voy a poner unos puntos aquí, que he sacado de es [página](https://commandmasters.com/commands/iw-linux/), seguiré con el ejemplo de mi portátil

Para *encontrar* las redes wifi alrededor, podemos usar estos comandos:

```bash
sudo iw dev wlp2s0 scan
sudo iwlist # es un paquete extra que estoy aún buscando
```

```yaml
BSS 00:11:22:33:44:55(on wlp1s0)
        TSF: 0 usec (0d, 00:00:00)
        frequency: 2412
        beacon interval: 100 TUs
        capability: ESS Privacy ShortSlotTime (0x0411)
        signal: -45.00 dBm
        last seen: 0 ms ago
        SSID: Example_Network
```

Ahora *conectamos* a nuestra red:

```bash
sudo iw dev wlp2s0 connect SSID
```

```yaml
Connected to 00:11:22:33:44:55 (on wlp2s0)
        SSID: Example_Network
        freq: 2412
        signal: -45 dBm
```

Para *cerrar* la conexión:

```bash
sudo iw dev wlp2s0 disconnect
```

```csharp
Disconnected from 00:11:22:33:44:55 (on wlp2s0)
```

*Información* de nuestra conexión actual:

```bash
sudo iw dev wlp link
```

```yaml
Connected to 00:11:22:33:44:55 (on wlp1s0)
        SSID: Example_Network
        freq: 2412
        signal: -45 dBm
```

## Solventar problemas de red

Lo primero que deberemos mirar es si el problema está dentro o fuera, empezando desde nuestro propio equipo,  el enrutamiento de nuestra red o el DNS externo.

Para ello tenemos varias herramientas que usaremos según necesidad, la mayoría de ellas sencillas de usar y de un uso ya familiar para mi.

```bash
ping
# Se debe instalar el paquete traceroute
traceroute
tracepath
#existen las version IP6
ping6
traceroute6
tracepath6
```

Voy a poner un juego de pings típicos para saber dónde nos bloqueamos:

```bash
ping <loopback>
ping ::1 # Per IP v6
ping <propia IP>
ping <otras IP dentro de tu LAN>
ping <router>
ping <dirección internet>
traceroute <URL o IP externa>
tracepath <URL o IP externa>
```

Verificar las configuraciones realizadas, para ello, seguiremos los pasos de la configuración con las siguientes herramientas (ya conocidas):

- `ip`
	- Reemplazo de `ifconfig`
	- `ip a` o `ip addr`
		- Lista las interfaces 
		- Máscaras de red
		- CIDR (Classless Inter-Domain Routing)
	- `ip l` o `ip link`
		- Nos muestra el estado actual del link de nuestra red
		- `ip -s link` nos muestra las estadísticas
	- `ip r` o `ip route`
		- Nos muestra las tablas de rutas

Para ver las conexiones que tenemos actualmente podemos realizar algunos comandos también, con las herramientas `ip`, `ss` o `netstat`

>`netstat`y `ss`comparten los mismos argumentos, así que pondré sólo los de `ss`, pero sería intercambiable entre ambos.

```bash
sudo -s link # Antes visto
sudo ss -atp # Revisa todas las sesiones
sudo ss -tp # Revisa las sesiones activas
sudo ss --route # Nos muestra las tablas de rutas
sudo ss --program # Intenta mostrar los programas usando los puertos
```

*`tcpdump`* capturará los paquetes que pasan a través de nuestra red, la información es muy extensa, así que se recomienda el siguiente uso:

```bash
sudo tcpdump -i eth0 > data.txt
tail -f ./data.txt
```

Para ver que no tenemos problemas con el *firewall*, necesitamos de la herramienta `netcat`, que nos proporcionará información de si llega o no al puerto en concreto.

```bash
sudo nc itpro.tv 80
GET
netstat -an | grep itpro.tv
```

Para *resetear* nuestra conexión y recrearla de nuevo, deberemos hacerlo mediante sysv o sysd según nuestra distro.

- `service network restart`
- `systemctl restart NetworkManager`

## Problemas con la resolución de nombre

Los problemas para la resolución de nombres, pueden ser causados por:

- Errores de página no encontrada
- Fallos en los update
- Fallo conexiones SSH/VPN
- Reloj incorrecto
- Fallo al montar NFS

Hay un par de ficheros antiguos (ya no están en todas las distros), que también hay que revisar, pues llevan dentro la configuración global del sistema si existen:

- `/etc/hosts`: Este si suele existir y su función es forzar el redireccionamiento a una IP, es decir, sobreescribe a cualquier DNS, si hay alguna entrada que choca, podría ser el problema.
- `/etc/resolv.conf`: configuración de DNS externos dentro de la máquina, hay que revisar que estén correctos, pues sobreescribirán cualquier configuración de red
	- También chequea el órden de resolución, debería verse como `order hosts,bind,nis`

Si vemos que el problema es *externo*, tenemos la herramienta `nslookup` y `dig`

Realizando un test simple:
```bash
nslookup www.google.com
dig www.google.com
```

Realizando un test cambiando el DNS que tenemos:
```bash
nslookup www.google.com 4.2.2.1
dig @4.2.2.1 www.google.com
# Si añadimos la opción +trace a dig obtenemos además una traza
dig @4.2.2.1 www.google.com +trace
```

Otras herramientas de utilidad pueden ser:

- `systemd-resolved`
- `dnsmasq`
- `openvpn`