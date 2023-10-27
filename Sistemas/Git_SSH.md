
- [GIT](#GIT)
- [SSH para Git](#SSH)
- [OpenSSH](#OpenSSH)
- [Control de flujos](#Flujos)

## GIT

- **git add .**
> añade todo lo que haya cambiado
> es sustituible el . por los archivos que consideremos

- **git status**
> Así sabemos lo que tenemos preparado para el commit
> Con --ignored, veremos lo que tengamos ignorado por .gitignore

- **git commit -m "Descripción"**
> Con esto hacemos el commit en local

- **git push -u origin mai**
> Aquí ya subimos todo a Git y dejamos preparado para el siguiente

- **git pull**
> Con esto actualizaremos el repositorio local que tengamos de git

- **git clone** 
> Volcamos TODO el repositorio a local

## SSH

- **ssh-keygen -t ed25519 -C "example@domain"**
> Crea la llave publica y privada necesaria, no es necesario mas que subir la publica al perfil y ya funcionaría correctamente

 - **eval $(ssh-agent -s)**
 > Abre un agente para almacenar las credenciales
 
 - **ssh-add ~/.ssh/id_ed25519**
 > Añadimos al agente las credenciales de nuestra clave (como hemos comentado, no necesario)
 
## OpenSSH

Això es el software que faria de servidor SSH, aquí només un apunt, que seria la manera de autoritzar un certificat ja creat.

Bàsicament seria col·locar la clau pública a la ruta del servidor:

```
A la home de l'usuari amb el que estem entrant

~/.ssh/authorized_keys
```

## Flujos

![Git movimiento](https://blog.kakaocdn.net/dn/czCklr/btq5FVUCu4F/RZUL5c61Rp5M6DNbWr70d1/img.png)

&nbsp;

![Gitflow](https://lh3.googleusercontent.com/lcsh5tttqke-3dhcj0Qy3lcnm4IevGU4YGq4irC-hK4bcCLmaJddmkRSEqtwou8gDaf-GQbQCY7xuH_LG2DpzFeSLbKK62Og58Ds-ep6SPJbvikAHcMO_HraMHjMQyIS4bSJCb337TX51qzlnjDZm-G9D412LaGx)



