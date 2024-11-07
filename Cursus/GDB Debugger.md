GDB es el debugger por defecto de toda la plataforma GNU, también podemos encontrar alguna alternativa como LLDB, pero es mas usado en entornos MAC, así que por el momento nos centraremos en GDB.

Para empezar a usarlo, es necesario compilar tu código con el flag de depuración **-g**

Añado el código de prueba que he estado usando para probar todos y así ir poniendo los diferentes ejemplos.

En primer lugar, lo compilaríamos tal que:

```bash
gcc -Wall -Wextra -Werror camel_to_snake.c -o camel -g
```

y este sería el código fuente, como se verá, necesita argumentos, parte fundamental para mi en este momento de aprendizaje, así como el paso a funciones, por eso he añadido una función simple, lo dejo por si se quieren realizar pruebas con toda la info contenida en este documento.

```c
//camel_to_snake.c

#include <unistd.h>

void ft_putchar(int c)
{
	write(1, &c, 1);
}

int main(int argc, char **argv)
{
	int i = 0;
	if (argc == 2)
	{
		while(argv[1][i])
		{
			if (i > 1)
			{
				if (argv[1][i] >= 'A' && argv[1][i] <= 'Z')
				{
					ft_putchar('_');
					ft_putchar(argv[1][i] + 32);
				}
				else
					ft_putchar(argv[1][i]);
			}
			else
					ft_putchar(argv[1][i]);
			i++;
		}
	}
	ft_putchar('\n');
	return (0);
}
```

Una vez compilado, podemos arrancar con **gdb "archivo ejectuable"**, en el caso del ejemplo y como necesito pasar argumentos, añadiré la opción *--args* y el argumento después del ejecutable como lo haría de normal, quedando tal que:
*Nota: Si no ponemos argumentos, podremos modificar posteriormente las variables*

```bash
> gdb --args camel "testeandoQueEsGerundio"
```

Una vez realizado esto, se nos abrirá una consola propia de gdb, dónde podremos correr nuestro código, es en esta consola dónde iremos avanzando mediante comandos simples y una pequeña TUI por todo el aplicativo.

Este sería un ejemplo muy simple de un manejor de gdb y algunos de sus comandos:

```bash
#Añadimos un punto de break en la linea 25.
(gdb) break 25

#Podríamos poner el break al inicio de una función, por ejemplo main:
(gdb) break main

#Si no queremos poner el break, podemos iniciar con start y pondrá el break en la primera linea del main, pero en este caso, vamos a correr run e irá al primer break que encuentre.
(gdb) run

# Sea mendiante run o start, lanzar un layout, luego entraré mas en detalle, pero es para ver el código fuente y el punto de ejecución, para lanzar uno con el código fuente sería:
(gdb) layout src

# Con step veremos paso a paso saltando a otras funciones:
(gdb) step

# En el caso de next, pasaremos al siguiente paso dentro de la función activa
(gdb) next

# nexti es el siguiente paso, pero dentro de assembler, no de C.
(gdb) nexti

# en el punto que necesitamos, vamos a printar el valor de una variable, pongo i como ejemplo
(gdb) print i

# para no ir paso a paso y saltar de break a break, usamo continue:
(gdb) continue

# una buena manera de encontrar el punto dónde cae el error, es correr el programa con start, seguido de continue, parará en el segfault o lo que detenga tu software.

(gdb) start
(gdb) continue
```

Voy a añadir una serie de comandos útiles (en algunos casos creo que indispensables) y su explicación, aunque con lo de arriba mencionado, ya nos podríamos empezar a mover con GDB:

- **ref** :  refresca el contenido de pantalla,  muy útil cuando hay datos superpuestos y queremos una terminal mas limpia
- **set variable**: nos permite setear a lo que necesitemos el valor de una variable, por ejemplo **set variable i = 3**, con esto podríamos modificar o añadir argumentos si fuera necesario.
- **display variable**: muestre el contenido de una variable, su uso siguiendo el ejemplo de "i" sería tal que **display i**
- **file**: si necesitamos recoger el archivo de nuevo, pues hemos hecho cambios y queremos probarlos (requiere recompilación), su uso sería *file archivo*
- **layout**: antes ya comentado, es para arrancar el tui que necesitamos, con *help tui layout* tendremos todas las opciones, la que mas usaremos a parte de la anterior mencionada es *layout next* que nos moverá entre los diferentes layouts.
- **list**: muestra el código fuente (si no está activa la TUI)
- **backtrace o bt**: mostraá la pila de comandos actuales.
- **info registers**: valores de registro de la CPU.
- **info breakpoints**: muestra toda la información que tenemos ahora mismo en los breakpoints
	- **delete number**: con la info anterior, si ejecutamos este comando y el número de break, lo eliminaremos.
- **info args**: muestra los argumentos pasados de una función a otra.
- **info functions**: Nos mostrará el detalle de la definición de las funciones del código.
- **quit**: obviamente, para salir del programa :)

En este punto ya debo empezar a investigar mas, pero creo que es un buen punto de partida para empezar, pero debería mirar como se ve el alamacenamiento de datos en variables en assembler y la llamada a funciones, pues así podría encontrar el punto exacto de cada uno de mis mas que seguros futuros fallos.