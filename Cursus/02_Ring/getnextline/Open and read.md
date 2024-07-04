Para que ambas funciones funcionen, es necesario añadir la librería **<fcntl.h>** 

#### Open ()

Una función simple que sirve para abrir un file descriptor (fd a partir de ahora), la llamamos según el siguiente prototipo

```c
int open (const char* path, int flags [, int mode]);
```

**Path**:  vendría a ser la dirección del fichero a abrir / crear, se debe realizar con rutas absolutas si no está en el directorio de trabajo.

**Flags**: Es el tipo de acceso que le queremos dar, vendrían a ser:
- *O_RDONLY*: abre el fichero en modo lectura sólo.
- *O_WRONLY*: abre el fichero en modo escritura sólo.
- *O_RDWR*:  abre el fichero en modo lectura y escritura
- *O_CREAT*: si el fichero especificado no existe en el path definido, lo crea.
- *O_EXCL*: previene la creación si el fichero ya existe en el directorio o localización.

**Return value**: el retorno es un fd, una pequeño y no negativo entero. Si existe algún error, la función devuelve -1.

Un pequeño ejemplo:

```c
int main()
{
    int fd;
    fd = open("text.txt", O_RDONLY);
}
```

#### Read ()

Prototipo de la función:

```c
ssize_t read(int fd, void *buf, size_t nbyte);
```

Esta función intenta leer nbytes de fd al buffer apuntado por buf. La función read () empieza a leer en la posición dada por el puntero asociado a fd, al final ese apuntador será incrementado por el número de bytes (nbytes) que haya leído.