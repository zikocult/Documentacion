- [Funciones principales a usar](###Funciones_principales)
	- [Dup2](####dup2)
	- [Acces](####acces)
	- [Execve](####execve)
	- [Fork](####fork)
	- [Pipe](####pipe)
	- [Ulink](####ulink)
	- [Wait](####wait)
	
- [The program](###The_program)
	- [Parsing](####Parsing)


Los principales conceptos que deberemos manejar en este proyecto son:
- Pipelines
- Child processes
- Execution of commands

### Funciones_principales:

#### **dup2** 

Reemplaza la salida standar de un fd a stdin, stdout o stderr, en el ejemplo que muestro, printf no mandará a stdout y ser visualizará por pantalla si no que lo enviará al fichero.

```c
#include <stdio.h>
#include <fcntl.h> //open() & close() 
#include <unistd.h> //dup2()
 
int main()
{
	int fd;
 
	fd = open("example.txt", O_WRONLY | O_CREAT, 0644);
	dup2(fd, STDOUT_FILENO);
	close(fd);
	printf("This is printed in example.txt!\n");
 
	return (0);
}
```

#### **acces**

Chequea que un proceso tenga acceso a un fichero o directorio, tiene 3 modos:
- R_OK (read)
- W_OK (write)
- X_OK (execution)

Los permisos chequeados son los del propio sistema en si (CHMOD), vamos a poner un ejemplo:

```c
#include <stdio.h>
#include <unistd.h> //acces()
 
int main()
{
	if (access("example.txt", R_OK) != -1)
		printf("I have permission\n");
	else
		printf("I don't have permission\n");
 
	return (0);
}
```

#### **execve**

Es una llamada de systema, que permite ejecutar programas dentro de tu programa, reemplaza el actual proceso, con un nuevo proceso. 

Toma tres argumentos:
- El path del programa al completo
- Un array de argumentos de la linea de comandos
- Un array de las variables de entorno

Como siempre, vamos a poner un ejemplo (no uso int argc, char \*\*argv, para que el ejemplo sea mas fácilmente leíble):

```c
#include <unistd.h> //execve
#include <stdio.h>
 
int main()
{
	char *args[3];
 
	args[0] = "ls";
	args[1] = "-l";
	args[2] = NULL;
	execve("/bin/ls", args, NULL);
	printf("This line will not be executed.\n");
 
	return (0);
}
```

Como podemos ver, args contiene la linea de comandos que vamos a pasar a ls y debemos llamas a ls mediante el path completo.

*args[0]* no realiza la llamada, ni se acumula, es simplemente un identificador para saber que comando necesitamos, el comando que ejecutaremos es el que ponemos en el path, si cambio el código a lo siguiente, se seguirá ejecutando exactamente igual que anteriormente:

```c
#include <unistd.h> //execve()
#include <stdio.h>
 
int main()
{
	char *args[3];
 
	args[0] = "RASPUTIN";
	args[1] = "-l";
	args[2] = NULL;
	execve("/bin/ls", args, NULL);
	printf("This line will not be executed.\n");
 
	return (0);
}
```

#### **fork**

Es una llamada de sistema que crea un nuevo proceso duplicando la llamada a un proceso, el nuevo proceso es conocido como proceso hijo (child process), mientras que el proceso original es conocido como el proceso padre (parent process).

Después del fork, los dos procesos ejecutan el mismo código, pero en separadas zonas de memoria.

Ejemplo de creación de un proceso hijo (también usaré la función getpid() para ver los procesos del sistema):

```c
#include <stdio.h>
#include <stdlib.h> //perror
#include <unistd.h> //getpid() & fork() & exit
 
int main()
{
	pid_t pid;
 
	pid = fork();
	if (pid == -1)
	{
		perror("fork");
		exit(EXIT_FAILURE);
	}
 
	if (pid == 0)
		printf("This is the child process. (pid: %d)\n", getpid());
	else
		printf("This is the parent process. (pid: %d)\n", getpid());
 
	return (0);
}
```

#### **pipe**

Crea un canal unidireccional de información que es usado para la comunicación de interprocesos. La información escrita en una pipe, puede ser leída por otro fin de pipe.

Los pipes son normalmente usados conjuntamente con fork, para crear comunicación entre canales de procesos hijo y padre.

```c
#include <stdio.h>
#include <stdlib.h> // write() & perror() & close()
#include <unistd.h> //pipe() && fork()
 
int main()
{
	int fd[2];
	pid_t pid;
	char buffer[13];
 
	if (pipe(fd) == -1)
	{
		perror("pipe");
		exit(EXIT_FAILURE);
	}
 
	pid = fork();
	if (pid == -1)
	{
		perror("fork");
		exit(EXIT_FAILURE);
	}
 
	if (pid == 0)
	{
		close(fd[0]); // close the read end of the pipe
		write(fd[1], "Hello parent!", 13);
		close(fd[1]); // close the write end of the pipe
		exit(EXIT_SUCCESS);
	}
	else
	{
		close(fd[1]); // close the write end of the pipe
		read(fd[0], buffer, 13);
		close(fd[0]); // close the read end of the pipe
		printf("Message from child: '%s'\n", buffer);
		exit(EXIT_SUCCESS);
	}
}
```

#### **ulink**

Borra un fichero del sistema, sólo necesita el path del fichero para borrarlo, como siempre, un ejemplo simple:

```c
#include <stdio.h>
#include <unistd.h> //ulink()
 
int main()
{
	if (unlink("example.txt") == 0)
		printf("File successfully deleted");
	else
		printf("Error deleting file");
 
	return (0);
}
```

#### **wait**

Para la ejecución del proceso actual, hasta que el proceso hijo termina.

El ejemplo, para 2 segundos la ejecución del proceso hijo, desde que termina.

```c
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/wait.h>
 
int main(void)
{
	pid_t pid;
 
	pid = fork();
	if (pid == -1)
	{
		perror("fork");
		exit(EXIT_FAILURE);
	}
	else if (pid == 0)
	{
		printf("I am the child process.\n");
		sleep(2);
		exit(EXIT_SUCCESS);
	}
	else
	{
		printf("I am the parent process.\n");
		wait(NULL);
		printf("Child process terminated after a 2s delay.\n");
	}
 
	return (EXIT_SUCCESS);
}
```


### The_program

#### **Parsing**

Necesitas crear un input correcto y como manejar la información no esperada, esto incluye el manejar *'here_doc'*, abrir el fichero *'infile'* y *'outfile'* y si es necesario, salir del programa (cosa que incluye cerrar todo los FDs abiertos, librear la memoria y usar ulink para remover todos los temprales de *'here_doc'*)

La función similar debe tener un aspecto similar a:

```c
main()
{
	ft_init_pipex()
	ft_check_args()
	ft_parse_cmds()
	ft_parse_args()
	while (cmds)
		ft_exec()
	ft_cleanup()
}
```

- *ft_init_pipex* -> será usado para rellenar nuestra estructura con la información por defecto.
- *ft_check_args* -> simplemente abrirá todos los ficheros que necesite manejar *here_doc* como */dev/urandom*, será necesario crear un *get next line* customizado para completarlo.
