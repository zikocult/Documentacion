
## 1 - Identificar y editar configuraciones de hardware

1.  **Activación de dispositivos**
	- El hardware básico se configura desde la BIOS 
&nbsp;
2. **Inspección de dispositivos**
	- Comandos
		- ==lpsci==: muestra todo lo conectado al bus PCI
			- -s id: Muestra la información de ese dispositivo
			- -v: Muestra todos los detalles
		- ==lsusb==: muestra los dispositivos conectados por USB
			- -d id: muestra la información de ese dispositivo
			- v: muestra detalles
		- ==lsmod==: mustra los módulos (drivers) cargados actualmente
		- 
	- **Los datos del hardware** están almacenados en /proc y /sys, meditante cat podemos mostrarlos.
3. **Tipos de dispositivo:**
	- ==ColdPlug==: Es necesario apagar el pc para conectar el dispositivo, como tarjetas PCI, dispositivos IDE, etc.
	- ==HotPlug==: permite conectar/desconectar en caliente, ej: usb. Cuando se conecta automáticamente se activa un evento Udev que actualiza los dispositivos **/dev**
4. **Dispositivos de almacenamiento**
	- Cualquier dispositivo de almacenamiento se identifica en un archivo dentro de /dev. El nombre del archivo depende del tipo de dispositivo (SATA, IDE.. ) y de las particiones.

| Tipo | Criterio nombre                               | Ejemplo                                                                             |
| ---- | --------------------------------------------- | ----------------------------------------------------------------------------------- |
| IDE  | Canal IDE usado, Master / Slave y particiones | /dev/hda1: partición 1 del Master<br>/dev/hda2: 2º partición del primer canal slave |
| SATA | Por la BIOS y por particiones                 | /dev/sda1: partición 1 del disco 1<br>/dev/sdb2: partición 2 del disco 2            |
| SSD  | Por la BIOS y por particiones                 | /dev/sdc: como si fuese sata                                                        |

&nbsp;
		
## 2 - Inicio (boot) del sistema:
 Es posible pasarle parámetros al kernel en el momento del inicio para especificar datos como memoria, dispositivos, etc.
 &nbsp;
 **Cargador de boot (Bootloader)**:
Los principales son Grub y Lilo, a estos también se les puede añadir parámetros como:

| Parámetro | Descripción                                           | Ejemplo          |
| --------- | ----------------------------------------------------- | ---------------- |
| acpi      | Conecta/desconecta el soporte ACPI                    | acpi = off       |
| init      | Define otro programa en lugar de /sbin/init            | init = /bin/bash |
| mem       | Define cuanta ram estará disponible                   | mem=512          |
| maxcpus   | Nº máximo de núcleos                                  | maxcpus=2        |
| quiet     | No muestra la mayoría de los mensajes de inicio       | quiet            |
| vga       | modo de vídeo                                         | vga=773          |
| root      | Define la partición raíz diferente a la de bootloader | root=/dev/sda3   |
| ro o rw   | realiza el montaje en sólo lectura                    | ro               |

## 3 - Cambiar runlevels, apagar y reiniciar el sistema

El runlevel es el nivel de ejecución del sistema, el programa **/sbin/init** que es invocado tras el bootloader identifica el nive de ejecución metido como parámetro en la carga del kernel o mirándolo en **/etc/inittab**. 

Luego carga los programas, scripts y servicios indicados en ese archivo. La mayor parte de los scripts ejecutados por init se guardan en **/etc/init.d** pero en otras distros es en **/etc/rc.d**

**Los niveles de ejecución**
Se enumeran del 0 al 6 y tienen el formato:
- **id**: nombre de hasta 4 caracteres para identificar la entrada de inittab
- **runlevels**: es la lista de runlevels que se ejecutarán
- **acción**: el tipo de acción:
	- sysinit: inicio del sistema
	- wait: se ejecuta y espera su finalización
	- ctrlaltdel: se ejecuta cuando se pulsa control+alt+del o se reciba la señal SIGINIT
- **proceso**: comando que se activará

**Numeración de los runlevels:**
- 0: apagar el sistema
- 1: usuario único, sin red o servicios
- 2: multiusuario, estándar en la mayoría de distros
- 3: multiusuario, estándar en otras muchas distros
- 4: No se usa
- 5: No se usa
- 6: reinicio del sistema

Para cambiar entre runlevels se usa ==telinit nº_runlevel== y para ver el runlevel actual usamos el comando ==runlevel==

**Apagar y reiniciar:**

Comando ==shutdown==

**El horario puede ser:**
- hh:mm hora de ejecución
- +m minutos para la ejecución
- now o +0 inmediato

**Opciones:**
- -a: usar el archivo de permiso /etc/shutdown.allow
- -r: reiniciar la máquina 
- -h: apagar el pc
- -t segundos: tiempo de espera antes de que se ejecute la acción

El mensaje será enviado a todos los usuarios.

Para prevenir que cualquiera pueda reiniciar la máquina con ctrl+alt+supr la opción -a en el comando shutdown de la líndea ctrlaltdel de /etc/inittab
