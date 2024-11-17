%{
#include "parser.tab.h"
%}
%%
"int"|"void"|"float"        {return DT; }
"if"                        {return IF; }
"else"                      {return ELSE; }
"while"                     {return WHILE; }
[_a-zA-Z][a-zA-Z0-9]*       {return ID; }
[0-9]+                      {return NUM; }
[0-9]*"."[0-9]+             {return FNUM; }
[-+*/=(){}:;]               {return yytext[0]; }
%%
int yywrap()
{
    return 1;
}