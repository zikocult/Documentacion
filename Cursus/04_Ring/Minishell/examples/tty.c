#include <stdio.h>
#include <unistd.h>
#include <fcntl.h>

int main(void)
{
	int fd1;
	ssize_t nr_bytes;
	char buff;

	fd1 = open("/home/ziko/Downloads/test.txt", O_RDONLY);	
	if (isatty(fd1))
		printf("abierto\n");
	else
		printf("cerrado\n");
	nr_bytes = read(fd1, &buff, 1);
	if (nr_bytes == 0)
		return 1;
	printf("%c\n", buff);
	if (isatty(2))
		printf("abierto\n");
	else
		printf("cerrado\n");
	printf("ttyname(0): %s\n", ttyname(0));
	printf("ttyname(1): %s\n", ttyname(1));
	printf("ttyname(2): %s\n", ttyname(2));
	printf("ttyname(fd1): %s\n", ttyname(fd1));
	printf("ttyslot(): %d\n", ttyslot());
	close(fd1);
}
