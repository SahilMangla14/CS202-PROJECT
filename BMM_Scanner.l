%{
#include<stdio.h>   
%}


%%
("if"|"else"|"printf")        {printf("%s is a keyword",yytext);};   
[0-9]+         {printf("%s is a number",yytext);}
[a-zA-Z]+       {printf("%s is a word",yytext);}
[\.\n]          {ECHO;}
%%


int yywrap(void){
    return 1;
}

int main(){
    printf("Enter the string : ");
    yylex();
}