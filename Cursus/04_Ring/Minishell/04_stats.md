- [[#Introducción]]
- [[#stat]]
- [[#lstat]]
- [[#fstat]]
## Introducción

`stat`, `fstat` y `lstat` están vinculados entre si, con lo que supongo que haré una sola explicación y ejemplo de todos, sus diferencias son sutiles, pues fstat lee un file descriptor y lstat un link.

Estas funciones devuelven el estado de un fichero.

Todas ellas están en la librería `<sys/stat.h>`, a mi me ha venido preinstalada en sistemas Fedora y Arch Linux.

> **Importante**: la estructura stat, que definiremos como variable.

La estructura contiene los siguientes campos (no he encontrado info de todos los campos, pongo los que tengo e iré actualizando).

- *st_atim* - Último acceso al fichero
- *st_mtim* - Última modificación
- *st_mode* - Los permisos del fichero
- *st_nlink* - El número de links que hay de este fichero
- *st_rdev*
- *st_size* - Tamaño del fichero
- *st_ino* - El inodo del fichero 
- *st_dev* - El dispositivo dónde reside el fichero
- *st_blksize* - Tamaño del bloque
- *st_gid* - Group ID del fichero
- *st_blocks*
- *st_ctime* - el cambio mas reciente de permisos
- *st_uid* - User ID del fichero
## stat

Su prototipo es:

```c
int stat(const char *path, struct stat *buf);
```

Siendo la estructura \*buf la estructura **stat**, que definiremos con el nombre que consideremos para poder acceder a ella.

Pondré en primer lugar un ejemplo pequeño, para una mas fácil comprensión:

```c
#include <sys/stat.h>
#include <stdio.h>

int main (void)
{
	char *file = "a.out"; //Aquí podemos poner el fichero que queramos
	struct stat buf;
	
	if(stat(file, &buf) == 0)
		printf("Size of \"%s\" is %ld bytes.\n", file, buf.st_size);
	else
		perror(file);
}
```

Como podemos observar, la información viene dada dentro de la estructura stat, que he definido en este caso como buf y llego al valor que necesito en el campo `st_size`.

Ahora vamos a incrementar con un ejemplo mas pesado, dónde veremos una nueva estructura y alguna aplicación de alguna nueva opción dentro de la estructura stat:

```c
#include <stdio.h>
#include <unistd.h>
#include <sys/stat.h>
#include <time.h>

void printFileProperties(struct stat stats)
{
	struct tm dt;

	// File permissions
	printf("\nFile access: ");
	if (stats.st_mode & R_OK)
		printf("read ");
	if (stats.st_mode & W_OK)
		printf("write ");
	if (stats.st_mode & X_OK)
		printf("execute");

	printf("\nFile size: %ld", stats.st_size);

	dt = *(gmtime(&stats.st_ctime));
	printf("\nCreated on: %d-%d-%d %d:%d:%d", dt.tm_mday, dt.tm_mon, dt.tm_year + 1900, 
		dt.tm_hour, dt.tm_min, dt.tm_sec);

	dt = *(gmtime(&stats.st_mtime));
	printf("\nModified on: %d-%d-%d %d:%d:%d", dt.tm_mday, dt.tm_mon, dt.tm_year + 1900, 
		dt.tm_hour, dt.tm_min, dt.tm_sec);

}

int main(void)
{
    char path[100];
    struct stat stats;

    printf("Enter source file path: ");
    scanf("%s", path);

    if (stat(path, &stats) == 0)
        printFileProperties(stats);
    else
    {
        printf("Unable to get file properties.\n");
        printf("Please check whether '%s' file exists.\n", path);
    }
    return 0;
}
```

>Aquí podemos notar que tenemos una nueva estructura en la función `printFileProperties`, corresponde *time.h* y es para poder poner formato, así que no lo tendremos muy en cuenta de momento, pero la dejo anotada, por si en un futuro la quisieramos usar en otros proyectos.

> Si revisamos con detalle la función, veremos que lo que hemos hecho es pasarle la función *gtime* a *dt* para que coja los datos con formato, esta función no la tenemos, con lo que **NO** la podremos usar jamás en el proyecto, a la siguiente linea me refiero:

```c
dt = *(gmtime(&stats.st_ctime));
```

## lstat

> Es exactamente igual que stat en todo, a excepción que el pathname es un link simbólico y nos devolverá la información del link, no al fichero que referencia.

Prototipo:

```c
int lstat(const char *restrict pathname, struct stat *restrict statbuf);
```

## fstat

> Volvemos a encontrar que es exactamente lo mismo, pero con la excepción de que en este caso, no buscaremos el fichero por el pathname, si no por un **File Descriptor** que tengamos abierto y nos devolverá la info del fichero en si.

Prototipo:

```c
int fstat(int fd, struct stat *statbuf);
```