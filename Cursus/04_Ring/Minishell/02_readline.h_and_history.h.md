
- [[#Introducción]]
- [[#readline]]
- [[#add_history]]
- [[#rl_clear_history]]
- [[#rl_on_new_line]]
- [[#rl_redisplay]]
- [[#rl_replace_line]]

## Introducción

Man de [readline](https://www.man7.org/linux/man-pages/man3/readline.3.html), tiene muchísimas cosas para poder configurar anteriormente que no resumiré aún.

>En las distros normales de Linux no están las librerías por defecto, se deben instalar, debo suponer que en 42 si que estarán ya instaladas

```bash
sudo dnf install readline readline-devel
sudo apt install libreadline6 libreadline6-dev 
# nota sobre debian: la versión puede variar, habría que hacer un apt search
```

>Por otro lado, al compilar deberemos especificar que la estamos usando añadiendo `-lreadline` en la linea de compilación.

Usa las siguientes **librerías**:

```C
#include <stdio.h>
#include <readline/readline.h>
#include <readline/history.h>
```

>Cuidado aquí, pues, readline provoca **"leaks"**, quedarán como `still reachable`, estos leaks están permitidos por el enunciado de minishell.

![[Pasted image 20241115170628.png]]
## readline

La función principal, su uso básico es leer la entrada del terminal usando un prompt.

Y la **definición** de la función es simple:

```c
char * readline(const char *prompt);
```

Con esto nos mostrará un prompt y esperará a que le introduzcamos algo para ejecutarlo, voy a poner un **ejemplo** de uso un ejemplo simple, que he subido a la carpeta examples por si se quiere compilar y probar como `readline.c`.

```c
#include <stdlib.h>
#include <stdio.h>
#include <readline/readline.h>
#include <string.h>

int main(void)
{
	char *command_buff;

	while (1)
	{
		command_buff = readline("minishell> ");
		if (!strcmp(command_buff, "exit"))
		{
			free(command_buff);
			break;
		}
		free(command_buff);
	}
}
```

>*command_buff* se debe liberar tal como pongo, estos leaks si que no serían aceptables.

## add_history

Añade un historial de comandos, podrá ser consultado posteriormente clicando las flechas arriba y abajo, aún no he descubierto si se puede consultar de alguna otra manera, por ejemplo para listar el historial, tal como hace el history real de bash, pero debemos implementarlo.

Creo que el truco está en la estructura de datos que crea para poder ser consultada, la estructura es la siguiente:

```c
	typedef void * histdata_t;

	typedef struct _hist_entry {
		char *line;
        char *timestamp;
        histdata_t data;
    } HIST_ENTRY;

// La historia sería declarar a posteriori:

HIST_ENTRY **the_history_list;
```

Su definición es:

```c
void add_history (cons char *string);
```

Simplemente le añadiremos al final del historial el comando que haya ejecutado, podemos añadirlo cuando queramos, pues una ejemplo añadiendo el history al anterior sería:

```c
#include <stdlib.h>
#include <stdio.h>
#include <readline/readline.h>
#include <string.h>

int main(void)
{
	char *command_buff;

	while (1)
	{
		command_buff = readline("minishell> ");
		if (strlen(command_buff) > 0)
			add_history(command_buff);
		if (!strcmp(command_buff, "exit"))
		{
			free(command_buff);
			break;
		}
		free(command_buff);
	}
}
```

## rl_clear_history

Simple y fácil, libera la memoria usada para almacenar el historial, nada mas, lo podemos llegar a añadir al final del programa para liberar el historial guardado.

Su definición es sencilla y su uso igual, es simplemente invocarlo y es la contraparte de **add_history**.

```c
void rl_clear_history(void);
```

Seguimos con el mismo ejemplo:

```c
#include <stdlib.h>
#include <stdio.h>
#include <readline/readline.h>
#include <string.h>

int main(void)
{
	char *command_buff;

	while (1)
	{
		command_buff = readline("minishell> ");
		if (strlen(command_buff) > 0)
			add_history(command_buff);
		if (!strcmp(command_buff, "exit"))
		{
			free(command_buff);
			rl_clear_history();
			break;
		}
		// si pusieramos aquí el rl_clear_history, 
		// estaríamos borrando el historial a cada paso
		free(command_buff);
	}
}
```

## rl_on_new_line

>Esta función está muy atada a `rl_redisplay` que contaré después de esta, el ejemplo lo pondré en la siguiente, pues necesita de ambas para funcionar correctamente.

El propósito de la función `rl_on_new_line`  es preparar la línea de entrada para la redisplay (revisualización) después de que se haya realizado algún cambio en el contenido de la línea de entrada.

En términos más específicos, `rl_on_new_line` realiza las siguientes acciones:
1. Marca el punto de inicio de la línea de entrada.
2. Indica que la línea de entrada ha sido modificada y necesita ser redisplayada.

Esto es útil cuando se está implementando un comportamiento personalizado en el manejo de la línea de comandos y se necesita actualizar la visualización de la línea de entrada después de realizar cambios en ella.

En resumen, `rl_on_new_line` asegura que la línea de entrada se actualice correctamente en la pantalla después de cualquier modificación.

Su prototipo sería:

```c
int rl_on_new_line(void);
```

## rl_redisplay

La función `rl_redisplay` es parte de la biblioteca GNU Readline y su propósito es actualizar la visualización de la línea de entrada en la terminal. Aquí tienes algunas notas sobre `rl_redisplay`:

- **Prototipo**: `int rl_redisplay(void);`
- **Función**: Redibuja la línea de entrada actual en la terminal.
- **Uso común**: Se utiliza después de realizar cambios en la línea de entrada para reflejar esos cambios en la pantalla.
- **Dependencia**: A menudo se usa junto con `rl_on_new_line` para preparar la línea antes de redibujarla.
- **Retorno**: Devuelve 0 en caso de éxito.

Ejemplo:

```c
#include <stdlib.h>
#include <stdio.h>
#include <readline/readline.h>
#include <readline/history.h>
#include <string.h>

int main(void)
{
	char *command_buff;

	while (1)
	{
		command_buff = readline("minishell> ");
		if (strlen(command_buff) > 0)
		{
			add_history(command_buff);
            rl_on_new_line(); // Preparamos la línea para la redisplay
            rl_redisplay();   // Redisplay de la línea de entrada
		}
		if (!strcmp(command_buff, "exit"))
		{
			rl_clear_history();
			free(command_buff);
			break;
		}
		free(command_buff);
	}
}
```

## rl_replace_line

El prototipo de la función `rl_replace_line` es el siguiente:

```c
int rl_replace_line(const char *text, int clear_undo);
```

### Descripción
- **Función**: `rl_replace_line` reemplaza el contenido actual de la línea de entrada con el texto proporcionado.
- **Parámetros**:
  - `text`: Un puntero a una cadena de caracteres que contiene el nuevo texto para la línea de entrada.
  - `clear_undo`: Un entero que indica si se debe borrar el historial de deshacer (`1` para borrar, `0` para no borrar).
- **Uso común**: Se utiliza cuando se necesita reemplazar completamente la línea de entrada actual con un nuevo texto.
- **Retorno**: Devuelve `0` en caso de éxito.

### Ejemplo de uso

```c
#include <stdlib.h>
#include <stdio.h>
#include <readline/readline.h>
#include <readline/history.h>
#include <string.h>

int main(void)
{
    char *command_buff;

    while (1)
    {
        command_buff = readline("minishell> ");
        if (strlen(command_buff) > 0)
        {
            add_history(command_buff);
            // Reemplazamos la línea de entrada con un nuevo texto
            rl_replace_line("Nuevo comando", 0);
            rl_on_new_line(); // Preparamos la línea para la redisplay
            rl_redisplay();   // Redisplay de la línea de entrada
        }
        if (!strcmp(command_buff, "exit"))
        {
            rl_clear_history();
            free(command_buff);
            break;
        }
        free(command_buff);
    }
    return 0;
}
```

En este ejemplo, después de agregar un comando al historial, `rl_replace_line` reemplaza la línea de entrada actual con el texto "Nuevo comando". Luego, `rl_on_new_line` prepara la línea para la redisplay y `rl_redisplay` actualiza la visualización de la línea de entrada en la terminal.