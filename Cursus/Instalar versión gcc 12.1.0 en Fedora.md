>**NOTA IMPORTANTE**: durante mi instalación tipee mal el prefijo de configuración, con lo que en vez de 12.1.0, la carpeta que cree es la 12.0.1, simplemente cambiando el prefijo, ya se configurará todo correctamente.

### Obtención, configuración, compilación y uso

Necesitamos instalar esta versión, para que el comportamiento en casa y en 42 sea exactametne el mismo, pues las versiones que tenemos en casa, son superiores en todas las distros.

Primero que todo ubicarnos en alguna carpeta, dónde podamos almacenar la carpeta para compilar, donde se quiera, es sólo por orden, al final se podrá borrar si no se necesita.

Para ello, iremos a buscar la versión correcta y la descargaremos con `wget` con el siguiente comando

```bash
wget https://gcc.gnu.org/pub/gcc/releases/gcc-12.1.0/gcc-12.1.0.tar.gz
```

>Si no funciona el link, entrar y buscar la versión, a mi es el link que me ha funcionado, los que he encontrado en los buscadores no han servido

Descomprimir y entrar en la carpeta, easy as hell:

```bash
tar xzf gcc-12.1.0.tar.gz
cd gcc-12.1.0
```

Yo he tenido que instalar unos pocos componentes extra, sustituir dnf por apt si da problemas el siguiente paso, pero previamente a realizar el paso de la configuración y compilación, creo que está bien comprobar si los tenemos:

```bash
sudo dnf install gmp-devel mpfr-devel libmpc-devel
```

Ahora si, configuramos y compilamos, para ello, simplemente copiar el siguiente bloque de comandos:

```bash
mkdir build
cd build
../configure --prefix=/usr/local/gcc-12.0.1 --enable-languages=c,c++ --disable-multilib --program-suffix=-12
make -j$(nproc)
```

Y ahora la instalación de la versión compilada de gcc

```bash
sudo make install
```

Con el prefijo, lo he instalado en una carpeta en concreto, en este caso `/usr/local/gcc-12.0.1`, así que tenemos dos opciones:

- **Ejecución directamente con todo el path**: Esta opción tiene una ventaja sobre la siguiente y es que para nuestro sistema seguiremos usando la versión gcc mas moderna y podremos escoger usarla sólo bajo petición.

>Esto nos mostrará la versión y si realmente lo tenemos bien instalado con esta opción:

```bash
/usr/local/gcc-12.0.1/bin/gcc --version
```

- **Exportar el path a la variable $PATH del usuario**: esta opción sobreescribe la versión que tenemos actualmente por la versión que acabamos de instalar, con lo que todo nuestro sistema usará esta, yo recomiendo mas la anterior.

>Para ello deberemos editar el fichero *~/.bashrc* o *.~/zshrc* e incluir el siguiente comando (hago el ejemplo sobre bashrc):

```bash
echo 'export PATH=/usr/local/gcc-12.0.1/bin:$PATH' >> ~/.bashrc
source ~/.bashrc
```

>Si queremos probar el resultado, simplemente tipeando lo siguiente en el terminal, podremos hacer pruebas, cuando cerremos el terminal, la variable PATH quedará limpia y estaremos con la anterior versión.

```bash
export PATH=/usr/local/gcc-12.0.1/bin:$PATH
```

- **Tercera opción**: Yo la he probado y funciona, es un mixto de las dos anteriores, la añado, a mi no me acaba de gustar, pero si alguien quiere probar "up to you!", en este caso, lo que hago es todo el paso de la exportación del path, pero renombro el ejecutable a otro nombre que no sea gcc, con lo que mantendrá el compilador mas moderno como gcc y la versión antigua quedará como otro nombre dentro de PATH, voy a mostrar el comando de ejemplo:

```bash
sudo mv /usr/local/gcc-12.0.1/bin/gcc /usr/local/gcc-12.0.1/bin/gcc-12.1.0
```

### Makefile

Para el Makefile y poder usar las dos versiones correctamente, simplemente he dado una opción nueva a make, en este caso home, con lo que si haces make home, estarás compilando con la versión antigua.

Añado el parrafo del contenido dónde hago la modificación para que se vea correctamente.

```bash
home:		CC = /usr/local/gcc-12.0.1/bin/gcc
home:		all
```

De esta manera, sustituimos nuestra variable por el nuevo compilador y ya estamos compilando correctamente con la versión de nuestra preferencia.

### Resultado final

Con todo esto, muestro con un pantallazo el resultado final, dónde se pueden ver ambas versiones coexistiendo y siendo completamente funcionales.

![[Pasted image 20250509190305.png]]