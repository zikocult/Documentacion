#include <sys/stat.h>
#include <stdio.h>

int main (void)
{
	char *file = "a.out";
	struct stat buf;
	
	if(stat(file, &buf) == 0)
		printf("Size of \"%s\" is %ld bytes.\n", file, buf.st_size);
	else
		perror(file);
}
