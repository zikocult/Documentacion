#include <stdlib.h>
#include <stdio.h>
#include <readline/readline.h>
#include <readline/history.h>
#include <string.h>

int main(void)
{
    char *command_buff;

    while (1)
    {
        command_buff = readline("minishell> ");
        if (strlen(command_buff) > 0)
        {
            add_history(command_buff);
            // Reemplazamos la línea de entrada con un nuevo texto
            rl_replace_line("Nuevo comando", 0);
            rl_on_new_line(); // Preparamos la línea para la redisplay
            rl_redisplay();   // Redisplay de la línea de entrada
        }
        if (!strcmp(command_buff, "exit"))
        {
            rl_clear_history();
            free(command_buff);
            break;
        }
        free(command_buff);
    }
    return 0;
}
