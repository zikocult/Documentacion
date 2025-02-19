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
