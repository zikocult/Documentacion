# Vamos a realizar la primera prueba grande
 

**Indice**

- [Inclusión código](#Inclusión_código)

- [Pruebas con tablas](#tablas)

- [Estilos](#Estilos)

   - [Cursiva](#General)

   - [Negrita](#General)

   - [Carácter subrayado](#General)

  -  [Listas con viñetas](#Listas)

  - [Listas numeradas](#Listas)

  -  [Citas en bloque](#Citas)

  - [Imágenes](#Imagen)

  - [Vínculos](#Vinculos)

  - [Imágenes](#Imagen)

  - [Línea de regla horizontal](#saltos)

  - [Salto de línea](#saltos)

- [Conclusiones](#Conclusiones)

## Inclusión_código


```C
#include <stdio.h>

int main(void)
{
printf("Hello world!\n");
return (0);
}

```

> Incluim el còdig mitjançant \```"nom llenguatge" i tancarem al final.

## Tablas

| Titulo     | Pagina | Comentario               |
| ---------- | ------ | ------------------------ |
| El quijote | 1230   | En un lugar de la mancha |
| Fahrenheit | 509    | A quemar libros          |

> Com es pot veure es molt senzill, es simplement el us de la capçalera i a partir d'aquí ja pots jugar a cada camp separat per "|", la escriptura seria:

~~~

|Título |Número|Comentario |

|----------|------|------------------------|

|El quijote| 2432|En un lugar de la mancha|

|Fahrenheit| 3567|A quemar libros |

~~~

  

> Per a posar el còdig es pot fer dins un blog posant \~~~ i tancant-los o simplement posant \ abans de cada còdig MD

  

## Estilos

### General

| Formato           | Codigo                    | Texto                   |
| ----------------- | ------------------------- | ----------------------- |
| Cursiva           | \*cursiva* \_cursiva_     | *cursiva* _cursiva_     |
| Negrita           | \**Negrita** \__Negrita__ | **Negrita** __Negrita__ |
| Negrita + Cursiva | Con tres * Negricursiva   | ***Negricursiva***      |
| Subrayado         | \==Subrayado==            | ==Subrayado==          |                           |                         |
 

### Listas

- Viñeta uno

- Viñeta dos

- Viñeta anidada

- Anidando mas

~~~

Se puede realizar también con *

- Viñeta uno

- Viñeta dos

- Viñeta anidada

- Anidando mas

~~~

1. Paso uno

2. Paso dos

3. Paso tres

3.1 Paso 3 anidado

3.2 Paso 3 anidado

4. Volvemos

~~~

No importa el número que pongas

1. Paso uno

2. Paso dos

3. Paso tres

3.1 Paso 3 anidado

3.2 Paso 3 anidado

4. Volvemos

~~~

  

### Citas

> **Cita**: Aquí tenemos un *ejemplo* de cita en bloque

~~~

Se inicia con > y se sigue escribiendo el formato que se desee

> **Cita**: Aquí tenemos un ejemplo de cita en bloque

~~~

El còdig l'he explicat just al primer punt, així que no ho repetiré aquí

  

### Vínculos

[Vamos a dar caña](https://es.wikipedia.org/wiki/Pesca)

~~~

Con esto vemos como ponemos un nombre al enlace.

[Vamos a dar caña](https://es.wikipedia.org/wiki/Pesca)

~~~

  

[![Vamos a dar caña](https://www.designevo.com/media/header/images/designevo-logo.png)](https://es.wikipedia.org/wiki/Pesca)

  

~~~

Posem un logo que es l'enllaç en si

[![Vamos a dar caña](https://www.designevo.com/media/header/images/designevo-logo.png)](https://es.wikipedia.org/wiki/Pesca)

~~~

  

### Imagen

![Foto árbol](https://as1.ftcdn.net/v2/jpg/06/16/93/60/1000_F_616936001_7VGf9Seetx1UGvKlYUUImu2zhBjH5YSY.jpg)

~~~

Important el punt d'exclamació per a que es previsualitzi

![Foto árbol](https://as1.ftcdn.net/v2/jpg/06/16/93/60/1000_F_616936001_7VGf9Seetx1UGvKlYUUImu2zhBjH5YSY.jpg)

~~~

  

### Saltos

  

Línea 1

&nbsp;

Línea 2

&nbsp;

  

~~~

Així podem afegir salts de linea, s'ha d'afegir dos espais abans

Línea 1

&nbsp;

Línea 2

&nbsp;

~~~

---

***

___

  

~~~

Amb això podem posar un separador

---

***

___

~~~

  

## Conclusiones:

- Ya funciona el menú, pero me gustaría poder elegir la etiqueta.
- Hay algunas funciones que no funcionan en todos los editores
- Como inicio está muy bien