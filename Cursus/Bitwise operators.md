Son los operadores lógicos clásicos, se pueden usar los siguientes en C: **OR, AND & NOT**, tienen alguna diferencia con los operadores lógicos que veremos mas adelante.

Como el nombre sugiere, los bitwise, sirven para manipular bit a bit un dato, los diferentes operandos serían:

| Símbolo | Lógica               |
|:-------:| -------------------- |
|    &    | AND                  |
|   \|    | OR                   |
|    ~    | NOT                  |
|   <<    | Mueve a la izquierda |
|   >>    | Mueve a la derecha   |
|    ^    | XOR                  |

Tabla de la verdad de **AND**, pero básicamente sólo 1 & 1 = 1:

|  A  |  B  | A & B |
|:---:|:---:|:-----:|
|  0  |  0  |   0   |
|  0  |  1  |   0   |
|  1  |  0  |   0   |
|  1  |  1  |   1   |

7  -->  0  1  1  1
4  -->  0  1  0 0
&  <--  0  1  0 0

Tabla de la verdad de **OR**, pero básicamente sólo 0 | 0 =0:

|  A  |  B  | A \| B |
|:---:|:---:|:------:|
|  0  |  0  |   0    |
|  0  |  1  |   1    |
|  1  |  0  |   1    |
|  1  |  1  |   1    |

7  -->  0  1  1  1
4  -->  0  1  0 0
\| <--   0  1  1  1

El caso del **NOT** es un poco particular, pues no es un operador, si no que convierte a su par en su contrario.


|  A  | ~A  |
|:---:|:---:|
|  0  |  1  |
|  1  |  0  |

7 --> ~ 0 1 1 1
8 <--   1 0 0 0
~7 = 8

El caso del **XOR** es un poco particular, pues no es un operador, si no que convierte a su par en su contrario.

|  A  |  B  | A ^ B |
|:---:|:---:|:------:|
|  0  |  0  |   0    |
|  0  |  1  |   1    |
|  1  |  0  |   1    |
|  1  |  1  |   0    |

7  -->  0  1  1  1
4  -->  0  1  0 0
^ <--   0  0  1  1

**Left Shift Operator**

```
first operand              <<      second operand
	|                                     |
Whose bits get left shifted        Decides the number of places to shift        
```

Cuando los bits se mueven a la izquierda, los números que dejan detrás se rellenan con 0s.

```c
#include <stdio.h>

int main(void)
{
	char var = 3; //3 in binary = 0000 0011
	printf("%d", var << 1);
	return (0);
}

// el output sería 0000 0110 o lo que es lo mismo 6
```

Left shifting es igual a multiplicar **2^second_operand**, ejemplos:

var = 3
	var << 1   --  **Output: 6** [$3  \times 2^1$]
	var << 4   --  **Output: 48 **[$3 \times 2^4$]

**Right Shift Operator**

```
first operand              >>      second operand
	|                                     |
Whose bits get left shifted        Decides the number of places to shift        
```

Cuando los bits se mueven a la derecha, se rellenará con 0s la parte mas a la izquierda que ha quedado libre.

```c
#include <stdio.h>

int main(void)
{
	char var = 3; //3 in binary = 0000 0011
	printf("%d", var >> 1);
	return (0);
}

// el output sería 0000 0001 o lo que es lo mismo 1
```

Left shifting es igual a dividir por **2^second_operand**, ejemplos:

var = 3
	var >> 1   --  **Output: 1 **[$3  \div 2^1$]

var = 32
	var >> 4   --  **Output: 2 **[$32 \div 2^4$]

Voy a poner un ejemplo en C:

```c
#include <unistd.h>

void	print_bits(unsigned char octet)
{
	int				i;
	unsigned char	bit;

	i = 8;
	while (i--)
	{
		bit = (octet >> i & 1) + '0';
		write(1, &bit, 1);
	}
}

int main(void) 
{
    unsigned char octet = 'a';

	print_bits(octet);
	write(1, "\n", 1);
    return (0);
}
```

Este es un programa en C que imprime la representación binaria de un carácter.

Aquí está el desglose:

- En la línea 15, se define una función `print_bits` que toma un `unsigned char` como argumento. Un `unsigned char` es un tipo de dato que puede contener un carácter o un número pequeño.

- En la línea 17 y 18, se definen dos variables, `i` y `bit`. `i` se usará para iterar a través de cada bit en `octet`, y `bit` se usará para almacenar el valor del bit actual.

- En la línea 20, `i` se inicializa a 8, porque un `unsigned char` tiene 8 bits.

- En las líneas 21-25, hay un bucle que se ejecuta 8 veces. En cada iteración, se realiza una operación de desplazamiento a la derecha en `octet` por `i` bits (línea 23). Esto mueve el bit en la posición `i` al principio de `octet`. Luego, se realiza una operación AND con 1, lo que da como resultado el valor del bit en la posición `i`. Este valor se suma a `'0'` para convertirlo en un carácter que puede ser impreso, y luego se imprime.

- En la línea 28-35, se define la función `main`, que es el punto de entrada del programa. En la línea 30, se inicializa `octet` con el carácter `'a'`. Luego, en la línea 32, se llama a `print_bits` con `octet` como argumento, lo que imprime la representación binaria de `'a'`. Finalmente, se imprime una nueva línea y el programa termina.

Puedes cambiar el caracter 'a' por un número y lo traducirá sin problemas.