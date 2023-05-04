%{
#include<stdio.h>   
#include"b.tab.h"
int yylex();
int yyerror(char *s);
%}


%%
[0-9]+ {/*printf("number");*/ yylval.num=atoi(yytext); return number ;}
("LET"|"PRINT") {/*printf("keyword");*/yylval.keyword_val=yytext; return keyword;}
[A-Z]  {/*"variable")*/;yylval.identifier_name=yytext; return identifier;}
[-+=;]           	   {return yytext[0];}
[ \t\n]                {return yytext[0];}
.                    {}
%%


int yywrap(void){
    return 1;
}

