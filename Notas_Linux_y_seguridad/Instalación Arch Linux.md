
Iniciamos con la **configuración para nuestro teclado**, en mi caso uso el teclado español (cuidado, pues esta configuración sólo es temporal, al reiniciar desaparecerá, mas adelante la dejaremos permanente)

```bash
loadkeys es
```

Este paso sólo lo usaremos en caso de necesitar WiFi, si tenemos el ordenador conectado por cable, probablemente no sea necesario, para comprobar que todo está OK, realizamos un ping.

```bash
ping -c 4 google.es
```

Para la config seguiremos con los siguientes pasos:

```bash
// para ver las conexiones y conectarse
ip link
ip link <conexion> set up

// para ver las wifi disponibles
iwlist <wlanx> scan
iwlist <wlanx> ssid <nombre>

// si la conexión tiene password previamente debemos hacer:
wpa_passphrase <SSID> <PW> >> /etc/ficheroquequieras
wpa_supplicant -B -i <wlanx> -D wext -c "fichero anterior"
```

**PARTICIONES**

Dos opciones a usar, pero para ambas necesitarás saber el nombre del disco, para ello usaremos

```bash
lsblk
```

~~~
Recordatorio: En sistemas EFI no Virtualizados deberemos crear una partición /boot/efi para poder carcar el sistema de arranque
~~~

- FDISK:
	- Opciones:
		- p: particiones info
		- o: tabla nueva MBR
		- n: nueva partición +xxG para indicar el tamaño
		- t: tipo de partición
		- a: para hacer partición booteable
		- w: escribir tabla

```bash
fdisk -l
fdisk /dev/sdx
```

- CFDISK
	- Mucho mas intuitivo, igualmente se lanza sabiendo el número de la partición con lsblk.

**FORMATEO**

Una vez creadas, las formatearemos según necesidad (podemos seguir recurriendo a lsblk para ver)

- Swap

```bash
mkswap /deb/sdx
swapon
```

- Propias de linux
```bash
mkfs.ext4 /dev/sdx
```
- Boot 
	- Este caso es especial, pues sólo será necesario en caso de sistema UEFI, no virtualizado, pues necesitamos crear una partición /boot/efi (comentado mas arriba), dicha partición deberá ser FAT32.

```bash
mkfs.fat -F32 /dev/sdx
```

**PREMONTAJE de las particiones**

La forma de realizar el montaje no varia, sería senzillo como:

```bash
mount /dev/sdx /dondetoque
```

Pero en este caso, la instalación ya está usando la raíz del sistema de forma temporal para poder realizar estos cambios, con lo que necesitaremos cargar todo en /mnt, siguiendo el siguiente ejemplo para la partición raíz y la home de usuario (cargaremos cualquier partición necesaria ya en este punto, incluida la boot)

```bash
mount /dev/sdx /mnt
mount /dev/sdx /mnt/home
mount /dev/sdx /mnt/boot/efi
```

**PACSTRAP**

Con este comando iniciaremos la instalación de los primeros paquetes necesarios para seguir con la instalación, se recomienda instalar al menos lo siguiente:

```bash
pacstrap /mnt base linux linux-firmware vi grub networkmanager dhcpcd netctl wpa_supplicant dialog
```

**GENSTAB**

Para la creación de fstab, cuidado, pues sólo hará las particiones que hayamos montado en este momento, si faltara alguna, deberíamos posteriormente nosotros añadirla a fstab

```bash
genfstab /mnt >> /mnt/etc/fstab
```

**ARCH-CHROOT**

Simplemente tecleamos lo siguiente

```bsh
arch-chroot /mnt
```

Ya con esto entramos en el sistema para iniciar las configuraciones básicas, que vendrían a ser:

```bash
ln -sf /usr/share/zoneinfo/Europe/Madrid /etc/localtime
hwclock --systohc
echo "LANG=es_ES.UTF8" > /etc/locale.conf
echo "KEYMAP=es" > /etc/vconsole.conf
echo "nombre máquina" > /etc/hostname
echo "127.0.0.1 localhost" > etc/hosts
```

Con esto ya podemos generar los locales, editando el fichero (yo estoy usando vi, pero se puede usar el que se convenga como nano por ejemplo)

```bash
vi /etc/locale_gen (descomentar ES_es)
locale-gen
```

**USUARIOS**

```bash
// password para root
passwd
// usuario nominal
useradd -m -g users -G wheel -s /bin/bash <usuario>
passwd <usuario>
// descomentar la linea 108 mostrada (puede cambiar el número de linea)
vi /etc/sudoers
 107   │ ## Uncomment to allow members of group wheel to execute any command
 108   │ %wheel ALL=(ALL:ALL) ALL
```

**GRUB NO EFI** --> entornos virtualizados irán así

Sin EFI no tiene problema alguno, simplemente seguir con los siguientes comandos.

```bash
grub-install  /dev/sdx
grub-mkconfig -o /boot/grub/grub.cfg
mkinitcpio -P
shutdown -r now
```

**GRUB  EFI**

Debemos seguir cada uno de los siguientes pasos de forma detallada:

```bash
pacman -S grub efibootmgr
mkdir /boot/efi
mount /dev/sdx (particion fat32 creada antes) /boot/efi
grub-install --target=x86_64-efi --bootloader-id=GRUB --efi-directory=/boot/efi
grub-mkconfig -o /boot/grub/grub.cfg
mkdir /boot/efi/EFI/BOOT
cp /boot/efi/EFI/GRUB/grubx64.efi /boot/efi/EFI/BOOT/BOOTx64.EFI
vi /boot/efi/startup.nsh
   1   │ bcf boot 1 fs0:\EFI\GRUB\grubx64.efi
   2   │ "My GRUB boot loader"
   3   │ exit
```

**1º INICIO DEL SISTEMA **

En este caso, sólo arrancaremos algún sistema e instalaremos el entorno gráfico básico.

Importante iniciar y dejar iniciado el Networkmanager

```bash
systemctl start NetworkManager.service
systemctl enable NetworkManager.service
```

Para dejar la configuración de red marcada:

```bash
ip link
ip link set (dispositivo)
nmcli dev wifi connect <SSID> password (esto sólo si tienes WiFi)
```

Instalamos un entorno gráfico (yo siempre instalo plasma, pero a gusto de cada uno) y lo dejamos activado para el siguiente inicio.

```bash
pacman -S xorg-server xorg-xinit sddm xf86-video-X plasma
systemclt enable sddm.service
```

Si en vez de plasma quisieramos otro entorno, ssdem se cambiaria por lo siguiente:

- gdm o gnome-session si instalamos gnome
- lightdm para cualquier sistema (inclusive gnome y plasma), es el de por defecto de XFC

En el caso de xf86-video tenemos los siguientes paquetes:

- xf86-video-noveau (NVIDIA)
- xf86-video-intel
- xf86-video-ati
- xf86-video-vesa (resto)

Instalación audio (en este punto estoy usando pulse, pero se puede cambiar por piperwire y revisar que no lo instale plasma por defecto, si fuera así, podemos obviar este paso)

```bash
sudo pacman -S pulseaudio pulseaudio-alas pavucontrol
```