- [[#Fstab]]

## Fstab

No es estrictamente necesaria, se trata de memoria virtual que es usada cuando nos quedamos sin memoria física, puede ser un disco, un volumen o un fichero.

Para monitorizar la swap, usaremos las siguientes herramientas:

```bash
free -h
swapon -s
```

Para determinar cuanta Swap es necesaria, podemos seguir la siguiente guía: [Ubuntu SwapFaq](https://help.ubuntu.com/community/SwapFaq).