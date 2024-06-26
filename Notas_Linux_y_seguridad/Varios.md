
- [Uso de pacman](#Pacman)
    - [PKGBUILD](#PKGBUILD)
    - [Reflector](#Reflector)
- [Limpieza diferentes extensiones o carpetas en un directorio](#Limpieza)
- [Monitorización de un sistema completo](#Monitorización)

---
# Pacman:

Toda la info mas extensa la podemos encontrar en [Archlinux.org](https://archlinux.org/pacman/pacman.8.html)

***Nota importante*** PARU y YAY usan el mismo tipo de notación para los parámetros, con alguna ligera diferencia.

- Instalar un paquete

```bash
pacman -S <paquete>
```

- Remover un paquete

```bash
pacman -R <paquete>
```

- Buscar un paquete

```bash
pacman -Ss <paquete>
```

- Purgar un paquete

```bash
pacman -Rns <paquete>
```

- Query options

```bash
pacman -Q
```

- Actualizar el sistema

```bash
pacman -Syyu
```

- Paquetes huerfanos

```bash
pacman -Qdtq
```

- Para remover los paquetes huerfanos, usaremos una combinación de -R y el anterior comando

```bash
pacman -R $(pacman -Qtdq)
```


### PKGBUILD

Para descomprimir debemos realizar el siguiente comando: 

```bash
makepkg -si
```

> Este proceso ejecutará la órden ```pacman -U``` automáticamente 
  
### Reflector

Para el uso de reflector y hacer que pacman esté mas optimizado:

```bash
sudo reflector --latest 20 --protocol https --sort rate --save /etc/pacman.d/mirrorlist    
```

---

# Limpieza


```bash
#!/bin/sh

find $PWD -iname '*.out' -print 2>/dev/null -exec rm -f {} \;
find $PWD -iname '*.swp' -print 2>/dev/null -exec rm -f {} \;
find $PWD -iname '*.gch' -print 2>/dev/null -exec rm -f {} \;
find $PWD -iname '.DS_Store' -print 2>/dev/null -exec rm -f {} \;
```

---

# Monitorización


```bash
#!/bin/bash

ARQUITECTURA=$(uname -a)

VIRTPROC=$(cat /proc/cpuinfo | grep "processor" | wc -l)

PHYSPROC=$(cat /proc/cpuinfo | grep "physical id" | wc -l)

MEM_USED=$(free --mega | awk '$1 == "Mem:" {print $3}')
MEM_TOTAL=$(free --mega | grep "Mem:" | awk '{Mem = $2} END {printf("%iMb", Mem)}')
MEM_PCT=$(free --mega | awk '$1 == "Mem:" {printf("(%.2f%%)\n", $3/$2*100)}')

HD_USED=$(df -m | grep -v "tmpfs" | awk '{use += $3} END {printf("%.2f", use / 1024)}')
HD_TOTAL=$(df -m | grep -v "tmpfs" | awk '{use += $2} END {printf("%.2fGb", use / 1024)}')
HD_PCT=$(df -m | grep -v "tmpfs" | awk '{use += $3} {total +=$2} END {printf("%.2f%%", (use / total)*100)}')

CPU_USE=$(ps -eo "%C" | awk '{cpu+=$1} END {printf("%.1f%%\n", cpu)}')

LAST_BOOT=$(who -b | awk '{print $3 " " $4}')

LVM_USE=$(if [ $(lsblk | grep "LVM" | wc -l) -gt 0 ]; then echo yes; else echo no; fi)

TCP_ESTAB=$(ss -ta | grep "ESTAB" | wc -l)

USER_LOGGED=$(users | wc -w)

IP=$(hostname -I | awk '{print $1}')

MAC=$(ip link | grep "link/ether" | awk '{mac = $2} END {printf("(%s)", mac)}')

SUDO_CMD=$(journalctl -q _COMM=sudo | grep COMMAND | wc -l)

wall "
                #Architecture: $ARQUITECTURA
                #CPU physical: $PHYSPROC
                #vCPU: $VIRTPROC
                #Memory Usage: $MEM_USED/$MEM_TOTAL $MEM_PCT
                #Disk Usage: $HD_USED/$HD_TOTAL ($HD_PCT)
                #CPU Load: $CPU_USE
                #Last Boot: $LAST_BOOT
                #LVM Use: $LVM_USE
                #Connections TCP: $TCP_ESTAB ESTABLISHED
                #User log: $USER_LOGGED
                #Network IP $IP $MAC
                #Sudo: $SUDO_CMD cmd"

```