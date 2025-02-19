- [[#isatty]]
- [[#ttyname]]
- [[#ttyslot]]
## isatty

Es una función sencilla que simplemente testea si el fd que querramos está abierto o no.

Los valores que devuelve son 1 si está abierto, 0 si está cerrado.

El prototipo sería:

```c
#include <unistd.h>

int isatty(int fd);
```

Curiosamente sólo funciona con los fd clásicos del sistema STDIN, STDOUT y STDERR, lo muestro con el siguiente código, dónde realmente leo un fichero que he creado y devuelvo el primer carácter, pero aún y así me dice que el fd está cerrado, en cambio con 0, 1 o 2 funciona perfectamente.

Podemos también pasarlo con la notación (entre paréntesis el número del fd) **STDIN_FILENO** (0), **STDOUT_FILENO** (1) y **STDERR_FILENO** (2)**.

```c
#include <stdio.h>
#include <unistd.h>
#include <fcntl.h>

int main(void)
{
	int fd1;
	ssize_t nr_bytes;
	char buff;

	fd1 = open("/home/ziko/Downloads/test.txt", O_RDONLY);	
	if (isatty(fd1))
		printf("abierto\n");
	else
		printf("cerrado\n");
	nr_bytes = read(fd1, &buff, 1);
	if (nr_bytes == 0)
		return 1;
	printf("%c\n", buff);
	if (isatty(2))
		printf("abierto\n");
	else
		printf("cerrado\n");
	close(fd1);
}
```

Siendo el output como se ve (la H es por no matarme, sólo he copiado el primer carácter de un fichero que ponía "Hola Mundo!"):

![[Pasted image 20241127193227.png]]

## ttyname

En este caso, nos devolverá en que terminal está abierto el fd standard (volvemos a los 3 típicos), como anteriormente no funcionará con los malos open.

El prototipo es:

```c
#include <unistd.h>

char \*ttyname(int fd);
```

Vuelvo a mostrar como si funciona con todos los fd de sistema y que el output es la terminal dónde está abierto este fd.

```c
#include <stdio.h>
#include <unistd.h>
#include <fcntl.h>

int main(void)
{
	int fd1;
	ssize_t nr_bytes;
	char buff;

	fd1 = open("/home/ziko/Downloads/test.txt", O_RDONLY);	
	nr_bytes = read(fd1, &buff, 1);
	if (nr_bytes == 0)
		return 1;
	printf("%c\n", buff);
	printf("ttyname(0): %s\n", ttyname(0));
	printf("ttyname(1): %s\n", ttyname(1));
	printf("ttyname(2): %s\n", ttyname(2));
	printf("ttyname(fd1): %s\n", ttyname(fd1));
	close(fd1);
}
```

![[Pasted image 20241127194511.png]]

## ttyslot

Es una función antigua que devuelve el indice de la actual entrada del usuario en algún fichero, en qué fichero? pues en el primero de la historia.

Prototipo

```c
#include <unistd.h>

int ttyslot(void);
```

Antiguamente se podría configurar su salida mediante los ficheros `/etc/utmp` y `/etc/ttys`, pero en los sistemas que tengo por casa, ya no existen estos fichero o se deberían crear de 0.

> No sé para que vamos a usar esta función, de hecho no le veo mucha utilidad, pero supongo que estará aquí por algún punto en concreto del proyecto.

