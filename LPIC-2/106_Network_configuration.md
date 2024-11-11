- [[#Configurando adaptadores físicos]]
	- [[#DHCP]]
	- [[#Reiniciando/configurando los servicios de red]]

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

>También podemos reescribir la configuración con `NetworkManager`
>Jo he trobat a Fedora la config a un altre lloc, adjunto pantallasso

![[Pasted image 20241111125751.png]]

![[Pasted image 20241111130044.png]]

>Dentro de la carpeta mostrada, encontraremos cada una de las configuraciones de red, yo me he encontrado todos los SSID guardados en el portátil `(arch BTW)` como una configuración de red individual cada una.
>Los archivos individuales son ficheros planos, contienen inclusive los passkey, pero sólo los puede leer *root*

*Debian*

```bash
sudoedit /etc/network/interfaces
```

>También podemos reescribir la configuración con `NetPlan`

La convención de los *nombres de las interfaces*:

- Primera parte del nombre
	- `en` = Ethernet
	- `wl` = Wireless
	- `ww` = Cellular (WWAN)
- Segunda parte del nombre
	- `o` = On-board
	- `p` = PCI card
	- `s` = Hotplug slot

