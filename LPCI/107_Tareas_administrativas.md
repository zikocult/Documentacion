
## **1. Cuentas de usuarios**

Usamos el comando **useradd** para añadir usuarios. 

Parámetros de useradd:


| Parámetro         | Descripción                                                                                             |
| ----------------- | ------------------------------------------------------------------------------------------------------- |
| -c comentario     | suele ser el nombre entero                                                                              |
| -d directorio     | ruta del home                                                                                           |
| -g grupo          | grupo inicial ya existente (GID)                                                                        |
| -G grupo1, grupo2 | para añadir mas grupos                                                                                  |
| -u UID            | el user id del usuario                                                                                  |
| -s shell          | shell estandar para el usuario (puede ser modificada posteriormente con chsh)                           |
| -p "contraseña"   | podemos comabiar la clave con passwd usuario, si se usa sin argumento se modifica la del usuario actual |
| -e fecha          | fecha hasta la que la cuenta estará activa                                                              |
| -k /etc/skel      | copia de la home modelo de /etc/skel para poder personalizar la home                                    |
| -m                | crea la home si no existe                                                                                                        |

También se puede usar **adduser**, este segundo es un script que hace algunas cosas automáticas, podemos definir los valores de creación en /etc/adduser.conf.

Con **chfm** puedes cambiar a descripción del usuario.

Los usuarios pueden usar también passwd, chsh y chfn para cambiar sus datos.

Con **userdel nombre_usuario** borramos el usuario, si le añadimos el parámetro -r nos aseguramos de que se borre también su home.

La información de los usuarios del sistema se almacena en **/etc/passwd** en el siguiente formato:

```
Nombre del login:pw almacenada en /etc/shadow:UID:GID:Descripción:home:shell
```

El fomato de **/etc/shadow **es el siguiente:

- Nombre del login
- pass encripatada en 13 caracteres 
	- En blanco no necesita pass 
	- Con * está bloqueada
- Número de días desde 01/01/1970 que se cambio la password
- Número de días necesario hasta que la pass se pueda modificar (0 no necesita tiempo)
- Número de días después del cual debe modificar la contraseña (por defecto 99999 o 274 años)
- Número de días para informar al usuario de la caducidad de la pass
- Número de días después de la expliración de la cuenta hasta que se bloquee
- Número de días a partir de 01/01/1970 desde que se bloqueó la cuenta
- Campo reservado

Comando **chage**, con él se puede modificar la validez de la contraseña, opciones:

| Parámetro | Descripción                                                                                      |
| --------- | ------------------------------------------------------------------------------------------------ |
| -m días   | mínimo de días hasta que el user pueda cambiar a contraseña modificada                           |
| -M días   | máximo de días en el cual la contraseña permanecerá válida                                       |
| -d días   | número de días transcurridos entre que se cambió la pass y el 01/01/1970                         |
| -E días   | número de días transcurridos a partir del cual está desactiva desde el 01/01/1970                |
| -l días   | número de días de tolerancia después de que la cuenta se desactive para que se bloquee la cuenta |
| -W días   | número de días antes de que caduque la contraseña en la que se mostrará un aviso de caducidad    |

Todos los usarios pueden usar el siguiente comando para ver las restricciones de usuario:

```bash
chage -l <nombre_usuario>
```

Usaremos el comando **usermod** para modificar una cuenta creada, viene con los siguientes parámetros:

| Parámetro         | Descripción                                                                                                                                                |
| ----------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------- |
| -c descripción    | descripción del usuario                                                                                                                                    |
| -d directorio     | modifica la home, si añadimos el argumento -m también mueve el contenido de la home actual                                                                 |
| -e valor          | plazo de validez de la cuenta en formato dd/mm/aaaa                                                                                                        |
| -f valor          | nº de días después de que la contraseña expiró hasta que se bloquee. Con -1 cancelamos esta opción                                                         |
| -g grupo          | grupo efectivo del usuario                                                                                                                                 |
| -G grupo1, grupo2 | grupos adicionales del usuario                                                                                                                             |
| -l nombre         | nombre del login                                                                                                                                           |
| -p contraseña     | contraseña                                                                                                                                                 |
| -u UID            | número de identificación del usuario UID                                                                                                                   |
| -s shell          | shell estandar del usuario                                                                                                                                 |
| -L usuario        | bloquea la cuenta del usuario con ! delante de la contraseña. Como alternativa podemos cambiarle el shell estandard por un script que informe del bloqueo. |
| -U usuario        | desbloquea la cuenta de usuario borrando el !.                                                                                                             |

## **2. Grupos de usuarios**

Usamos **groupadd** para la creación de grupos de usuarios, con el parámetro -g podemos especificar el GID.

Para eliminar un grupo usamos **groupdel nombre**

Para añadir/eliminar usuarios a un grupo usamos **gpasswd** con los siguientes parámetros:

| Parámetro        | Descripción                                    |
| ---------------- | ---------------------------------------------- |
| gpasswd grupo    | crea contraseña a todo el grupo                |
| -r grupo         | borra a contraseña del grupo                   |
| -a usuario grupo | asocia un usuario a un grupo                   |
| -d usuario grupo | saca un usuario de un grupo                    |
| -A usuario grupo | convierte un usuario en administrador de grupo |

Un usuario puede permanecer en mas de un grupo. Para mostrar os grupos a los que pertenece un usuario podemos usar:

```bash
groups <usuario>
```

Con el comando **id** podemos ver los grupos de usuario con el GID correspondiente.

El comando **newgrp** se usa para modificar el grupo efectivo del usuario en una nueva sesión de login.

La información de los grupos se almacena en /etc/grupo en el siguiente formato:

- Nombre del grupo
- Contraseña del grupo (x si se usa /etc/gshadow)
- GID
- Miembros del grupo separados por coma.

Con el comando **groupmod** se pude también modificar grupos con estas opciones:

| parámetros | Descripción                  |
| ---------- | ---------------------------- |
| -g GID     | modificar el GID             |
| -n nombre  | modifica el nombre del grupo |

## 3. Automatizar y programar tareas

#### **at**
Se usa para programar una ejecución única.

Los usuarios normales pueden usarlo si constan en el archivo /etc/at.allow, si no existe se consultará el /etc/at.deny y se bloqueará a los que consten en él, pero si ninguno de los dos archivos existe, sólo root puede usar at.

Su sintaxis es:
```bash
at <cuando> <comando>
```

Las opciones del cuando, pueden ser now, midnight, pero las opciones deberían revisarse en /usr/share/doc/at/timespec

Para verificar si hay tareas pendientes usamos **at -l** o **atq**

#### **cron**

Este lo usaremos para ejecutar una tarea d intervalos, cada minuto el daemon crond lee las crontabs (tablas de tareas) para ver si hay alguna tarea a ejecutar.

El crontab general lo encontraremos en **/etc/crontab**, no deberíamos editarlo directamente, la programación se realiza a través del comando **crontab**

Opciones crontab:

| Parámetros | Descripción                                   |
| ---------- | --------------------------------------------- |
| -l usuario | muestra las tareas programadas por el usuario |
| -e usuario | edita el crontab en el editar estándar        |
| -d usuario | borra el crontab del usuario                  |

Si no suministramos el usuario, se entiende que se trata del usuario actual.

**Formalo**

```bash
0-59(Min) 0-23(Hora) 0-31(Dia) 1-12(Mes) 0-6(Día semana) comando
```

Diferentes variantes

- Uso guión "-" entre dos números, delimita un periodo de ejecución
- La coma "," delimita uno y otro.
- El carácter "\*" se ejecutará a cada momento del intervalo
- El uso de "/" estableces un paso de ejecución (\*/4 cada 4 horas)

Ejemplo:

```
Lo siguiente ejecuta cada 4 horas de martes a sábado los meses de Mayo y Junio
* */4 5,6 1-5 /usr/local/bin/script 
```

Si la tarea produce alguna salida se enviará a la caja de entrada del usuario, pero podemos evitar eso redireccionando a /dev/null o a un archivo.

Controlamos el uso de crontab mirando en los archivos */etc/cron.allow y /etc/cron.deny*. Si no existe ninguno de los archivos, TODOS los usuarios podrán programar tareas.

## 4. Localización e internaciionalización

**Huso horario**: Va en relación a GMT dependiendo del país. Se recomienda usar en la bios GMT +0.
Para informar al sistemas del huso horario deseado usamos **tzselect** y después de seleccionar el deseado, se crea el archivo **/etc/timezone** con los datos de la zona. También se crea **/etc/localtime** para las horas.

Todos los archivos de huso horario se encuentra en **/usr/share/zoneinfo**.

**Idioma y codificación**: La configuración básica de localización se realiza con la variable de entorno **LANG** y a partir de esta los programas predefinen su idioma. Esta variable está en formato de ab_CD, donde ab es el idioma y CD es la codificación (es.UTF-8).

Para convertir textos entre diferentes codificaciones usamos:

```bash
iconv -f iso-8859-1 -t utf-8 txtoriginal txtsalida.
```

Además de LANG se usan las siguientes variables:

- LC_COLLATE: define el orden alfabético
- LC_CTYPE: define como el sistema trata ciertos carácteres.
- LC_MESSAGES: definición de idioma de los avisos emitidos por los programas.
- LC_MONETARY: define la moneda y su formato.
- LC_NUMERIC: formato numérico de los valores no monetarios
- LC_TIME: formato fecha y hora
- LC_PAPER: tamaño estándar del papel
- LC_ALL: superpone todas las demás variables

**Opciones de idiomas en scripts**: en los scripts definimos la variable **LANG=C** para que el script no produzca resultados diferentes si la localización fuera distinta a aquela donde se escribió.