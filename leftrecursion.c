#include <stdio.h>
#include <string.h>

#define SIZE 10

int main() {
    char non_terminal;
    char beta[SIZE], alpha[SIZE];
    int num;
    char production[10][SIZE];
    int index = 3;

    printf("Enter Number of Productions: ");
    scanf("%d", &num);

    printf("Enter the grammar\n");
    for (int i = 0; i < num; i++) {
        scanf("%s", production[i]);
    }

    for (int i = 0; i < num; i++) {
        printf("\nGrammar %s", production[i]);
        non_terminal = production[i][0];

        if (non_terminal == production[i][index]) {
            printf(" is left recursive.\n");

            int j = 0;
            while (production[i][index + 1 + j] != 0 && production[i][index + 1 + j] != '|') {
                alpha[j] = production[i][index + 1 + j];
                j++;
            }
            alpha[j] = '\0';  
         
            if (production[i][index + 1 + j] == '|') {
                int k = 0;
                index += 2 + j;  
                while (production[i][index + k] != 0) {
                    beta[k] = production[i][index + k];
                    k++;
                }
                beta[k] = '\0';  

                printf("Grammar without left recursion:\n");
                printf("%c->%s%c\'", non_terminal, beta, non_terminal);
                printf("\n%c\'->%s%c\'|^\n", non_terminal, alpha, non_terminal);
            } else {
                printf(" can't be reduced\n");
            }
        } else {
            printf(" is not left recursive.\n");
        }

        index = 3;  
    }

    return 0;
}

