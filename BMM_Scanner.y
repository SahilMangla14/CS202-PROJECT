%{
void yyerror (char *s);
int yylex();
#include <stdio.h>     /* C declarations used in actions */
#include <stdlib.h>
#include <ctype.h>
#include <string.h>
int symbol_table[1000];
int line_no[100000];
extern int yylineno;
int expression_eval(char *s);
int check_keyword(char *s);
void checkLineNum(int);
int datatype[1000];
void check_datatype(char *c);
%}

%union {
    char *string;
    int num;
}

%start line

%token<num> number 
%token <string> PLUS MINUS MULTIPLY DIVIDE EXP    GEQ LEQ GT LT NEQ EQ   AND OR XOR NOT     identifier PRINT LET IF INPUT COMMA GOSUB GOTO RETURN END STOP DIM COMMENT LEFT_BRACKET RIGHT_BRACKET func_name DEF THEN SEMI_COLON

%type<num> expression arithmetic_expr arithmetic_expr1 arithmetic_expr2 arithmetic_expr3 arithmetic_expr4 arithmetic_expr5  boolean_expr logical_expr
%type<string> statement variable_assign print_statement if_statement def_statement gosub_statement goto_statement input_statement stop_statement end_statement return_statement dim_statement identifier_list array_list array_type


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
            | gosub_statement
            | goto_statement
            | return_statement
            | end_statement
            | stop_statement
            | rem_statement
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

dim_statement:    DIM array_list SEMI_COLON
    ;

array_list:         array_type          
                    |array_list COMMA array_type
    ;
array_type:         identifier LEFT_BRACKET number RIGHT_BRACKET
                    | identifier LEFT_BRACKET number COMMA number RIGHT_BRACKET
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

rem_statement:      COMMENT
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

    return yyparse();
}
void check_datatype(char *c)
{
    int val1=10*(c[0]-'A')+(c[1]-'0');
    int val2=10*(c[0]-'A');
    int len=strlen(c);
    if(c[len-1]=='%')
    {
        if(len==3)
        {
            datatype[val1]=0;
        }
        else
        {
            datatype[val2]=0;
        }
        
    }
    else if(c[len-1]=='!')
    {
        if(len==3)
        {
            datatype[val1]=1;
        }
        else
        {
            datatype[val2]=1;
        }
        
    }
    else if(c[len-1]=='#')
    {
        if(len==3)
        {
            datatype[val1]=2;
        }
        else
        {
            datatype[val2]=2;
        }
    
    }
    else if(c[len-1]=='$')
    {
        if(len==3)
        {
            datatype[val1]=3;
        }
        else
        {
            datatype[val2]=3;
        }
        
    }
    else
    {
        if(len==2)
        {
            datatype[val1]=3;
        }
        else
        {
            datatype[val2]=3;
        }
        
    }

}



void yyerror(char *s) {
    fprintf(stderr, "line %d: %s\n", yylineno, s);
}