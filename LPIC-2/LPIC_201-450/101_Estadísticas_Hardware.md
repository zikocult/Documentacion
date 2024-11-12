- [[#Introducción]]
	- [[#SysStat]]
	- [[#Básicas]]
- [[#CPU]]
	- [[#top]]
	- [[#Procesos]]
		- [[#ps]]
		- [[#pstree]]
		- [[#pmap]]
		- [[#Procesos congelados]]
	- [[#lsof]]
	- [[#iostat]]
- [[#Memoria]]
	- [[#free]]
	- [[#vmstat]]
	- [[#Puntos clave de la memoria]]
- [[#Disco]]
	- [[#iotop]]
	- [[#iostat]]
	- [[#Métricas SAR]]
- [[#Redes]]
	- [[#ntop / ntopng]]
	- [[#iftop]]
	- [[#mtr]]
	- [[#Otras herramientas]]

## Introducción

Con el uso de las herramientas que iremos viendo, podremos analizar las necesidades de hardware, así como los cuello de botella que encontremos en alguno de los elementos, por defecto, revisaremos los siguientes 4 tipos:

- CPU
- Memoria
- Disco IO
- Red

Tenemos algunas herramientas básicas, que iremos comentando, pero voy a agregar aquí todo el bloque del paquete **sysstat** y comentaré un poco de dentro de este paquete el comando **sar**, pues alberga datos para cada uno de los 4 puntos antes mencionados.

### SysStat

Encontraremos la documentación en [SysStat Github](https://github.com/sysstat/sysstat), dónde podremos ver algunas opciones, así como la instalación para las principales distribuciones, yo lo he podido instalar sin problemas con apt, dnf y pacman.

Una vez instalado, debemos ir al fichero **/etc/sysstat/sysstat** y pasar el parámetro de habilitado a true, esto generará un cron en **/etc/cron.d/sysstat,** que podremos modificar según las necesidades, por defecto ejecutará una vez cada 10 minutos y guardará un log en **/var/log/sysstat**.

Los logs están encriptados en PGP, con lo que no podremos usarlos mediante un cat, si no que deberemos ejecutar la aplicación SAR, tal como comentaremos a continuación. Los logs tienen la siguiente forma: SAX, dónde X es el día del mes que queremos revisar, una vez al mes y por defecto, los logs rotan.

Uso de **SAR**:

| Comando    | Ejecución                      |
| ---------- | ------------------------------ |
| sar -u     | Visualiza la CPU               |
| sar -r     | Visualiza la memoria           |
| sar -B     | Muestra la IO de la memoria    |
| sar -s     | Visualiza la memoria Swap      |
| sar -w     | Muestra la IO de la Swap       |
| sar -b     | Visualiza el disco             |
| sar -n DEV | Visualiza el movimiento de red |

Comentario especial a la forma de ver algún log en especial y no toda la info, quedaría como (el ejemplo es sobre disco, pero podemos cambiar la -b por lo que requiramos)

```bash
sar -b -f /var/log/sysstat/sa30 -s 08:30:00 -e 09:00:00
```

Con esto veríamos el log del día 30 del mes (opción -f), desde la hora 08:30 (opción -s) hasta las 09:00 (opción -e)

Una vez realizado todo esto, deberemos habilitar el servicio sysstat en nuestro sistema con systemctl (as usual):

```bash
sudo systemctl enable sysstat
sudo systemctl start sysstat
```

Aquí podemos ver un ejemplo básico con lo recopilado del día de hoy, teniendo en cuenta que he apagado el servidor durante la noche, realizo el ejemplo con el disco:

![[Pasted image 20241001104455.png]]

En github, podemos encontrar diferentes opciones para realizar gráficas en nuestro navegador, pero esto ya no sería parte del objetivo, lo revisaré con atención.

El paquete además nos proporciona algunas herramientas mas, paso a copiar el fragmento de github, alguna de las herramientas que se mencionan serán usada mas adelante.

- **iostat** reports CPU statistics and input/output statistics for block devices and partitions.
- **mpstat** reports individual or combined processor related statistics.
- **pidstat** reports statistics for Linux tasks (processes) : I/O, CPU, memory, etc.
- **tapestat** reports statistics for tape drives connected to the system.
- **cifsiostat** reports CIFS statistics.

### Básicas

Además del anterior paquete, podemos encontrar algunas herramientas básicas de monitorización, las mencionaré de forma básica y si es necesario ahondaré en ellas mas adelante en alguno de los siguientes puntos:

- **top** herramienta que nos mostrará la CPU, la Ram y los procesos en el momento de su ejecución, herramienta básica en todo sistema Linux e instalada por defecto.
- **htop** sería una modernización del anterior mencionado top.
- **ps o pstree** con esto podremos visualizar los procesos actuales que corren en nuestro sistema.
- **w** mostrará los usuarios y los procesos que están ejecutando.
- **ab** con esto podemos hacer un test de stress

ab se usa de la siguiente forma:

```bash
# -n es el número de peticiones y -c el número de usuarios concurrentes sobre el servicio que decidamos (yo he puesto un servicio http)
ab -n 10000 -c 10 http://ip/
```

## CPU

La CPU puede ser consumida por los procesos que lanzamos, tanto requeridos por usuarios como por la propia administración del sistema, vamos a iniciar explicando alguna herramienta básica y la forma de buscar y detener procesos.

### top
Como no, la herramienta básica que visualiza en el tiempo, muy útil para visualización de CPU y memoria (habrá herramientas top específicas para disco y red)

- Por defecto, filtrará por CPU, pero podemos cambiar de modo presionando la tecla "m"
- Presionado "shift + F" nos dará opciones de customización 
- "h" es nuestro help
- htop tiene el mismo funcionamiento, pero tendremos una barra indicadora que nos dará las opciones de forma mas clara.

![[Pasted image 20241001110615.png]]

Como podemos ver en la imagen, después de CPU tenemos varios valores, los mas importantes serían:

| Campo | Descripción                                    |
| ----- | ---------------------------------------------- |
| us    | % de uso por los usuarios                      |
| sy    | % de uso por el sistema                        |
| id    | iddle o tiempo sin uso (es mejor que sea alto) |

```bash
# Con esta opción podemos monitorizar un proceso en concreto
top -Hp <PID>
```

### Procesos

 #### ps
 
 Sería el comando mas básico, nos listará los procesos, podemos realizar un grep para buscar un proceso en concreto y encontrar el PID, muestro un par de formas de uso:

```bash
# Con esto el filtraremos por los procesos de un usuario en concreto
ps --user <nombre_usuario>
# Con esto filtraremos todo lo que esté corriendo apache
ps aux | grep apache
# Listar procesos por consumo de memoria
ps --sort size
```

Cuando hagamos el filtraje con grep, tengamos en cuenta, que el primer servicio con el PID mas bajo, será el proceso padre, es decir, el que controla a todo el resto, en el caso de la imagen, el PID 463 controla todo el servicio ssh.

También podemos ver las múltiples instancias de ssh que tengo abiertas simultáneamente.

![[Pasted image 20241001111544.png]]

#### pstree 

Con esto veremos un árbol de los procesos que tengamos ejecutando, cayendo hasta los procesos hijos y cuantos hay de los mismos, si le damos el número de PID, filtrará a partir de ese punto:

El PID lo he sacado previamente con PS:

![[Pasted image 20241001113140.png]]

#### pmap 

Con *pmap \<pid>* , podremos ver todo lo que esté relacionado con un proceso, incluidas librerías o lo que requiera el proceso.

![[Pasted image 20241001113602.png]]

#### Procesos congelados

Son los procesos que típicamente están con un 0 en utilización de CPU pero aún y así consumen RAM.

La forma mas sencilla de encontrarlos sería con `ps`,  una vez encontrado, lo mataríamos con `kill`, típicamente el comando usado sería:

```bash
kill -9 <PID>
```

### lsof

Nos será útil para saber que ficheros está usando un proceso en concreto, podremos filtrar por nombre de proceso con la opción "-c" o por el PID concreto con la opción "-p"

![[Pasted image 20241001114108.png]]

### mpstat

Reporte de procesos y estadísticas, uso sencillo:

```bash
mpstat <segundos de refresco si queremos>
```

![[Pasted image 20241001114321.png]]

### iostat

Parte del paquete SysStat, nos propocionará las estadísticas de la misma forma que mpstat, pero mas específicamente la entrada y salida de datos de los discos y de forma mas específica.

## Memoria

>**IMPORTANTE**: Si la Swap sube, es un punto a revisar, pues significa que la RAM ha llegado al límite, con lo que en este punto revisaremos como revisar la Swap y la RAM.

Para revisar la Swap, deberemos mirar cuanta escritura en disco está realizando, así que deberemos aprovechar herramientas del siguiente punto disco.

No voy a poner nada de SAR, sólo recordar las opciones que tenemos para visualizar la memoria y la SWAP, están incluidas en la tabla de arriba:

-r: memoria
-s: Swap
-w: IO Swap
-B: IO memoria

Top sería otra utilidad que podríamos usar, así como su homólogo htop

### free
La herramienta mas básica que podemos encontrar, simplemente nos dará la cantidad de RAM y Swap, disponible, usada y total, sin mas, recomendable usar la opción -h para que se pueda leer correctamente los datos. Mas útil de lo que mis palabras muestran.

```bash
free -hs 2
```

Con la opción s buscamos un refresco de la info cada 2 segundos.

### vmstat

Es otra utilidad para ver la memoria, su uso mas normal sería:

```bash
# Con esto marcamos que las unidades sean en Megas y que lo refresque cada dos segundos.
vmstat --unit M 2
# Ahora simplemente tendremos un resumen
vmstat -s
```

![[Pasted image 20241001115844.png]]

### Puntos clave de la memoria

- Page in
	- Normalmente bueno
	- Algo está entrando en RAM
- Page out
	- Bueno en pequeñas cantidades
	- Malo en cantidades grandes
	- Algo está volcando para liberar espacio
- Swap in
	- Malo, pero en pequeñas cantidades es aceptable
	- Algo está moviendo desde la RAM al disco

## Disco

En este caso, tampoco comentaremos mas que el **sar -b** y la necesidad de usar **lsof** comentado mas arriba, para poder ver dónde está escribiendo un proceso.

### iotop

La versión para disco de top, pues top no nos mostrará la IO del disco. Ejecución recomendada con -a, para ver la acumulación de un proceso hasta que finalice.

>Debe ser ejecutada con permisos root (sudo p.e.)

```bash
iotop -a
```

![[Pasted image 20241001121401.png]]

### iostat

Todas las estadísticas del disco, usaremos la opción -x para mas detalle.

```bash
iostat -xt --human

# podemos filtrar por un disco en concreto
iostat -xt --human /dev/sda
```

![[Pasted image 20241001121247.png]]

### Métricas SAR

| Métrica | Resumen                   |
| ------- | ------------------------- |
| rtps    | Read requests per second  |
| wtps    | Write requests per second |
| bread/s | Blocks read per second    |
| bwrtn/s | Blocks written per second |

## Redes

Para redes, no hay herramientas estándar, las herramientas que hay se van a sacar de diferentes paquetes, pero no vamos a usar ninguna que necesite entorno gráfico, todas serán por terminal y recomendadas.

La excepción, sería como siempre sar -n, pero en este caso debemos introducir el parámetro DEV para que busque por los dispositivos de red, quedando como:

```bash
sar -n DEV
```

### ntop / ntopng

Este simplemente lo comentaré un poco por encima, pues sale del contexto de aplicaciones sólo por terminal.

- [ntopng website](https://www.ntop.org/products/traffic-analysis/ntop/)
- `sudo apt install ntopng`
- Alta carga de dependencias, con lo que no lo hace recomendable
- Corre un servidor web

### iftop

La versión de top para ver el tráfico. 

>Debe ser ejecutado con permisos root. 

Una forma recomendable de arrancarlo sería filtrando por la interface de red que queramos monitorizar:

```bash
sudo iftop -i eth0
```

### mtr

Básicamente es un route pero con esteroides, irá lanzando trazas continuamente y nos mostrará cada paso. La opción -z nos mostrará los automátas que encontraremos en las rutas.

```bash
mtr -z URL
```

### Otras herramientas

- **ss**: `ss -natpd`
- **lsof**: con un comando en concreto que sería:

```bash
sudo lsof -iTCP -sTCP:ESTABLISHED
```