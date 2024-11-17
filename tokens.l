%{

#include <stdio.h>

#include <string.h>

int cnt = 0;

%}

%%
"for"|"while"|"if"|"else"|"else if"|"switch"|"case"|"continue"|"break"|"register"|"long"|"return"|"char"|"const"|"default"|"do"|"double" {printf("Keyword ");}
[_a-zA-Z][a-zA-Z0-9]* {printf("ID%d ", cnt++);}
[0-9]+ {printf("Integer Number ");}
[0-9]*"."[0-9]+ {printf("Float Number ");}
[a-zA-z] {printf("Character ");}
['].['] {printf("Character constant ");}
["].*["] {printf("String ");}
[-+=*/%<>|&!~^?:]  {printf("Operator ");}
[(){},;:#] {printf("Special Character ");}
"//".* {printf("Comment");}
"/*" (.*|"/n")* "*/" {printf("Multi line Comment");}
. {printf("Invalid token");}

%%

int main(){

yylex();

}

int yywrap(){return 0;}

int yyerror(){return 0;}
