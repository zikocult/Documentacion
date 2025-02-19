- [[#getcwd]]
- [[#chdir]]
- [[#opendir]]
- [[#readdir]]
- [[#closedir]]
## getcwd

Una función simple que nos devuelve el path de trabajo actual. 

Su prototipo es:

```c
 **char *getcwd(char** _buf_**[.**_size_**], size_t** _size_**);**
```

Y un ejemplo de uso:

```c
#include <unistd.h>
#include <stdio.h>
#include <linux/limits.h>

int main() {
   char cwd[PATH_MAX];
   if (getcwd(cwd, sizeof(cwd)) != NULL) {
       printf("Current working dir: %s\n", cwd);
   } else {
       perror("getcwd() error");
       return 1;
   }
   return 0;
}
```

Este sería el output que genera el ejemplo:

![[Pasted image 20241127123251.png]]

## chdir

Con esta función podemos cambiar el actual directorio de trabajo llamando al proceso del directorio especificado en el `path`.

Su prototipo es:

```c
**#include <unistd.h>**

**int chdir(const char ***_path_**);**
```

Retornará 0 en caso de que el cambio sea OK y -1 si ha fallado.

Un ejemplo de uso (incremento el ejemplo anterior para mas visibilidad):

```c
#include <unistd.h>
#include <stdio.h>
#include <linux/limits.h>

int main() {
	char cwd[PATH_MAX];

	if (getcwd(cwd, sizeof(cwd)) != NULL) {
		printf("Current working dir: %s\n", cwd);
	} else {
		perror("getcwd() error");
		return 1;	
	}

	if (chdir("/home/ziko/") < 0)
		printf("Error changing directory\n");
	else
		printf("Directory change OK\n");

	if (getcwd(cwd, sizeof(cwd)) != NULL) {
		printf("Current working dir: %s\n", cwd);
	} else {
		perror("getcwd() error");
		return 1;	
	}
	return 0;
}
```

Y este sería el output que me generaría:

![[Pasted image 20241127125032.png]]

> Nótese que después de la ejecución del programa, sigo en mi directorio de trabajo, sólo cambia para el trabajo del propio programa, no para la bash que estemos usando en ese momento, es decir, no sirve para ordenar a bash cambios de directorios, si no que es una temporalidad durante la ejecución del programa.

## opendir

Agrego link a una buena explicación [aquí](https://medium.com/@noransaber685/exploring-directory-operations-opendir-readdir-and-closedir-system-calls-a8fb1b6e67bb), en esta página explican *opendir*, *readdir* y *closedir*

Opendir se trata de una función que abre el flujo de el path de un directorio y devuelve un puntero al flujo del directorio. El flujo se posiciona en la primera posición de 

El prototipo de la función sería:

```c
#include <sys/types.h>
#include <dirent.h>

DIR *opendir(const char *name);
```

Vamos a diseccionar el prototipo

| Parámetro | Explicación                                                                                                                                |
| --------- | ------------------------------------------------------------------------------------------------------------------------------------------ |
| DIR       | Es una estructura que representa el flujo del directorio, lo usamos para leer las entradas del directorio, se declarará contra un puntero. |
| \*opendir | la función en si misma, simplemente la llamada                                                                                             |
| \*name    | es el nombre del directorio, se le envía como parámetro.                                                                                   |
Añado el ejemplo mas sencillo, aunque añade las otras funcionalidades:

```c
#include <stdio.h> 
#include <dirent.h> 
  
int main(void) 
{ 
    struct dirent *de;  // Pointer for directory entry 
  
    // opendir() returns a pointer of DIR type.  
    DIR *dr;
	dr = opendir("/home/ziko/"); 
  
    if (dr == NULL)  // opendir returns NULL if couldn't open directory 
    { 
        printf("Could not open current directory" ); 
        return 0; 
    } 
  
    // Refer http://pubs.opengroup.org/onlinepubs/7990989775/xsh/readdir.html 
    // for readdir() 
    while ((de = readdir(dr)) != NULL) 
            printf("%s\n", de->d_name); 
  
    closedir(dr);     
    return 0; 
} 
```

> La estructura la usaremos mas adelante con readdir, ahora simplemente hemos abierto el directorio, es decir, como el open de los ficheros, ahora vamos a trabajar con el directorio en el siguiente apartado.


## readdir

Con esta función y ya el puntero abierto al directorio (abierto con opendir), podremos interactuar con él con la función readdir y la estructura `dirent`

El prototipo de la función vendría a ser:

```c
#include <dirent.h>

struct dirent *readdir(DIR *dirp);
```

Como vemos, el parámetro que le tenemos que pasar es la variable DIR generada anteriormente y opendir lo almacenará en la estructura `dirent`

Esta es la forma de la estructura:

```c
struct dirent {
    ino_t          d_ino;       /* Inode number */
    off_t          d_off;       /* Not an offset; see below */
    unsigned short d_reclen;    /* Length of this record */
	unsigned char  d_type;      /* Type of file; not supported
	                                              by all filesystem types */     
	char           d_name[256]; /* Null-terminated filename */
};
```

| variable | descripción                                                                                                                           |
| -------- | ------------------------------------------------------------------------------------------------------------------------------------- |
| d_ino    | es el número de inode del fichero                                                                                                     |
| d_off    | es una implementación de [telldir()](https://www.man7.org/linux/man-pages/man3/telldir.3.html), ya no se usa en los sistemas modernos |
| d_reclen | es el tamaño en bytes                                                                                                                 |
| d_name   | contiene el nombre del fichero                                                                                                        |
| d_type   | nos muestra el tipo de fichero que es, pero para ello, hay una codificación que paso enseguida  a anotar.                             |
**d_type** se divide en diferentes opciones que dan como resultado *un true o un false* que vendrían a ser:

| nombre    | descripción                                                |
| --------- | ---------------------------------------------------------- |
| DT_BLK    | si es un dispositivo de bloque                             |
| DT_CHR    | si es un dispositivo de carácter (este no lo he entendido) |
| DT_DIR    | si es un directorio                                        |
| DT_FIFO   | esto sería para identificar una pipe (FIFO)                |
| DT_LNK    | si se trata de un link simbólico                           |
| DT_REG    | un fichero regular                                         |
| DT_SOCK   | unix domain socket                                         |
| DT_UNKNOW | el tipo no puede ser determinado                           |
## closedir

Simplemente cierra el directorio, el antónimo de opendir, de la misma forma, funciona como el open y el close en los ficheros

Prototipo:

```c
#include <sys/types.h>
#include <dirent.h>

int closedir(DIR *dirp);
```

Voy a poner el ejemplo que muestran en la página que he mentado mas arriba y de dónde he sacado la mayoría de la info (a parte de como siempre [man7.org](https://man7.org), de dónde saco la mayoría de las funciones)

```c
#include <stdio.h> 
#include <dirent.h> 
  
int main(void) 
{ 
    struct dirent *read_dir;
    DIR *dir_ptr;

	dir_ptr = opendir("."); 
  
    if (dir_ptr == NULL)  // opendir returns NULL if couldn't open directory 
    { 
        printf("Could not open current directory" ); 
        return 1; 
    } 
	// este loop es para leer todo el directorio, pero se tendrá que 
	// poner separado, pues no podemos realizar asignaciones en el if
	while ((read_dir = readdir(dir_ptr)) != NULL)
	{
		if (read_dir->d_type == DT_REG)
			printf("FILE: %s\n", read_dir->d_name);
		else if (read_dir->d_type == DT_DIR)
			printf("DIR: %s\n", read_dir->d_name);
	}
    closedir(dir_ptr);     
    return 0; 
} 
```

El resultado ha sido tal que:

![[Pasted image 20241127190842.png]]