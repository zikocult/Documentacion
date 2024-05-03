# Indice

- [FOR](#for)
- [IF](#if)
- [AWK](#awk)
  - [Condiciones AWK](#Condiciones_AWK)
  - [Comandos](#Comandos_AWK)


## **FOR**

El uso del bucle FOR es muy sencillo, con un ejemplo creo que quedará claro

```bash
#!/bin/bash

for i in {1..1000}; 
do
	echo $i
done
```

## **IF**

El else es una alternativa lógicamente, pero lo añado con todo.

```bash
#!/bin/bash

if [condition]; then
	condition
elif [condition]; then
	condition
else
	condition
fi
```

Son importantes los espacios antes y después de la condición, añado ejemplo rápido.

```bash
#!/bin/bash

echo "Please enter your username"
read NAME

if [ "$NAME" = "Guillem" ]; then
	echo "Welcome Guillem"
elif [ "$NAME" = "Ziko" ]; then
	echo "Bueno, pasa, pero no vuelvas"
else
	echo "You are not Guillem, you are $NAME"
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

## **AWK**

[Ejemplos AWK y explicación](https://www.sromero.org/wiki/linux/aplicaciones/uso_de_awk)

Awk es una herramienta de patrones de líneas de texto, aquí unos ejemplos rápidos:

```bash
  ls -l | awk '{ print $8 ":" $5 }'

  Mostrar sólo los nombres y tamaños de ficheros .txt:
  ls -l | awk '$8 ~ /\.txt/ { print $8 ":" $5 }'

  Imprimir las líneas que tengan más de 4 campos/columnas:
  awk 'NF > 4 {print}' fichero
```

El uso básico de **AWK** es:

```bash
awk [condicion] { comandos }
```

- ### Condiciones_AWK

Representa una condición de matcheo de líneas o parámetros.


- ### Comandos_AWK 

Una serie de comandos a ejecutar:

   - $0 → Mostrar la línea completa
   - $N → Mostrar los campos (columnas) de la línea especificados.
   - FS → Field Separator (Espacio o TAB por defecto)
   - NF → Número de campos (fields) en la línea actual
   - NR → Número de líneas (records) en el stream/fichero a procesar.
   - OFS → Output Field Separator (" ").
   - ORS → Output Record Separator ("\n").
   - RS → Input Record Separator ("\n").
   - BEGIN → Define sentencias a ejecutar antes de empezar el procesado.
   - END → Define sentencias a ejecutar tras acabar el procesado.
   - length → Longitud de la línea en proceso.
   - FILENAME → Nombre del fichero en procesamiento.
   - ARGC → Número de parámetros de entrada al programa.
   - ARGV → Valor de los parámetros pasados al programa.

Las funciones utilizables en las condiciones y comandos son, entre otras:

- close(fichero_a_reiniciar_desde_cero)
- cos(x), sin(x)
- index()
- int(num)
- lenght(string)
- substr(str,pos,len)
- tolower()
- toupper()
- system(orden_del_sistema_a_ejecutar)
- printf()

Los operadores soportados por awk son los siguientes:

- *, /, %, +, -, =, ++, --, +=, -=, *=, /=, %=.

El control de flujo soportado por AWK incluye:

- if ( expr ) statement
- if ( expr ) statement else statement
- while ( expr ) statement
- do statement while ( expr )
- for ( opt_expr ; opt_expr ; opt_expr ) statement
- for ( var in array ) statement
- continue, break
- (condicion)? a : b → if(condicion) a else b;

Las operaciones de búsqueda son las siguientes:

- **/cadena/** → Búsqueda de cadena.
- **/^cadena/** → Búsqueda de cadena al principio de la línea.
- **/cadena$/** → Búsqueda de cadena al final de la línea.
- **$N ~ /cadena/** → Búsqueda de cadena en el campo N.
- **$N !~ /cadena/** → Búsqueda de cadena NO en el campo N.
- **/(cadena1)|(cadena2)/** → Búsqueda de cadena1 OR cadena2.
- **/cadena1/,/cadena2>/** → Todas las líneas entre cadena1 y cadena2.

