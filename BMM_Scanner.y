%{
void yyerror (char *s);
int yylex();
#include <stdio.h>     /* C declarations used in actions */
#include <stdlib.h>
#include <ctype.h>
#include <string.h>
int symbol_table[1000];
int expression_eval(char *s);
int check_keyword(char *s);
%}

%union {char *identifier_name;int num; char *keyword_val; int expr_val; int term_val;} 
%start line
%token<num> number           
%token<keyword_val> keyword         
%token <identifier_name> identifier
%type <keyword_val> statement
%type <keyword_val> print_statement
%type <keyword_val> variable_assign
%type <num>expr
%type <num>term
%token string

%%

line : line number statement|number statement;
statement : variable_assign | print_statement;
print_statement : keyword identifier ';'   {printf("%d\n",symbol_table[$2[0]-'A']);}
                |keyword expr ';'  {printf("%d\n",$2);} ;        
variable_assign : keyword identifier '=' expr ';' {symbol_table[$2[0]-'A']=$4;};
expr : term {$$=$1;}
        |expr '+' term {$$=$1+$3;}
        |expr '-' term {$$=$1-$3;} ;
term : number {$$=$1;};

%%

int main()
{
    for(int i=0;i<300;i++)
    {
        symbol_table[i]=0;
    }
    
    return yyparse();
}

void yyerror (char *s) {fprintf (stderr, "%s\n", s);}
