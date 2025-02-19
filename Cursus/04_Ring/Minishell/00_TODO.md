
- [ ]  [[#Github]]
- [x] [[#Organización inicio]]
- [ ] [[#TODO actual para Guillem]]
	- [x] Parseo
	- [ ] ENV
	- [ ] Signals
	- [ ] Movimiento de directorios
- [ ] [[#Documentación por finalizar]]

## Github

- [x] Crear repositorio
- [x] Invitar a Patri al GitHub
- [x] Acabar de ver como se trabaja entre dos y con las ramas
- [x] Realizar alguna prueba
- [x] Crear rama desarrollo con toda la documentación ya acabada
- [ ] Aprender a usar la linea de comandos para los merge

>*Nota  para Guillem*: Debo leer todo lo referente a git branch y similares.

## Organización inicio

- [x] Estructura de carpetas, Makefile y Libft (se ha subido el de Guillem)
- [x] Organigrama y primeras ideas (Patri)
- [x] Siguiente reunión el *martes 26 por la tarde, después de comer
- [x] Siguiente reunión a concretar por falta de fechas.
	- [x] Queda saber los nuevos horarios de Patri, yo la semana que viene estaré por las tardes en el Hackaton de Mataró
- [x] Este es un video interesante, crea una shell de 0, aunque con otras funciones, nos dará ideas de como parsear... el [video](https://www.youtube.com/watch?v=yTR00r8vBH8)

## TODO actual para Guillem

- [ ] **PARSEO**
	- [ ] No se ha anotado todo lo realizado en el parseo, aunque faltan un par de cosas por completar, las iré anotando según sea necesario en este punto.
		- [ ] Controlar la entrada de carácteres invisibles (saltos de linea, tabulación, etc)
	- [x] Hay que revisar las entradas con *'* y *"*, per ejemplo una entrada com *" ' $USER " '* tendria que dar error.
	- [x] Incluir lo anterior en el *validation_parse*
- [ ] **ENV_builtin**
	- [ ] Entrada para nueva variable:
		- [ ] Separación de la entrada de comando *a=a* por ejemplo, para realizar la asignación, va ligado al siguiente punto, pero en este caso tenemos que revisar.
		- [ ] La revisión la quiero realizar con una función que revise el comando y que dicho comando tenga "*variable=contenido*"
		- [ ] Anotar que es un error que la variable sea *"numero=contenido*
		- [x] No me hace bien el crear una nueva entrada en la tabla, hay que revisar con cuidado.
	- [x] Unset
		- [x] Problemas con la primera posición, se debe validar
		- [x] Asignar el head_env también si es necesario.
	- [ ] Set (un poco mas complejo que lo anterior)
		- [ ] Revisar como dejar la variable dentro de la tabla, creo que sólo puede haber una linea por set guardado
		- [ ] Separar la linea por espacios, teniendo claro que 1 es toda la linea y las siguientes, pues cada palabra.
	- [ ] Export
		- [ ] Mirar que hace y como lo hace, lo tengo claro en scripts
- [ ] **Signals**
	- [ ] Empezar al acabar con **ENV**
- [ ] **CD_builtin y movimientos por directorio**
	- [ ] Empezar al acabar con **signals**
## Documentación por finalizar

[Indice de la documentación generada](01_Indice.md)
- [ ] **Funciones a documentar**
	- [x] readline
	- [x] rl_clear_history
	- [x] add_history
	- [x] rl_clear_history
	- [x] rl_on_new_line
	- [x] rl_redisplay
	- [x] rl_replace_line
	- [x] getcwd
	- [x] chdir 
	- [x] stat 
	- [x] lstat
	- [x] fstat
	- [x] opendir
	- [x] readdir
	- [x] closedir
	- [x] isatty
	- [x] ttyname
	- [x] ttyslot
	- [ ] ioctl
	- [ ] getenv
	- [ ] tcsetattr
	- [ ] tcgetattr
	- [ ] tgetent
	- [ ] tgetflag
	- [ ] tgetnum
	- [ ] tgetstr
	- [ ] tgoto
	- [ ] tputs

- [ ] **Funciones que probablemente documente**
	- [ ] wait
	- [ ] waitpid
	- [ ] wait3
	- [ ] wait4
- [x] **Funciones que considero ya sabemos y no documentaré**
	- [x] printf
	- [x] malloc
	- [x] free
	- [x] write
	- [x] access
	- [x] open
	- [x] read
	- [x] close
	- [x] fork
	- [x] signal
	- [x] sigaction
	- [x] kill
	- [x] exit
	- [x] unlink

