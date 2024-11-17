%{
#include <stdio.h>
#include <string.h>

int table_cnt = 0;

#define MAX_SYMBOLS 100


struct sym_table_entry {
    char name[50];
    char value[50];
} sym_table[MAX_SYMBOLS];

void display();


void add(const char* name, const char* value) {
    for(int i = 0; i < count; i++){
        if (strcmp(symbol_table[i].name, name) == 0) {
            return; 
        }
    }
    strcpy(sym_table[table_cnt].name, name);
    strcpy(sym_table[table_cnt].value, value);
    table_cnt++;
}

%}

%%
"for"|"while"|"if"|"else"|"else if"|"switch"|"case"|"continue"|"break"|"register"|"long"|"return"|"char"|"const"|"default"|"do"|"double" {printf("Keyword "); }
[_a-zA-Z][a-zA-Z0-9]* {printf("ID"); add(yytext, "ID");}
[0-9]+ {printf("Integer Number ");}
[0-9]*"."[0-9]+ {printf("Float Number "); }
[a-zA-z] {printf("Character "); }
['].['] {printf("Character constant ");}
["].*["] {printf("String "); }
[-+=*/%<>|&!~^?:]  {printf("Operator ");}
[(){},;:#] {printf("Special Character ");}
"//".* {printf("Comment");}
"/*" (.*|"/n")* "*/" {printf("Multi line Comment");}
. {printf("Invalid token");}
"@" {display();}

%%

void display() {
    printf("\nSymbol Table:\n");
    printf("Name\t\tValue\n");
    printf("----------------------\n");
    for (int i = 0; i < table_cnt; i++) {
        printf("%s\t\t%s\n", sym_table[i].name, sym_table[i].value);
    }
}

int main() {
    yylex();
    //display();
    return 0;
}

int yywrap() { return 0; }

int yyerror() { return 0; }
