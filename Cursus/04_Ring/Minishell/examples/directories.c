#include <unistd.h>
#include <stdio.h>
#include <linux/limits.h>

int main() {
	char cwd[PATH_MAX];

	if (getcwd(cwd, sizeof(cwd)) != NULL) {
		printf("Current working dir: %s\n", cwd);
	} else {
		perror("getcwd() error");
		return 1;	
	}

	if (chdir("/home/ziko/") < 0)
		printf("Error changing directory\n");
	else
		printf("Directory change OK\n");

	if (getcwd(cwd, sizeof(cwd)) != NULL) {
		printf("Current working dir: %s\n", cwd);
	} else {
		perror("getcwd() error");
		return 1;	
	}
	return 0;
}
