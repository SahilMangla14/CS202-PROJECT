%{
void yyerror (char *s);
int yylex();
#include <stdio.h>     /* C declarations used in actions */
#include <stdlib.h>
#include <ctype.h>
#include <string.h>
int symbol_table[1000];
extern int yylineno;
int expression_eval(char *s);
int check_keyword(char *s);
%}

%union {
    char *string;
    int num;
}

%start line

%token<num> number 
%token <string> PLUS MINUS MULTIPLY DIVIDE EXP    GEQ LEQ GT LT NEQ EQ   AND OR XOR NOT     identifier PRINT LET IF INPUT COMMA GOSUB GOTO RETURN END STOP LEFT_BRACKET RIGHT_BRACKET func_name DEF THEN SEMI_COLON

%type<num> expression arithmetic_expr arithmetic_expr1 arithmetic_expr2 arithmetic_expr3 arithmetic_expr4 arithmetic_expr5  boolean_expr logical_expr
%type<string> statement variable_assign print_statement if_statement def_statement gosub_statement goto_statement input_statement stop_statement end_statement return_statement identifier_list


%%
line:   line number statement
        | number statement
    ;

statement:  variable_assign
            | print_statement
            | if_statement
            | def_statement
            | input_statement
            | gosub_statement
            | goto_statement
            | return_statement
            | end_statement
            | stop_statement
    ;

variable_assign:    LET identifier EQ expression SEMI_COLON
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
    ;

if_statement:   IF boolean_expr THEN number SEMI_COLON
    ;

def_statement:  DEF func_name EQ arithmetic_expr SEMI_COLON
                | DEF func_name LEFT_BRACKET number RIGHT_BRACKET EQ arithmetic_expr SEMI_COLON
    ;

print_statement:    PRINT identifier SEMI_COLON
                    | PRINT expression SEMI_COLON
    ;

input_statement:    INPUT identifier_list SEMI_COLON
    ;

identifier_list:    identifier
                    | identifier_list COMMA identifier
    ;

gosub_statement:    GOSUB number SEMI_COLON
    ;

goto_statement:     GOTO number SEMI_COLON
    ;

return_statement:   RETURN SEMI_COLON
    ;

end_statement:      END SEMI_COLON
    ;

stop_statement:     STOP SEMI_COLON
    ;

%%

int main()
{
    for(int i=0;i<300;i++)
    {
        symbol_table[i]=0;
    }
    
    return yyparse();
}


void yyerror(char *s) {
    fprintf(stderr, "line %d: %s\n", yylineno, s);
}