%{
#include<stdio.h>   
#include"BMM_Scanner.tab.h"
int yylex();
int yyerror(char *s);
%}


%%
[0-9]+ {/*printf("number");*/ yylval.num=atoi(yytext); return number ;}
"LET" {return let;}
"PRINT" {return print;}
[A-Z]  {/*"variable")*/;yylval.identifier_name=yytext; return identifier;}
[-+=\/\*\(\)\^;]           	   {return yytext[0];}
[ \t\n]                {;}
.                    {}
%%


int yywrap(void){
    return 1;
}