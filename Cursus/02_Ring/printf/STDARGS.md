Encontraremos lo necesarios en la librería <stdarg.h> que nos proporciona una serie de funciones predefinidas y un nuevo tipo de variable "va_list".

Mucha de la info necesaria la encontraremos en man:

```bash
man stdarg
```

Las funciones mas usadas serían:

```c
# include <stdarg.h>

# Como hemos dicho anteriormente, tenemos un nuevo tipo de variable que definiremos tal que para dar a la variable el nombre args:
va_list args;

# Sirve para iniciar un bucle de recorrido de los argumentos
void va_start (va_list args, last);

# Esta es su contraparte, finaliza la búsqueda de argumentos y libera la memoria.
void va_end (va_list args);

# Recoge el siguiente argumento y lo almacena con el tipo que necesitaramos
va_arg(va_list args, type)

# Copia listas de argumentos
void va_copy (va_list dest, va_list origen);
```

Para iniciar el uso de stdargs, tenemos que definir una función con el tipo de variable que tendrán los argumentos y tres puntos, vamos a mostrar un ejemplo de todo junto

```c
void function_example (char str, ...);
```

Dejo un programa de ejemplo que calcula la media de los x números que daremos en el primer campo.

```c
#include <stdarg.h>
#include <stdio.h>

float	average(int num, ...)
{
	int		total;
	va_list	ap;

	total = 0;
	va_start(ap, num);
	for (int i = 0; i < num; i++)
		total += va_arg(ap, int);
	va_end(ap);
	return ((float)total / num);
}

int main (void)
{
	printf("El valor medio es %.2f\n", average(5, 7, 7, 5, 8, 12));
	return (0);
}
```

Recordemos que el primer número pasado a average, no entra dentro del cómputo de la suma, pues es un indicador de la cantidad de argumentos que tenemos.