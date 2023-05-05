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
%token print        
%token let
%token<keyword_val> keyword         
%token <identifier_name> identifier
%type <keyword_val> statement
%type <keyword_val> print_statement
%type <keyword_val> variable_assign
%type <num>expr term1 term2 term3 term4 term5 expr1 expr2 expr3 expr4 expr5 expression
%token string

%%

line : line number statement|number statement;
statement : variable_assign | print_statement;
print_statement : print identifier ';'   {printf("%d\n",symbol_table[$2[0]-'A']);}
                |print expression ';'  {printf("%d\n",$2);} ;        
variable_assign : let identifier '=' expression ';' {symbol_table[$2[0]-'A']=$4;};
expression: expr                   {$$ = $1;}
            | expr '>=' expr1       {$$ = $1>= $3;};
expr1:      expr2                   {$$ = $1;}
            | expr1 '<=' expr2      {$$ = $1 <= $3;};
expr2:      expr3                   {$$ = $1;}
            | expr2 '>' expr3       {$$ = $1 > $3;};
expr3:      expr4                   {$$ = $1;}
            | expr3 '<' expr4       {$$ = $1 < $3;};
expr4:      expr5                   {$$ = $1;}
            | expr4 '<>' expr5       {$$ = $1 != $3;};
expr5:      expr                    {$$ = $1;}
            | expr5 '=' expr        {$$ = $1 == $3;};
expr : term1 {$$=$1;}
        |expr '+' term1 {$$=$1+$3;}
        |expr '-' term1 {$$=$1-$3;} ;
term1 :  term2                 {$$ = $1;}
        | term1 '*' term2       {$$ = $1 * $3;}
        | term1 '/' term2       {$$ = $1 / $3;};
term2 : '-' term3               {$$ = -1 * $2;}
        | term3                 {$$ = $1;};
term3 : term4                   {$$ = $1;}
        | term3 '^' term4       {$$ = $1 ^ $3;};
term4 : '(' expr ')'           {$$ = $2;}
        | term5                {$$ = $1;};
term5 : number {$$=$1;};    

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