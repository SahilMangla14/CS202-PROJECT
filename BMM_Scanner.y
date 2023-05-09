%{
void yyerror (char *s);
int yylex();
#include <stdio.h>     /* C declarations used in actions */
#include <stdlib.h>
#include <ctype.h>
#include <string.h>
extern FILE* yyout, *yyin;
FILE* lexout;
FILE* lex_errors;
FILE* syntax_errors;
// int symbol_table[10000];
int line_no[100000];
int greater_lineno;
int gosub_lineno[100000];
int goto_lineno[100000];
extern int yylineno;
// int expression_eval(char *s);
// int check_keyword(char *s);
// int variable_val(char *c);
// void checkLineNum(int);
// int datatype[1000];
// int dirty_variable[1000];
int count_return;
int count_gosub;
// void check_datatype(char *c);
%}

%union {
    char *string;
    int num;
    float num1;
    char *c;
}

%start program

%token <num> number
%token <num1> float_num
%token <string> PLUS MINUS MULTIPLY DIVIDE EXP STRING    GEQ LEQ GT LT NEQ EQ FOR TO STEP NEXT   AND OR XOR NOT SEMICOLON     num_identifier1 num_identifier2 string_identifier PRINT LET IF INPUT COMMA GOSUB GOTO RETURN END STOP DIM COMMENT DATA LEFT_BRACKET RIGHT_BRACKET func_name DEF THEN NEWLINE
/* %type expression arithmetic_expr arithmetic_expr1 arithmetic_expr2 arithmetic_expr3 arithmetic_expr4 arithmetic_expr5  boolean_expr logical_expr */
/* %type<string> statement variable_assign print_statement if_statement def_statement for_statement gosub_statement goto_statement input_statement stop_statement end_statement return_statement dim_statement identifier_list array_list array_type */


%%
program: line number end_statement                     {fprintf(yyout,"END STATEMENT\n"); line_no[$2]++; if($2>9999){greater_lineno++;}}
        | number end_statement                 {fprintf(yyout,"END STATEMENT\n"); if($1>9999){greater_lineno++;}}
    ;
line:   line number statement               {printf("%d\n",$2); line_no[$2]++; if($2>9999){greater_lineno++;}}
        | number statement                  {line_no[$1]++; if($1>9999){greater_lineno++;}}
    ;

statement:  variable_assign                 {fprintf(yyout,"ASSIGNMENT STATEMENT EXECUTED\n\n");}
            | print_statement               {fprintf(yyout,"PRINT STATEMENT EXECUTED\n\n");}
            | if_statement                  {fprintf(yyout,"IF STATEMENT EXECUTED\n\n");}
            | def_statement                 {fprintf(yyout,"DEF STATEMENT EXECUTED\n\n");}
            | input_statement               {fprintf(yyout,"INPUT STATEMENT EXECUTED\n\n");}
            | for_statement                 {fprintf(yyout,"FOR STATEMENT EXECUTED\n\n");}
            | dim_statement                 {fprintf(yyout,"DIM STATEMENT EXECUTED\n\n");}
            | data_statement                {fprintf(yyout,"DATA STATEMENT EXECUTED\n\n");}
            | gosub_statement               {fprintf(yyout,"GOSUB STATEMENT EXECUTED\n\n"); count_gosub++;}
            | goto_statement                {fprintf(yyout,"GOTO STATEMENT EXECUTED\n\n");}
            | return_statement              {fprintf(yyout,"RETURN STATEMENT EXECUTED\n\n"); count_return++;}
            | stop_statement                {fprintf(yyout,"STOP STATEMENT EXECUTED\n\n");}
            | rem_statement                 {fprintf(yyout,"REM STATEMENT EXECUTED\n\n");}
    ;

expression: arithmetic_expr 
            | boolean_expr
            | logical_expr
    ;

arithmetic_expr:    arithmetic_expr1
                    | arithmetic_expr PLUS arithmetic_expr1                     {fprintf(yyout,"OPERATOR: +\n");}                              
                    | arithmetic_expr MINUS arithmetic_expr1                    {fprintf(yyout,"OPERATOR: -\n");} 
    ;

arithmetic_expr1:   arithmetic_expr2
                    | arithmetic_expr1 MULTIPLY arithmetic_expr2                {fprintf(yyout,"OPERATOR: *\n");} 
                    | arithmetic_expr1 DIVIDE arithmetic_expr2                  {fprintf(yyout,"OPERATOR: /\n");} 
    ;

arithmetic_expr2:   MINUS arithmetic_expr3                                      
                    | arithmetic_expr3
    ;

arithmetic_expr3:   arithmetic_expr4
                    | arithmetic_expr4 EXP arithmetic_expr4                     {fprintf(yyout,"OPERATOR: ^\n");} 
    ;

arithmetic_expr4:   LEFT_BRACKET arithmetic_expr RIGHT_BRACKET
                    | arithmetic_expr5
    ;

arithmetic_expr5:   number                                  {fprintf(yyout,"NUMBER: %d\n",$1);}            
                    | float_num                             {fprintf(yyout,"NUMBER: %f\n",$1);}
                    | num_identifier1                       {fprintf(yyout,"VARIABLE: %s\n",$1);}                                   
                    | num_identifier2                       {fprintf(yyout,"VARIABLE: %s\n",$1);} 
                    | array_type                       
    ;

boolean_expr:   arithmetic_expr GEQ arithmetic_expr                     {fprintf(yyout,"OPERATOR: >=\n");}              
                | arithmetic_expr LEQ arithmetic_expr                   {fprintf(yyout,"OPERATOR: <=\n");}
                | arithmetic_expr GT arithmetic_expr                    {fprintf(yyout,"OPERATOR: >\n");}
                | arithmetic_expr LT arithmetic_expr                    {fprintf(yyout,"OPERATOR: <\n");}
                | arithmetic_expr NEQ arithmetic_expr                   {fprintf(yyout,"OPERATOR: <>\n");}
                | arithmetic_expr EQ arithmetic_expr                    {fprintf(yyout,"OPERATOR: =\n");}
    ;

logical_expr:   arithmetic_expr AND arithmetic_expr                     {fprintf(yyout,"LOGICAL OPERATOR: AND\n");}                   
                | boolean_expr AND boolean_expr                         {fprintf(yyout,"LOGICAL OPERATOR: AND\n");}  
                | arithmetic_expr AND boolean_expr                      {fprintf(yyout,"LOGICAL OPERATOR: AND\n");}  
                | boolean_expr AND arithmetic_expr                      {fprintf(yyout,"LOGICAL OPERATOR: AND\n");}  
                | arithmetic_expr OR arithmetic_expr                    {fprintf(yyout,"LOGICAL OPERATOR: OR\n");}  
                | boolean_expr OR boolean_expr                          {fprintf(yyout,"LOGICAL OPERATOR: OR\n");}  
                | arithmetic_expr OR boolean_expr                       {fprintf(yyout,"LOGICAL OPERATOR: OR\n");} 
                | boolean_expr OR arithmetic_expr                       {fprintf(yyout,"LOGICAL OPERATOR: OR\n");} 
                | arithmetic_expr XOR arithmetic_expr                   {fprintf(yyout,"LOGICAL OPERATOR: XOR\n");} 
                | boolean_expr XOR boolean_expr                         {fprintf(yyout,"LOGICAL OPERATOR: XOR\n");} 
                | arithmetic_expr XOR boolean_expr                      {fprintf(yyout,"LOGICAL OPERATOR: XOR\n");} 
                | boolean_expr XOR arithmetic_expr                      {fprintf(yyout,"LOGICAL OPERATOR: XOR\n");} 
                | NOT arithmetic_expr                                   {fprintf(yyout,"LOGICAL OPERATOR: NOT\n");} 
                | NOT boolean_expr                                      {fprintf(yyout,"LOGICAL OPERATOR: NOT\n");} 
                | NOT arithmetic_expr AND arithmetic_expr               {fprintf(yyout,"LOGICAL OPERATOR: AND\n"); fprintf(yyout,"LOGICAL OPERATOR: NOT\n");} 
                | NOT boolean_expr AND boolean_expr                     {fprintf(yyout,"LOGICAL OPERATOR: AND\n"); fprintf(yyout,"LOGICAL OPERATOR: NOT\n");} 
                | NOT arithmetic_expr AND boolean_expr                  {fprintf(yyout,"LOGICAL OPERATOR: AND\n"); fprintf(yyout,"LOGICAL OPERATOR: NOT\n");} 
                | NOT boolean_expr AND arithmetic_expr                  {fprintf(yyout,"LOGICAL OPERATOR: AND\n"); fprintf(yyout,"LOGICAL OPERATOR: NOT\n");} 
                | NOT arithmetic_expr OR arithmetic_expr                {fprintf(yyout,"LOGICAL OPERATOR: OR\n"); fprintf(yyout,"LOGICAL OPERATOR: NOT\n");} 
                | NOT boolean_expr OR boolean_expr                      {fprintf(yyout,"LOGICAL OPERATOR: OR\n"); fprintf(yyout,"LOGICAL OPERATOR: NOT\n");} 
                | NOT arithmetic_expr OR boolean_expr                   {fprintf(yyout,"LOGICAL OPERATOR: OR\n"); fprintf(yyout,"LOGICAL OPERATOR: NOT\n");} 
                | NOT boolean_expr OR arithmetic_expr                   {fprintf(yyout,"LOGICAL OPERATOR: OR\n"); fprintf(yyout,"LOGICAL OPERATOR: NOT\n");} 
                | NOT arithmetic_expr XOR arithmetic_expr               {fprintf(yyout,"LOGICAL OPERATOR: XOR\n"); fprintf(yyout,"LOGICAL OPERATOR: NOT\n");} 
                | NOT boolean_expr XOR boolean_expr                     {fprintf(yyout,"LOGICAL OPERATOR: XOR\n"); fprintf(yyout,"LOGICAL OPERATOR: NOT\n");} 
                | NOT arithmetic_expr XOR boolean_expr                  {fprintf(yyout,"LOGICAL OPERATOR: XOR\n"); fprintf(yyout,"LOGICAL OPERATOR: NOT\n");} 
                | NOT boolean_expr XOR arithmetic_expr                  {fprintf(yyout,"LOGICAL OPERATOR: XOR\n"); fprintf(yyout,"LOGICAL OPERATOR: NOT\n");} 
                | logical_expr AND arithmetic_expr                      {fprintf(yyout,"LOGICAL OPERATOR: AND\n");} 
                | logical_expr AND boolean_expr                         {fprintf(yyout,"LOGICAL OPERATOR: AND\n");} 
                | logical_expr OR arithmetic_expr                       {fprintf(yyout,"LOGICAL OPERATOR: OR\n");} 
                | logical_expr OR boolean_expr                          {fprintf(yyout,"LOGICAL OPERATOR: OR\n");} 
                | logical_expr XOR arithmetic_expr                      {fprintf(yyout,"LOGICAL OPERATOR: XOR\n");} 
    ;

variable_assign:    LET num_identifier1 EQ arithmetic_expr NEWLINE      {fprintf(yyout,"ASSIGN: %s\n",$2);}    
                    | LET num_identifier2 EQ arithmetic_expr NEWLINE     {fprintf(yyout,"ASSIGN: %s\n",$2);}
                    | LET string_identifier EQ STRING NEWLINE           {fprintf(yyout,"ASSIGN: %s\n",$2);fprintf(yyout,"STRING: %s\n",$4);} 
                    | LET string_identifier EQ string_identifier NEWLINE    {fprintf(yyout,"ASSIGN: %s\n",$2);fprintf(yyout,"STRING: %s\n",$4);}
                    | error '\n'        {printf("WRONG VARIABLE ASSIGNMENT"); }         
    ;

if_statement:   IF logical_expr THEN number NEWLINE  
                | IF boolean_expr THEN number NEWLINE
                | IF string_identifier EQ string_identifier THEN number NEWLINE             {fprintf(yyout,"OPERATOR: =\n");}
                | IF string_identifier NEQ string_identifier THEN number NEWLINE            {fprintf(yyout,"OPERATOR: <>\n");}
                | IF string_identifier EQ STRING THEN number NEWLINE                        {fprintf(yyout,"OPERATOR: =\n");}
                | IF string_identifier NEQ STRING THEN number NEWLINE                       {fprintf(yyout,"OPERATOR: <>\n");}
    ;

def_statement:  DEF func_name EQ arithmetic_expr NEWLINE                                                    {fprintf(yyout,"FUNCTION: %s \n",$2);}                                                                                                         
                | DEF func_name LEFT_BRACKET num_identifier1 RIGHT_BRACKET EQ arithmetic_expr NEWLINE       {fprintf(yyout,"FUNCTION: %s \n",$2);}       
                | DEF func_name LEFT_BRACKET num_identifier2 RIGHT_BRACKET EQ arithmetic_expr NEWLINE       {fprintf(yyout,"FUNCTION: %s \n",$2);}          
    ;

/* print_statement:    PRINT num_identifier1 NEWLINE        
                    | PRINT num_identifier2 NEWLINE
                    | PRINT string_identifier NEWLINE
                    | PRINT expression NEWLINE
                    | PRINT STRING NEWLINE

    ; */

print_statement:    PRINT expression_type1 NEWLINE              
                    | PRINT expression_type2 NEWLINE                {printf("HELLO");}
    ;

expression_type1:   expression_list 
                    | expression_list DELIMITER expression_type1        

    ;

expression_type2:   expression_list DELIMITER
                    | expression_list DELIMITER expression_type2 
    ;

expression_list:    num_identifier1                                     {fprintf(yyout,"VARIABLE: %s\n",$1);} 
                    | num_identifier2                                   {fprintf(yyout,"VARIABLE: %s\n",$1);} 
                    | string_identifier                                 {fprintf(yyout,"VARIABLE: %s\n",$1);} 
                    | expression                                        
                    | STRING                                            {fprintf(yyout,"STRING: %s\n",$1);} 
    ;

DELIMITER:          COMMA
                    | SEMICOLON
    ;

input_statement:    INPUT identifier_list NEWLINE
    ;

identifier_list:    num_identifier1                                     {fprintf(yyout,"NUMERIC_VARIABLE: %s\n",$1);}                                                                     
                    | num_identifier2                                   {fprintf(yyout,"NUMERIC_VARIABLE: %s\n",$1);} 
                    | string_identifier                                 {fprintf(yyout,"STRING_VARIABLE: %s\n",$1);} 
                    | array_type
                    | identifier_list COMMA num_identifier1             {fprintf(yyout,"NUMERIC_VARIABLE: %s\n",$3);}
                    | identifier_list COMMA num_identifier2             {fprintf(yyout,"NUMERIC_VARIABLE: %s\n",$3);}
                    | identifier_list COMMA string_identifier           {fprintf(yyout,"STRING_VARIABLE: %s\n",$3);}
                    | identifier_list COMMA array_type
    ;

dim_statement:    DIM array_list NEWLINE
    ;

array_list:         array_type          
                    |array_list COMMA array_type
    ;
array_type:         num_identifier1 LEFT_BRACKET number RIGHT_BRACKET                       {fprintf(yyout,"ARRAY: %s\n",$1);} 
                    | num_identifier1 LEFT_BRACKET num_identifier1 RIGHT_BRACKET     {fprintf(yyout,"ARRAY: %s\n",$1);}
                    | num_identifier1 LEFT_BRACKET number COMMA number RIGHT_BRACKET        {fprintf(yyout,"ARRAY: %s\n",$1);}
                    | num_identifier1 LEFT_BRACKET num_identifier1 COMMA num_identifier1 RIGHT_BRACKET        {fprintf(yyout,"ARRAY: %s\n",$1);}
                    | num_identifier1 LEFT_BRACKET number COMMA num_identifier1 RIGHT_BRACKET        {fprintf(yyout,"ARRAY: %s\n",$1);}
                    | num_identifier1 LEFT_BRACKET num_identifier1 COMMA number RIGHT_BRACKET        {fprintf(yyout,"ARRAY: %s\n",$1);}
    ;

gosub_statement:    GOSUB number NEWLINE                    {fprintf(yyout,"Call the subroutine, Line no : %d\n",$2); gosub_lineno[$2]++;}
    ;

goto_statement:     GOTO number NEWLINE                     {fprintf(yyout,"Go to the line no : %d\n",$2); goto_lineno[$2]++;}
    ;

return_statement:   RETURN NEWLINE                          
    ;

end_statement:       END
    ;

stop_statement:     STOP NEWLINE
    ;

rem_statement:      COMMENT
    ;

data_statement:     DATA data_list NEWLINE                                  
    ;

data_list:      number                                                  {fprintf(yyout,"DATA VALUES: %d\n",$1);}                                        
                | float_num                                             {fprintf(yyout,"DATA VALUES: %f\n",$1);}  
                | STRING                                                {fprintf(yyout,"DATA VALUES: %s\n",$1);} 
                | data_list COMMA number                                {fprintf(yyout,"DATA VALUES: %d\n",$3);}                               
                | data_list COMMA float_num                             {fprintf(yyout,"DATA VALUES: %f\n",$3);}
                | data_list COMMA STRING                                {fprintf(yyout,"DATA VALUES:%s\n",$3);}
    ;

for_statement:  FOR for_type1 NEWLINE
                | FOR for_type2 NEWLINE
    ;

for_type1: for_number_identifier EQ arithmetic_expr TO arithmetic_expr STEP arithmetic_expr NEWLINE line number NEXT for_number_identifier
            | for_number_identifier EQ arithmetic_expr TO arithmetic_expr STEP arithmetic_expr NEWLINE number NEXT for_number_identifier

for_type2:  for_number_identifier EQ arithmetic_expr TO arithmetic_expr NEWLINE line number NEXT for_number_identifier
            | for_number_identifier EQ arithmetic_expr TO arithmetic_expr NEWLINE  number NEXT for_number_identifier

for_number_identifier: num_identifier1                              {fprintf(yyout,"NUMERIC_VARIABLE %s\n",$1);}              
                | num_identifier2                                   {fprintf(yyout,"NUMERIC_VARIABLE %s\n",$1);}  
                
%%

/* void checkLineNum(int number){
    if(line_no[number] != 0){
        printf("ERROR: Line number cannot be same");
        exit(1);
    }
} */

int main(int argc, char* argv[])
{
    /* for(int i=0;i<300;i++)
    {
        symbol_table[i]=0;
    } */

    for(int i=0;i<1000;i++){
        line_no[i] = 0;
        goto_lineno[i] = 0;
        gosub_lineno[i] = 0;
    }
    
    count_return = 0;
    count_gosub = 0;
    greater_lineno = 0;
    yyin = fopen(argv[1],"r");
    yyout = fopen("parseout.txt","w");
    lexout = fopen("lexout.txt","w");
    lex_errors = fopen("lex_errors.txt","w");
    syntax_errors = fopen("syntax_errors.txt","w");

    
    yyparse();
    printf("%d\n",count_return);
    printf("%d\n",count_gosub);
    /* printf("%d",gosub_lineno[399]); */
    /* printf("%d",line_no[0]); */
    /* printf("%d",greater_lineno); */
    if(count_gosub < count_return){
        fprintf(syntax_errors,"SYNTAX ERROR: %d return statements are associated without GOSUB\n",count_return-count_gosub);
    }

    for(int i=0;i<1000;i++){
        if(gosub_lineno[i] != 0 && line_no[i] == 0){
            fprintf(syntax_errors,"SYNTAX ERROR: GOSUB tries to go to line %d but it does not exists\n",i);
        }
        if(goto_lineno[i] != 0 && line_no[i] == 0){
            fprintf(syntax_errors,"SYNTAX ERROR: GOTO tries to go to line %d but it does not exists\n",i);
        }
    }

    if(greater_lineno > 0){
        fprintf(syntax_errors,"SYNTAX ERROR: %d lines are greater than 9999\n",greater_lineno);
    }
}



void yyerror(char *s) {
    fprintf(stderr, "line %d: %s\n", yylineno, s);
}   