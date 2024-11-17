%{
#include <stdio.h>
int yyerror(char *str);
extern int yylex(void);  // Declare yylex
%}

%token DT ID IF ELSE FOR WHILE SWITCH CASE BREAK DEFAULT NUM FNUM

%%

PROG : DT ID '(' ')' BLK
     ;

BLK : '{'  SS '}'
     ;

SS : SS S
   | S
   ;

S : E ';'
  | IFST 
  | BLK
  | WHILEST
  | ';'
  ;

IFST : IF '(' E ')' S 
     | IF '(' E ')' S ELSE S
     ;

WHILEST : WHILE '(' E ')' S
        ;

E : ID '=' E   
  | R          
  ;

R : R '>' F     
  | R '<' F
  | F          
  ;

F : F '+' G 
  | F '-' G 
  | G
  ;

G : G '*' H 
  | G '/' H 
  | H
  ;

H : '(' E ')' 
  | ID 
  | NUM  
  | FNUM
  ;

%%
int yyerror(char *str)
{
    printf("syntax error\n");
    return 0;
}

int main()
{
    yyparse();
    return 0;
}
