%{
void yyerror (char *s);
int yylex();
#include <stdio.h>     /* C declarations used in actions */
#include <stdlib.h>
#include <ctype.h>
#include <string.h>
extern FILE* yyout, *yyin;
FILE* lexout;
int symbol_table[1000];
int line_no[100000];
extern int yylineno;
// int expression_eval(char *s);
// int check_keyword(char *s);
// int variable_val(char *c);
void checkLineNum(int);
int datatype[1000];
int dirty_variable[1000];
// void check_datatype(char *c);
%}

%union {
    char *string;
    int num;
    float num1;
    char *c;
}

%start line

%token <num> number
%token <num1> float_num
%token PLUS MINUS MULTIPLY DIVIDE EXP STRING    GEQ LEQ GT LT NEQ EQ   AND OR XOR NOT SEMICOLON     num_identifier1 num_identifier2 string_identifier PRINT LET IF INPUT COMMA GOSUB GOTO RETURN END STOP DIM COMMENT DATA LEFT_BRACKET RIGHT_BRACKET func_name DEF THEN NEWLINE
/* %type expression arithmetic_expr arithmetic_expr1 arithmetic_expr2 arithmetic_expr3 arithmetic_expr4 arithmetic_expr5  boolean_expr logical_expr */
/* %type<string> statement variable_assign print_statement if_statement def_statement for_statement gosub_statement goto_statement input_statement stop_statement end_statement return_statement dim_statement identifier_list array_list array_type */


%%
line:   line number statement               {checkLineNum($2); line_no[$2] = 1;}
        | number statement                  {checkLineNum($1); line_no[$1] = 1;}
    ;

statement:  variable_assign
            | print_statement
            | if_statement
            | def_statement
            | input_statement
            | dim_statement
            | data_statement
            | gosub_statement
            | goto_statement
            | return_statement
            | end_statement
            | stop_statement
            | rem_statement
    ;

variable_assign:    
        LET num_identifier1 EQ expression NEWLINE 
        | LET num_identifier2 EQ expression NEWLINE     
        | LET string_identifier EQ STRING NEWLINE  
        | error '\n'        {printf("WRONG VARIABLE ASSIGNMENT"); }         
    ;

expression: arithmetic_expr 
            | boolean_expr
            | logical_expr
    ;

arithmetic_expr:    arithmetic_expr1
                    | arithmetic_expr PLUS arithmetic_expr1
                    | arithmetic_expr MINUS arithmetic_expr1
    ;

arithmetic_expr1:   arithmetic_expr2
                    | arithmetic_expr1 MULTIPLY arithmetic_expr2
                    | arithmetic_expr1 DIVIDE arithmetic_expr2
    ;

arithmetic_expr2:   MINUS arithmetic_expr3
                    | arithmetic_expr3
    ;

arithmetic_expr3:   arithmetic_expr4
                    | arithmetic_expr4 EXP arithmetic_expr4
    ;

arithmetic_expr4:   LEFT_BRACKET arithmetic_expr RIGHT_BRACKET
                    | arithmetic_expr5
    ;

arithmetic_expr5:   number
                    | float_num
                    | num_identifier1
                    | num_identifier2


boolean_expr:   arithmetic_expr GEQ arithmetic_expr
                | arithmetic_expr LEQ arithmetic_expr
                | arithmetic_expr GT arithmetic_expr
                | arithmetic_expr LT arithmetic_expr
                | arithmetic_expr NEQ arithmetic_expr
                | arithmetic_expr EQ arithmetic_expr
    ;

logical_expr:   arithmetic_expr AND arithmetic_expr
                | boolean_expr AND boolean_expr
                | arithmetic_expr AND boolean_expr
                | boolean_expr AND arithmetic_expr
                | arithmetic_expr OR arithmetic_expr
                | boolean_expr OR boolean_expr
                | arithmetic_expr OR boolean_expr
                | boolean_expr OR arithmetic_expr
                | arithmetic_expr XOR arithmetic_expr
                | boolean_expr XOR boolean_expr
                | arithmetic_expr XOR boolean_expr
                | boolean_expr XOR arithmetic_expr
                | NOT arithmetic_expr
                | NOT boolean_expr
                | NOT arithmetic_expr AND arithmetic_expr
                | NOT boolean_expr AND boolean_expr
                | NOT arithmetic_expr AND boolean_expr
                | NOT boolean_expr AND arithmetic_expr
                | NOT arithmetic_expr OR arithmetic_expr
                | NOT boolean_expr OR boolean_expr
                | NOT arithmetic_expr OR boolean_expr
                | NOT boolean_expr OR arithmetic_expr
                | NOT arithmetic_expr XOR arithmetic_expr
                | NOT boolean_expr XOR boolean_expr
                | NOT arithmetic_expr XOR boolean_expr
                | NOT boolean_expr XOR arithmetic_expr
    ;

if_statement:   IF boolean_expr THEN number NEWLINE
    ;

def_statement:  DEF func_name EQ arithmetic_expr NEWLINE
                | DEF func_name LEFT_BRACKET num_identifier1 RIGHT_BRACKET EQ arithmetic_expr NEWLINE
                | DEF func_name LEFT_BRACKET num_identifier2 RIGHT_BRACKET EQ arithmetic_expr NEWLINE
    ;

/* print_statement:    PRINT num_identifier1 NEWLINE        
                    | PRINT num_identifier2 NEWLINE
                    | PRINT string_identifier NEWLINE
                    | PRINT expression NEWLINE
                    | PRINT STRING NEWLINE

    ; */

print_statement:    PRINT expression_type1 NEWLINE
                    | PRINT expression_type2 NEWLINE
    ;

expression_type1:   expression_list
                    | expression_type1 DELIMITER expression_list

    ;

expression_type2:   expression_list DELIMITER
                    | expression_list DELIMITER expression_type2
    ;

expression_list:    num_identifier1
                    | num_identifier2
                    | string_identifier
                    | expression
                    | STRING
    ;

DELIMITER:          COMMA
                    | SEMICOLON
    ;

input_statement:    INPUT identifier_list NEWLINE
    ;

identifier_list:    num_identifier1
                    | num_identifier2
                    | string_identifier
                    | identifier_list COMMA num_identifier1
                    | identifier_list COMMA num_identifier2
                    | identifier_list COMMA string_identifier
    ;

dim_statement:    DIM array_list NEWLINE
    ;

array_list:         array_type          
                    |array_list COMMA array_type
    ;
array_type:         num_identifier1 LEFT_BRACKET number RIGHT_BRACKET
                    | num_identifier1 LEFT_BRACKET number COMMA number RIGHT_BRACKET
    ;

gosub_statement:    GOSUB number NEWLINE
    ;

goto_statement:     GOTO number NEWLINE
    ;

return_statement:   RETURN NEWLINE
    ;

end_statement:      END NEWLINE
    ;

stop_statement:     STOP NEWLINE
    ;

rem_statement:      COMMENT
    ;

data_statement:     DATA data_list NEWLINE
    ;

data_list:      number
                | float_num
                | STRING
                | data_list COMMA number
                | data_list COMMA float_num
                | data_list COMMA STRING
    ;
%%

void checkLineNum(int number){
    if(line_no[number] != 0){
        printf("ERROR: Line number cannot be same");
        exit(1);
    }
}

int main(int argc, char* argv[])
{
    for(int i=0;i<300;i++)
    {
        symbol_table[i]=0;
    }

    for(int i=0;i<100000;i++){
        line_no[i] = 0;
    }

    yyin = fopen(argv[1],"r");
    yyout = fopen("out.txt","w");
    lexout = fopen("lexout.txt","w");
    return yyparse();
}



void yyerror(char *s) {
    fprintf(stderr, "line %d: %s\n", yylineno, s);
}   