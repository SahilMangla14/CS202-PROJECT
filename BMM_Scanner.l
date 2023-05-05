%{
#include<stdio.h>   
#include"BMM_Scanner.tab.h"
int yylex();
int yyerror(char *s);
int yylineno = 1;
%}


%%
[0-9]+ {/*printf(" number ");*/ yylval.num=atoi(yytext); return number ;}
"LET" {return let;}
"PRINT" {return print;}
"IF" {/*printf(" IF ");*/return if_key;}
"THEN" {/*printf(" THEN ");*/ return then;}
"DEF" {/*printf( " DEF ");*/ return DEF;}
FUN[A-Z] {/*printf(" FUN ");*/return func_key;}
[A-Z]  {/*"variable")*/;yylval.identifier_name=yytext; return identifier;}
[-+=\/\*\(\)\^;><=]           	   {/*printf("COLON");*/return yytext[0];}
">=" {return geq;}
"<=" {return leq;}
"<>" {return neq;}
[\n]    {yylineno++;}
[ \t]                {/*printf(" Space ");*/}
.                    {}
%%


int yywrap(void){
    return 1;
}