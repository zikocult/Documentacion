Funciones autorizadas:

- [[#Memset]]
- [[#Printf]]
- [[#Malloc and Free]]
- [[#Write]]
- [[#Usleep]]
- gettimeofday
- pthread_create
- pthread_detach
- pthread_join
- pthread_mutex_init
- pthread_mutex_destroy
- pthread_mutex_lock
- pthread_mutex_unlock

### Memset

[Memset examples](https://www.geeksforgeeks.org/memset-c-example/)

Memset es usado para rellenar los bloques de memoria con un valor en particular, la sintaxis de memset vendría a ser:

```c
// ptr -> Inicio de la dirección de memoria a ser rellenada
// x -> Valor con el que se rellenará
// n -> Número de bytes para ser rellenado empezando desde ptr
// es contenido en la librería string.h

void *memset(void *ptr, int x, size_t n);
```

Ejemplo de programa funcional:

```c
#include <stdio.h> 
#include <string.h>

int main()
{
	char str[50] = "GeeksForGeeks is for programming geeks.";
	printf("\nBefore memset(): %s\n", str);
	
	// Fill 8 characters starting from str[13] with '.'
	memset(str + 13, '.', 8*sizeof(char));
	printf("After memset():  %s\n", str);
	return 0; 
}
```

Y ya que la tengo hecha, pongo la implementación en C de la función en cuestión:

```c
#include <stdio.h> // Definición de size_t

void	*ft_memset(void *s, int c, size_t n)
{
	size_t			i;
	unsigned char	*p;

	i = 0;
	p = s;
	while (i < n)
	{
		p[i] = (unsigned char)c;
		i++;
	}
	return (s);
}
```

### Printf

No voy a dedicar tiempo  a explicar este, simplemente es una implementación para poner en terminal texto formateado a nuestro gusto, pondré un hello world rápido, añadiendo alguna chorrada y pondré los identificadores ya que creo que no los tengo en ningún otro lado en la documentación

```c
#include <stdio.h>

int main(void)
{
	int a = 5;
	float b = 5.543212;
	char c[25] = "Hello World";
	int d = 2;

	printf("%s\nSuma: %i\nFloat dos decimales: %.2f\n", c, a + d, b);
	return (0);
}
```

Este es el resultado del programa anterior

```
Hello World
Suma: 7
Float dos decimales: 5.54
```

|_specifier_|Output|Example|
|---|---|---|
|d _or_ i|Signed decimal integer|392|
|u|Unsigned decimal integer|7235|
|o|Unsigned octal|610|
|x|Unsigned hexadecimal integer|7fa|
|X|Unsigned hexadecimal integer (uppercase)|7FA|
|f|Decimal floating point, lowercase|392.65|
|F|Decimal floating point, uppercase|392.65|
|e|Scientific notation (mantissa/exponent), lowercase|3.9265e+2|
|E|Scientific notation (mantissa/exponent), uppercase|3.9265E+2|
|g|Use the shortest representation: %e or %f|392.65|
|G|Use the shortest representation: %E or %F|392.65|
|a|Hexadecimal floating point, lowercase|-0xc.90fep-2|
|A|Hexadecimal floating point, uppercase|-0XC.90FEP-2|
|c|Character|a|
|s|String of characters|sample|
|p|Pointer address|b8000000|
|n|Nothing printed.  <br>The corresponding argument must be a pointer to a signed int.  <br>The number of characters written so far is stored in the pointed location.||
|%|A % followed by another % character will write a single % to the stream.|%|

### Malloc and Free

Reserva de un area de memoria de un tamaño determinado, la estructura es ya conocida, pero ahora la pondremos.

Free hace lo contrario, pues libera esa memoria, ya que dicha memoria no se libera automáticamente en caso del cierre del programa.

Su uso sería para hacer una reserva de 5 espacios enteros:

```c
#include <stdlib.h>
int* ptr=(int*)malloc(5 * sizeof(int));
free (ptr);
```

La consulta, modificación serían igual que con un array.

>! Es importante que por cada malloc haya un free una vez usado.

### Write

Es otro viejo conocido, aún no hemos visto nada nuevo, pero vamos a refrescar rápido, pues básicamente es otra función que muestra texto en pantalla, pero en este caso sin formato alguno, voy a poner su synopsis y simplemente recordar que es importante la cantidad de bytes que vamos a escribir.

```c
#include <unistd.h>

ssize_t write(int _fd_, const void _buf_[._count_], size_t _count_);
```

Un ejemplo rápido sería:

```c
#include <unistd.h>

int main(void)
{
	// Con fd = 1 me estoy refiriendo a la salida standard del sistema (stdout)
	write(1, "Hello world\n", 12);
	return (0);
}
```

### Usleep

Aquí ya si que iniciamos con nuevas funciones, con lo que voy a referir primero a la página dónde he sacado la info, que es [esta](https://www.geeksforgeeks.org/how-to-use-usleep-function-in-cpp-programs/).

Detiene la ejecución de un programa el tiempo deseado en milisegundos, normalmente es usado para proveer algo de tiempo para un input o multithreading.

El uso sería:

```c
#include <unistd.h>
int usleep(useseconds_t useseconds)
```

Y aquí un programa usando usleep deteniendo 5 segundos entre el primer y el segundo paso de *printf*

```c
#include <unistd.h> 
#include <stdio.h>
  
int main(void)
{ 
	printf("Primera linea\n");
	usleep(5000000); 
	printf("Segunda linea\n");
	return (0); 
}
```