%{
#include<stdio.h>   
#include"b.tab.h"
int yylex();
int yyerror(char *s);
int yylineno = 1;
%}


%%
[0-9]+                      {printf("number "); yylval.num = atoi(yytext); return number; }
[A-Z]                       {printf("identifier ");yylval.string = yytext; return identifier;}
[+]                         {printf("PLUS "); yylval.string = yytext; return PLUS;}
[-]                         {printf("MINUS "); yylval.string = yytext; return MINUS;}
\*                         {printf("MULTIPLY "); yylval.string = yytext; return MULTIPLY;}
\/                        {printf("DIVIDE "); yylval.string = yytext; return DIVIDE;}
\^                        {printf("EXP "); yylval.string = yytext; return EXP;}
(>=)                         {printf("GEQ "); yylval.string = yytext; return GEQ;}
(<=)                         {printf("LEQ "); yylval.string = yytext; return LEQ;}
[>]                         {printf("GT "); yylval.string = yytext; return GT;}
[<]                         {printf("LT "); yylval.string = yytext; return LT;}
(<>)                         {printf("NEQ "); yylval.string = yytext; return NEQ;}
[=]                         {printf("EQ "); yylval.string = yytext; return EQ;}
[;]                         {printf("SEMI_COLON\n"); yylval.string = yytext; return SEMI_COLON;}
[,]                         {printf("COMMA"); yylval.string = yytext; return COMMA;}
\(                         {printf("LEFT_BRACKET "); yylval.string = yytext; return LEFT_BRACKET;}
\)                         {printf("RIGHT_BRACKET "); yylval.string = yytext; return RIGHT_BRACKET;}
AND                         {printf("AND "); yylval.string = yytext; return AND;}
OR                         {printf("OR "); yylval.string = yytext; return OR;}
XOR                         {printf("XOR "); yylval.string = yytext; return XOR;}
NOT                         {printf("NOT "); yylval.string = yytext; return NOT;}
LET                         {printf("LET "); yylval.string = yytext; return LET;}
IF                         {printf("IF "); yylval.string = yytext; return IF;}
THEN                         {printf("THEN "); yylval.string = yytext; return THEN;}
PRINT                         {printf("PRINT "); yylval.string = yytext; return PRINT;}
INPUT                         {printf("INPUT "); yylval.string = yytext; return INPUT;}
DEF                         {printf("DEF "); yylval.string = yytext; return DEF;}
GOSUB                       {printf("GOSUB "); yylval.string = yytext; return GOSUB;}
GOTO                       {printf("GOTO "); yylval.string = yytext; return GOTO;}
RETURN                      {printf("RETURN "); yylval.string = yytext; return RETURN;}
END                         {printf("END "); yylval.string = yytext; return END;}
STOP                        {printf("STOP "); yylval.string = yytext; return STOP;}
FN[A-Z]                     {printf("FUNC_NAME "); yylval.string = yytext; return func_name;}
[\n]                        {yylineno++;}
[ \t]                {printf("Space ");}
.                    {printf("Lexical error on line %d: unexpected character '%c'\n", yylineno, *yytext);}
%%

int yywrap(void){
    return 1;
}