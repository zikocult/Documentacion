
## 1. Personalizar y trabajar en el entorno de shell

La shell es la interfaz de interacción entre el pc y el entorno de programación, hay varias, bash, csh, fish o zsh. Por defecto, la mayoría de distribuciones usan bash.

#### **Variables**

Se usan para proporcionar información útil y necesaria para programas y usuarios, se define de forma:
```bash
nombre=valor
```

No puede tener espacios y pueden ser:

- **Globales**: todas aquellas accesibles a todos los procesos como:
	- PATH: define directorios de programas
	- HOME: define el directorio personal del usuario
	- SHELL: determina el shell estándar de usuario
	- Los nombres de las globales son en mayúsculas y pueden listarse con el comando **env**, para listarlas todas, usaremos **set**.
	- Se definen el el momento del login de usuario y las encontraremos en el fichero /etc/profile o si es para un usuario específico ~/.bash_profile
- **Locales**: son sólo accesibles para la sesión actual de la shell:
	- Pueden definirse en scripts o en la propia línea de comando.
	- Detallo su uso mas abajo.
	
Para dejar una variable accesible para las sesiones a partir de la actual, deberemos incluirla en los ficheros profile y usar:
	 
```bash
export NOMBREVAR='contenido variable'
```

Para obtener el valor de la variable usamos:

```bash
echo $NOMBREVAR
```

Para borrar el contenido usamos:

```bash
unset NOMBREVAR
```

#### **Funciones**

Pueden escribirse en linea de comando, en scripts o en archivos de configuración del bash, vamos a mostrar un ejemplo que mostraría la localización de un ejecutable y los procesos abiertos:

```bash
function pinfo(){
echo "localización de $1:"
which $1
echo "procesos referentes a $1:"
ps x | grep $1
}
```

Como siempre, para que funcione en futuras sesiones, deberá ser incluido en el fichero de cada usuario ~/.bashrc (o la shell que pertoque)

#### **Archivo de configuración del bash**

Tiene dos maneras de ser leído / activado:
- Después del login de usuario (Shell interactivo), orden de lectura de ficheros:
	1. /etc/profile
	2. ~/.bash_profile
	3. ~/.bash_login
	4. ~/.profile
- Al terminar ejecturá las instrucciones de:
	1. ~/.bash_logout.
- A partir de una sesión ya iniciada (shell no interactivo), en este caso se ejecutarán los siguientes ficheros:
	1. /etc/bash.bashrc
	2. ~/.bashrc

## 2. Editar y escribir scripts simples

Son archivos que actúan como programas, son interpretados.

#### **Definición del interpretador**
La primera linea del script identifica al interpretador con los caracteres #! (shebang), para instrucciones de bash por ejemplo sería #!/bin/bash.
El fichero debe tener permisos de ejecución.

#### **Variables especiales**

Los argumentos se devueven con $x:

| Argumento | Descripción                               |
|:---------:| ----------------------------------------- |
|    $*     | Todos los valores pasados como argumentos |
|    $#     | El nº de argumentos                       |
|    $0     | El nombre del script                      |
|    $n     | El valor del argumento en la posición n   |
|    $!     | PID del último programa ejecutado         |
|    \$$    | PID de la Shell actual                    |
|    $?     | Código de salida del último comando       |

#### **If the else**

if ejecuta un comando o lista de comandos y evalua si la respuesta es verdadera o falsa.

```bash
if [ -x /bin/bash ] ; then
	echo "ok"
else
	echo "no ok"
fi
```

Otra manera de ponerlo sería sin los corchetes:

```bash
if test -x /bin/bash ; then
	echo "ok"
fi
```

Diferentes opciones para las evaluaciones, vamos a ver unas cuantas:

| Archivos y directorios | Descripción                                |
|:----------------------:| ------------------------------------------ |
|        -d path         | true si el path existe y es un directorio  |
|        -c path         | true si existe el path                     |
|        -f path         | true si existe y es un archivo             |
|        -L path         | true si existe y es un enlace simbólico    |
|        -r path         | true si existe y puede leerse              |
|        -s path         | true si existe y su tamaño es superior a 0 |
|        -w path         | true si existe y puede escribirse          |
|        -x path         | true si existe y es ejecutable             |
|    path1 -ot path2     | true si path1 es diferente a path2         |


| Evaluación de texto | Descripción                            |
|:-------------------:| -------------------------------------- |
|      -n texto       | si el tamaño del texto es distinto a 0 |
|      -z texto       | si el tamaño del texo es igual a 0     |
|   texto1\==texto2   | si texto1 es igual que texto2          |
|   texto1!=texto2    | si texto1 es distinto a texto2         |


| Evaluación numérica | Descripción     |
|:-------------------:| --------------- |
|    num1 -lt num2    | si num1 < num2  |
|    num1 -gt num2    | si num1 > num2  |
|    num1 -le num2    | si num1 <= num2 |
|    num1 -ge num2    | si num1 >= num2 |
|    num1 -eq num2    | si num1 = num2  |
|    num1 -ne num2    | si num1 != num2 |

#### **Case**

La instrucción proseguirá si el ítem indicado se encuentra en la lista de ítems:

```bash
case 3 in (1|2|3|4|5)
	echo "Numero 3 encontrado en la lista";
esac
```

Voy a poner un ejemplo un poco mas elaborado extraído de uno de mis scripts para Hyprland, donde añado a la variable r el valor y si es igual, ejecuto:

```bash
#!/bin/bash

r=$(echo -e "Thunar\nRanger\nMidnight" |  rofi -dmenu -show-icons -i -theme-str '@import "~/.config/rofi/config.rasi"' -p "Exploradors   :")

case "$r" in
	"Thunar" ) thunar ;;
    "Ranger") kitty -e bash ranger ;;
    "Midnight" ) kitty -e mc ;;
    *) echo " " ;;
esac
```

#### **Sustitución de comandos**

Para mostrar o almacenar la salida de un comando, el mismo se coloca entre comillas simples invertidas \` o entre $(). Ejemplos:

```bash
TRESLINEAS=`cat -n3 /etc/inputrc`
echo "Las tres primeras lineas de /etc/inputrc:"
echo $TRESLINEAS

O de la siguiente manera:

TRESLINEAS=$(cat -n3 /etc/inputrc)
echo "Las tres primeras lineas de /etc/inputrc:"
echo $TRESLINEAS
```

#### **Operaciones matemáticas**

Para operar con números enteros usamos **expr** :

```bash
SUMA=`expr $VALOR1 + $VALOR2`
o
SUMA=$((expr $VALOR1 + $VALOR2))
```

#### **For**

Vamos a poner un par de ejemplos, pues considero que es mas visible, una con el comando seq y otro con un rango.

Ambos ejemplos inician en el 1.

```bash
#!/bin/bash

for i in $(seq 5)$; 
do
	echo $i
done
```

```bash
#!/bin/bash

for i in {1..5}; 
do
	echo $i
done
```

#### **Until**

Ejecuta una acción en loop hasta que la afirmación sea verdadera:

```bash
LENTEXTO=$(wc -l texto_simle)

until [ ${LENTEXTO%%*} -eq 10 ];
do
	echo "una linea mas" >> texto_simple
	LENTEXTO=$(wc -l texto_simple)
done
```

Añadirá lineas hasta que haya 10 y pare.

#### **While**

Ejecuta una acción en loop hasta que la afirmación sea falsa:

```bash
LENTEXTO=$(wc -l texto_simle)

while [ ${LENTEXTO%%*} -lt 10 ];
do
	echo "una linea mas" >> texto_simple
	LENTEXTO=$(wc -l texto_simple)
done
```

Añadirá una linea mas y contará el nº de lineas mientras no haya 10 lineas.

## 3. Administración de datos SQL

SQL es un lenguaje de consulta estructurada.

Cada tecnología tiene su propia herramientoa MySQL y para Postresql (psql).

Las bases de datos se organizan en tablas que contienen columnas y filas.

#### **Inserción de datos**

Se realizan con el comando INSERT

```sql
INSERT INTO cliente (nombre, correo) VALUES ('Surmano', 'ayoma@querica.com');
```

#### **Consultas de datos**

Con el comando SELECT

```sql
Todas las filas
SELECT * FROM cliente;

Todas las filas pero sólo id y nombre.
SELECT id, nombre FROM cliente;

Todas donde el id sea 2
SELECT id, nombre FROM cliente WHERE id=2;

Todas las filas pero sólo el id y nombre y ordenadas por id en orden descendiente.
SELECT id, nombre FROM cliente ORDER BY id DESC;

Todas las filas de item agrupadas por nombre y sumando el precio. Desaparecerán los duplicados por nombre y sus precios se sumarán.
SELECT nombre, SUM(precio) FROM item GROUP BY nombre;
```

#### **Modificación y borrado de datos**

Modificar con el comando UPDATE:

```sql
UPDATE cliente SET telefono='999999999' WHERE id=2;
```

Para borrar usaremos el comando DELETE:

```sql
DELETE FROM cliente WHERE id=2;
```

#### **Relación de tablas**

Una de las ventajas de las bases de datos es poder relacionar las tablas, con el comando INNER JOIN podemos relacionarlas.

```sql
SELECT cliente.nombre, direccion.prov FROM cliente INNER JOIN direccion ON direccion.id_cliente=cliente.id
```

