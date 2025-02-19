
- [[#Instalando BINDS DNS Server]]
- [[#Creando zonas Forward Lookup]]
- [[#Creando zonas Reverse Lookup]]
- [[#Solucionando problemas con el DNS]]
- [[#Soporte a los servidores de mail con DNS]]
- [[#Securizando el DNS con DNSSEC]]
- [[#Implementando Transaction Signatures (TSIG)]]

## Instalando BINDS DNS Server

BIND -> **B**erkeley **I**nternet **N**ame **D**omain

Es uno de los standares mas antiguos como DNS server, creado en 1980 y sigue estando actualmente soportado por la **ISC** (Internet Systems Consortium).

BINDS9 es el paquete por defecto, pero puede variar el nombre según la distro, no está instalado por defecto y viene empaquetado con otras herramientas para su gestión.

>TIP: `/etc/hosts` es también usado de forma muy común.

Instalación del paquete `bind o bind9`, recomendado instalar con `bind-utils`, que son herramientas de mantenimiento del sistema:

```bash
sudo apt install bind9 bind9-utils
sudo dnf install bind bind-utils
```

`bind-utils` lleva las siguientes herramientas con él:

- `dnssec-*`
- `rndc`
- `named-checkconf`
- `named-checkzone`

Otros paquetes de utilidad son `bind-dnsutils`, que son herramientas para el cliente, que incluye las siguientes herramientas:
- `dig`
- `nslookup`
- `nsupdate`

Las tres cosas a realizar después de la instalación son:

1. Iniciar el servicio (puede ser bind o named según la distro)
	- Configuramos el servicio, por defecto tenemos estos tres archivos:
		- `/etc/bind/named.conf`
			- Fichero principal, no se configura directamente, si no que escucha a los otros dos
		- `/etc/bind/named.conf.options`
			- Fichero donde pondremos la configuración de nuestro servidor.
		- `/etc/bind/named.conf.local`
			- Aquí configuraremos las opciones de nuestras zonas (mas adelante entraremos en detalle)
	- Por defecto sólo escuchará a localhost
2. Encontrar los puertos que estará usando y/o definirlos
	- TCP/UDP puerto 53 por defecto
	- Debemos checkear conflictos con otros servicios
		- `dnsmasq`
		- `systemd-resolved`
		- `sudoedit /etc/bind/named.conf.optios`

```bash
options {
	listen-on port 53 { 127.0.0.1; 10.0.222.52; };
	listen-on-v6 port 53 { ::1; };
}
```
3. Configuración lista de control de acceso (ACL)
	- Define quien se puede conectar
	- Define que acciones se puede tomar
```bash
acl "trusted-hosts" {
	localhost;
	localnets;
	10.0.222.51;
	10.0.0.0/16;
};
options {
	recursion yes;
	allow-recursion { trusted-hosts; };
	allow-query { trusted-hosts; };
	allow-transfer { none; };
};
```
4. Opciones varias:
	- BIND suporta muchas configuraciones especiales en su configuración:
	- DNS-SEC
	- Forwarders
		- Envia consultas a otros servidores DNS
	- Configuración
```bash
options {
	forwarders  {
		8.8.8.8;
		8.8.4.4;
	};
};
```

**Aquí tenemos un ejemplo del fichero de configuración que he dejado en mi servidor**

![[Pasted image 20241118195106.png]]

En este punto ya podemos iniciar el servicio, puede llamarse bind, bind9 o named, yo en mi caso como lo he configurado en Debian se llamará named.service:

```bash
sudo systemctl enable --now named.service
```

Y por último paso, habilitamos los puertos en el firewall, tenemos dos opciones:

```bash
sudo ufw allow Bind9
sudo ufw allow 53 commend "Bind DNS Server"
```

## Creando zonas Forward Lookup

Estas son las zonas que realmente convierten los nombres a IPs y tienen estas características:
- Contienen los registros DNS para un dominio.
- Hace que el DNS sea autorizativo para el dominio.
- Puede ser público o privado
- Los públicos requieren el uso de un registro.

Se deberá crear un fichero por cada zona que queramos añadir al DNS, el nombre no tiene ningún requerimento, pero se recomienda que sea un nombre indicativo, dónde estarán ubicados tampoco, pues después los linkaremos en el fichero `/etc/bind/named.conf.local`

Este fichero requiere de tres campos obligatorios y un cuarto informativo:
1. TTL (Time to live)
	- Define el tiempo por defecto que el registro será permitido en cache
	- El estandard son 7 días
	- Se define en segundos, aunque podemos agregar un carácter para indicar otro sistema de tiempo
	- `$TTL 604800` (7 días en segundos)
2. SOA (Start of authority)
	- Contiene la información administrativa de la zona:
```bash
@	IN	SOA	dns.ziko.local.home. admin.ziko.local.home. (
		1;		Serial Number
		86400;	DNS Secondary Refresh
		7200;	DNS Secondary Retry
		57600;	DNS Secondary Expire
		3600);	Domain Cache TTL
```
3. NS (Name server records)
	- Define la zona autorizativa del servidor DNS

```bash
@	IN	NS	dns.ziko.local.home.
```

4. Host records
	- Aquí definiremos los recursos del dominio.
	- Mas adelante veremos algunos de los registros en mas detalle
```bash
web			IN	A		192.168.1.57
www			IN	CNAME	web.ziko.local.home.
mail		IN	A		192.168.1.57
smtp		IN	A		192.168.1.57
dns			IN	A		192.168.1.57
atenea		IN	A		192.168.1.13
@			IN	MX		10 mail.ziko.local.home.
@			IN	MX		10 smtp.ziko.local.home.
@			IN	TXT		"v=spf1 mx -all"
_sip._tls	IN	SRV		10 100 443 mail.ziko.local.home.	
```

Este sería el ejemplo completo del fichero de la zona (nótese los include, así no se podría activar, pues no lo leería, es parte de la firma digital que llegaremos con DNSSEC):

![[Pasted image 20241118201506.png]]

**Activando la zona**

Las zonas se definen en `/etc/bind/named.conf.local`, simplemente añadiendo el tipo (master or slave) y el fichero de configuración anteriormente realizado:

![[Pasted image 20241118201815.png]]

Ya podemos reiniciar BIND, pero vamos a realizar un par de apuntes:
- Cuando añadamos nuevas zonas ejecutar
	- `sudo rndc reconfig`
- Cuando modificamos una zona
	- `sudo rndc reload ziko.local.home`
- Reinicio completo
	- `sudo systemctl restart named.service`

## Creando zonas Reverse Lookup

Son zonas que hacen lo contrario a lo normal, es decir, convierte la IP a un nombre.

El procedimiento es exactamente igual que el anterior, incluso el archivo, que sólo cambiará la parte de los hosts, el punto 4 del anterior punto.

Los registros en este caso, serán todos y sin excepción todos PTR y sólo será necesario agregar el octeto de red que se vaya a consultar, por ejemplo en 192.168.1.0/24, si añado un 57, me estoy refiriendo a 192.168.1.57, muestro directamente el ejemplo.

La recomendación del nombre, es invertir la identificación de red y añadir *in-addr.arpa.dns*, siguendo el ejemplo anterior quedaría como **1.168.192.in-addr.arpa.dns**

![[Pasted image 20241118202536.png]]

La activación sigue también los mismos pasos, de hecho, lo podemos ver en el pantallazo que he insertado de `/etc/bind/named.conf.local`.

## Solucionando problemas con el DNS

Las tres formas típicas de errores en el DNS suelen ser:

1. Escritura errónea en los ficheros.
	- Siempre se debe verificar el tipado, pues sólo un fallo provoca que el servicio no levante.
	- Con los siguiente comando, encontraremos errores de sintaxis en las zonas.

```bash
named-checkconf # No necesita argumentos
named-checkzone <zona> <fichero>
```

2. Diferentes recursos luchando por el mismo puertos
	- Podemos usar los siguientes comandos para intentar encontrar errores en tema comunicaciones
	
```bash
sudo journalctl -u named.service
sudo ss -natp
```

3. Se puede corromper la base de datos.
	- BINDS mantiene la base de datos en RAM
	- Podemos volvar la ram con el comando que pondré mas abajo
	- Si el comando falla, es que la RAM está corrompida y deberemos reiniciar.
	- Podemos usar una de las siguientes opciones para el volcado de la BBDD

```bash
sudo rndc dumpdb -zones
sudo rndc dumpdb -cache
# Para ver la base de datos haremos:
less /var/cache/bind/named_dump.db
```

>Una opción si no vemos nada sería reiniciar el servicio, para ello tenemos los siguientes comandos:

```bash
# Cuando añadimos una zona
sudo rndc reconfig
# Cuando modificamos una zona
sudo rndc reload ziko.local.home
# Full restart
sudo systemctl restart named.service
```

También tenemos un par de herramientas muy útiles para ver la respuesta del DNS:

```bash
dig www.google.com
nslookup www.google.com

# Si queremos forzar la lectura con un DNS en concreto:
# Pongo el ejemplo del DNS 192.168.1.57
dig @192.168.1.57 ziko.local.home
nslookup ziko.local.home 192.168.1.57
```

## Soporte a los servidores de mail con DNS

Los servidores de mail tienen unos requerimientos especiales, se configuran en las zonas, estos son los tipos de registro que vamos a usar.
	- **MX** - Mail Exchanger
	- **SPF** - Sender Policy Framework
	- **SRV** - Service Locator

**Mail Exchanger** (MX record)
- Usando para localizar un servidor **SMTP**
- Requerido para el funcionamiento óptimo del servidor de emails
- Ejemplo: user@ziko.local.home
	- El lookup se realiza contra ziko.local.home
	- El registro MX identifica el servidor de email
- Fomato

```bash
@ 3600 IN MX 10 mail.ziko.local.home
<Host> <TTL> <Class> <Type> <Priority> <Server>
```

**Sender Policy Framework** (SPF record)
- Usado para identificar los servidores autorizados a enviar emails desde un domino
- No es requerido
- Afecta a las entregas (spam rating)
- Enbebido en un registro TXT

```bash
@ 3600 IN TXT "v=spf1 mx -all"
<Host> <TTL> <Class> <Type> <SPF values>
```

- Los valores de *SPF* son:
	- `v` - Version
	- `mx` - Permite a servidores con registro mx el envío
		- Se especifican los servidores mx como:
			- `mx` - Usa las direcciones desde los registros MX
			- `a` - usa una direccion desde un registro A
			- `ip4` - Usa una dirección IPv4 o rango CIDR
			- `ip6` - Usa una dirección IPv6 o rango
			- `include` - usa registros desde un dominio externo
	- `all` - Estricto
	- `?all` - Neutral
	- `~all` - Soft fail
	- Ejemplo:
		- `v=spf1 mx a:smtp.lab.itpro.tv ip4:10.0.222.51 10.0.0.0/24 ip6:2001:1234::4321:2 include:mail.office365.com mail.sendgrid.com ~all`

**Service locator records** (SRV)
- Permite la localización de cualquier servicio especial dentro del servidor de mail.
- Provee mas información que un registro normal
	- Protocolo: TLS, LDAP, SSH, etc
	- Prioridad: Define el servidor preferido, a menor número, mayor prioridad
	- Peso: Permite desempatar en caso de prioridades iguales
	- Número de puerto: TCP/UDP asignados al servicio

```bash
_sip._tls 3600 IN SRV 100 1 443 ziko.local.home.
<Service/Protocol> <TTL> <Class> <Type> <Priority> <Weight> <Port> <Host>
```

Ejemplo para añadir un servidor de chat:

```bash
_sip._tls IN SRV 10 30 443 mail.ziko.local.home.
_sip._tls IN SRV 10 70 443 mail.ziko.local.home.
# Los dos servidores tienen la misma prioridad (10), pero le he dado mas peso al segundo, con lo que la carga quedará en 30-70% mientras ambos estén disponibles.
```

![[Pasted image 20241122175044.png]]

## Securizando el DNS con DNSSEC

- El protocolo DNS no es seguro, pues:
	- Los registros son transmitidos en texto plano
	- Los servidores confian en otros DNS por defecto
	- La caché tiene prioridad sobre la realidad
- DNSSEC está diseñado para combatir DNS poisoning attacks
- Requiere de una firma digital para validar la respuesta DNS
	- Proveé autentificación y integridad

DNSSEC trabaja de forma que cada zona tiene un par de llaves, estas llaves son:
- *Zone Signing Key* (ZSK)
	- Firma registros individuales o registros seteados en una zona
- *Key Signing Key* (KSK)
	- Firmal el SZK
	- Previene ataques man-in-the-middle que reemplaza el ZSK
	- Una copia del KSK es almacenada en el registro

**Pasos a seguir para configurar**:

**Paso 1**: Habilitar DNSSEC en BIND

> **WARNING**: Mucho cuidado con esto, pondré las 3 opciones, pero *dnssec-enable y dnssec-lookaside*, están *obsoletas y removidas* desde la versión 9 de BIND, podemos encontrar la info [aquí](https://kb.isc.org/docs/changes-to-be-aware-of-when-moving-from-bind-916-to-918), a mi me dio mucho dolor de cabeza, pues no levanta el servicio y no cuenta el por qué con claridad con los logs, simplemente no poner estas dos opciones, sólo la opción *dnssec-validation yes* y funcionará perfectamente.

- Normalmente no está habilitado por defecto
- Hay que añadir al fichero */etc/bind/named.conf.options* las siguientes opciones:
	- `dnssec-enable yes;`
	- `dnssec-validation yes;`
	- `dnssec-lookaside auto;` 
- Reiniciamos el servicio como siempre `rndc reconfig`

**Paso 2:** Crear el ZSK para una zona
- Nos metemos donde tengamos nuestros ficheros de zonas
- Una vez allí ejecutamos:
	- `sudo dnssec-keygen -a ECDSA256 ziko.local.home`
> *NOTA*: `ECDSA256` es un alias para `ECDSAP256SHA256`

**Paso 3:** Crear el KSK para una zona
- En este caso ejecutaremos un comando muy similar, aún en la carpeta donde tenemos las zonas.
	- `sudo dnssec-keygen -f KSK -a ECDSA256 -n ZONE ziko.local.home`

**Paso 4:** Añadimos la claves a las zonas
- Para ello entraremos en nuestros ficheros de configuración de la zona y añadiremos justo después de la TTL los siguientes include, que serán los nombres de las llaves generadas.
	- `$INCLUDE "Kziko.local.home.+013+28587.key"`
	- `$INCLUDE "Kziko.local.home.+013+54730.key"`

> También cuidado aquí, pues ahora que hemos incluido esto, no cargará la zona correctamente, así que no recarguemos la zona o se detendrá BIND al completo, todo el servicio, sigamos hasta firmar e incluir en el fichero named.conf.local

**Paso 5:** Firmamos la zona con las llaves
- Usamos dnssec-signzone para firmar la zona quedando algo como:
	- `dnssec-signzone -o <zone name> -N <serial format> -k <KSK> <zone filename> <ZSK>`
	- `-t` will show statistics
	- `sudo dnssec-signzone -o ziko.local.home -N INCREMENT -t ziko.local.home.dns`
	- Un nuevo fichero con el mimsmo nombre que el anterior pero acabado en signed se generará.

**Paso 6:** Activamos la zona
- Cambiamos la configuración del fichero */etc/bint/named.conf.local*
	- Simplemente tenemos que añadir el nuevo nombre del fichero *signed*ç

**Paso 7:** Subirl el hash KSK al registro
- Normalmente este paso es automático, pero se debe revisar que se ha creado un fichero tal que:
	- `/etc/bind/dsset-<zone>`
	- `/etc/bind/dsset-ziko.local.home.`
	- En mi caso, contiene esto:
		- `ziko.local.home.	IN DS 54730 13 2 393B56D500A5F0C65C2EA8CEE7495C7E34AA42B85A8F648FE600B488 7080FCC8`

**Paso 8:** Reiniciamos la zona y si todo ha ido bien, ya lo tenemos.


## Implementando Transaction Signatures (TSIG)

Diseñado para securizar las comunicaciones entre servidores, en el momento en que se hagan *queries recursivas* i en la *transferencia de zonas.*

Sus funciones son:
- Firmar digitalmente los mensajes con un hash de una vía
- Provee identificación y integridad

**Paso 1:** Generar una llave para el servidor primario
- Simplemente ejecutaremos 
	- `tsig-keygen <key-name>`
- Pero como esto no lo dejará almacenado en ningún lugar, usaremos una pipe con tee, apuntando directamente a */etc/bind/named.conf.local*

```bash
tsig-keygen ns1-ns2. | sudo tee -a /etc/bind/named.conf.local
```

Eso nos creará una entrada al final del fichero tal que:

```bash
key "ns1-ns2." {
	algorithm hmac-sha256;
	secret "CX9JVveT4uv77AeazGz1PSJnL0VCr1fqDPizkMPrrQM=";
};
```

**Paso 2:** Copiar la llave a los otros servidores
- Debe ser exactamente la misma llave y hash en todos los servidores

**Paso 3:** Habilitar TSIG para cada uno de los servidores

Para eso volvermos a editar el fichero */etc/bind/named.conf.local* y añadiremos una linea similar a la que muestro para cada servidor al que queramos dar acceso (la IP remota):
- `server 192.168.1.58 { keys { ns1-ns2.; };};`

**Paso 4:** Reinicio del servidor, pero en este caso, deberemos reiniciar también *tsig*, con lo que serían dos comandos:

```bash
sudo rndc reconfig
sudo rndc tsig-list
```
