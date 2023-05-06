%{
#include<stdio.h>   
#include"b.tab.h"
extern FILE* lexout;
int yylex();
int yyerror(char *s);
int yylineno = 1;
%}


%%
(\".+\")                      {fprintf(lexout,"STRING : %s\n",yytext); yylval.string = yytext; return STRING;}
[0-9]+                      {fprintf(lexout,"NUMBER :%d\n",atoi(yytext)); yylval.num = atoi(yytext); return number; }
([0-9]*[.])[0-9]+           {fprintf(lexout,"FLOAT_NUM: %f\n",atof(yytext)); yylval.num1 = atof(yytext); return float_num;}
[A-Z]                                                       {fprintf(lexout,"VARIABLE:  %s\n",yytext); yylval.c = yytext; return num_identifier1;}
(([A-Z][0-9])|([A-Z][0-9]?(%|!|#)))                      {fprintf(lexout,"VARIABLE: %s\n",yytext); yylval.c = yytext; return num_identifier2;}
[A-Z][0-9]?\$                                                {fprintf(lexout,"VARIABLE: %s\n",yytext); yylval.c = yytext; return string_identifier;}
[+]                         {fprintf(lexout,"PLUS \n"); yylval.string = yytext; return PLUS;}
[-]                         {fprintf(lexout,"MINUS \n"); yylval.string = yytext; return MINUS;}
\*                         {fprintf(lexout,"MULTIPLY \n"); yylval.string = yytext; return MULTIPLY;}
\/                        {fprintf(lexout,"DIVIDE \n"); yylval.string = yytext; return DIVIDE;}
\^                        {fprintf(lexout,"EXP \n"); yylval.string = yytext; return EXP;}
(>=)                         {fprintf(lexout,"GEQ \n"); yylval.string = yytext; return GEQ;}
(<=)                         {fprintf(lexout,"LEQ \n"); yylval.string = yytext; return LEQ;}
[>]                         {fprintf(lexout,"GT \n"); yylval.string = yytext; return GT;}
[<]                         {fprintf(lexout,"LT \n"); yylval.string = yytext; return LT;}
(<>)                         {fprintf(lexout,"NEQ \n"); yylval.string = yytext; return NEQ;}
[=]                         {fprintf(lexout,"EQ \n"); yylval.string = yytext; return EQ;}
[\n]                         {yylineno++;fprintf(lexout,"NEWLINE\n"); yylval.string = yytext; return NEWLINE;}
[,]                         {fprintf(lexout,"COMMA\n"); yylval.string = yytext; return COMMA;}
\(                         {fprintf(lexout,"LEFT_BRACKET \n"); yylval.string = yytext; return LEFT_BRACKET;}
\)                         {fprintf(lexout,"RIGHT_BRACKET \n"); yylval.string = yytext; return RIGHT_BRACKET;}
AND                         {fprintf(lexout,"OPERATOR :AND\n"); yylval.string = yytext; return AND;}
OR                         {fprintf(lexout,"OPERATOR : OR\n"); yylval.string = yytext; return OR;}
XOR                         {fprintf(lexout,"OPERATOR: XOR\n"); yylval.string = yytext; return XOR;}
NOT                         {fprintf(lexout,"OPERATOR: NOT\n"); yylval.string = yytext; return NOT;}
LET                         {fprintf(lexout,"KEYWORD: LET\n"); yylval.string = yytext; return LET;}
IF                         {fprintf(lexout,"KEYWORD: IF\n"); yylval.string = yytext; return IF;}
THEN                         {fprintf(lexout,"KEYWORD: THEN\n"); yylval.string = yytext; return THEN;}
PRINT                         {fprintf(lexout,"KEYWORD: PRINT\n"); yylval.string = yytext; return PRINT;}
INPUT                         {fprintf(lexout,"KEYWORD: INPUT\n"); yylval.string = yytext; return INPUT;}
DEF                         {fprintf(lexout,"KEYWORD: DEF\n"); yylval.string = yytext; return DEF;}
GOSUB                       {fprintf(lexout,"KEYWORD: GOSUB\n"); yylval.string = yytext; return GOSUB;}
GOTO                       {fprintf(lexout,"KEYWORD: GOTO\n"); yylval.string = yytext; return GOTO;}
RETURN                      {fprintf(lexout,"KEYWORD: RETURN\n"); yylval.string = yytext; return RETURN;}
END                         {fprintf(lexout,"KEYWORD: END\n"); yylval.string = yytext; return END;}
STOP                        {fprintf(lexout,"KEYWORD: STOP\n"); yylval.string = yytext; return STOP;}
DIM                         {fprintf(lexout,"KEYWORD: DIM\n"); yylval.string = yytext; return DIM;}
DATA                        {fprintf(lexout,"KEYWORD: DATA\n"); yylval.string = yytext; return DATA;}
FN[A-Z]                     {fprintf(lexout,"Function Name: %s\n",yytext); yylval.string = yytext; return func_name;}
REM.*\n                       {fprintf(lexout,"COMMENT\n"); yylval.string = yytext; return COMMENT;} 
[ \t]                {fprintf(lexout,"Space \n");}
[;]                   {fprintf(lexout,"SEMICOLON \n"); yylval.string = yytext; return SEMICOLON;}
.                    {fprintf(lexout,"Lexical error on line %d: unexpected character '%c'\n", yylineno, *yytext);}
%%

int yywrap(void){
    return 1;
}