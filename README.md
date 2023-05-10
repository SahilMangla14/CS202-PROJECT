# CS202 PROJECT (B-- COMPILER)
---
## HOW TO RUN?
Run the following commands in the command terminal :-
### 1.The following command will create the file lex.yy.c
```
flex BMM_Scanner.l
```

### 2. The following command will generate two files - BMM_Scanner.tab.h and BMM_Scanner.tab.c
```
bison -d BMM_Scanner.y
```
### 3. The following command will compile the generated files to make a.exe
```
gcc lex.yy.c BMM_Scanner.tab.c
```

### 4. Run the exe file
```
./a.exe ./input.txt
```
---
## INPUT AND OUTPUT

### INPUT :- 
Input will be the code for b-- language. On running the exe file, we will get to know whether there are lexical or syntactical errors in the code or not.
### OUTPUT :-
Output will contain 4 files.
### 1. lexout.txt :- 
- It will contain the output of lexer
### 2. parseout.txt :-
- It will contain the output of parser
### 3. lex_errors.txt :-
- It will contain the errors generated by 
### 4. syntax_errors.txt :-
- If there are any syntax errors, it will be displayed in this text file.
---

## Syntax
### 1. Variables
- **Single Upper-Case Letter** (A – Z) followed by an optional single digit (0 – 9).
- **Data Types:** Numeric – Integer (%), Single Precision (!), Double Precision (#) & Strings ($)
---

### 2. Operators
- **Arithmetic:** (),^,-,*,/,+,-
- **Relational:** =, <>, <, >, <=, >=
- **Logical:**  NOT, AND, OR, XOR
---

### 3. DATA Statement
- **Syntax:** ```DATA value1,value2,value3,...```
- value1,value2,... can be either numeric constant or string constant not variables
---

### 4. DEF
- **Syntax**: 
    ```
    DEF FNx = numeric_expression 
    or 
    DEF FNx(parameter) = numeric_expression
    ```
- numeric expression can be any arithmetic expression
---

### 5. DIM
- **Syntax:** ```DIM declaration1, declaration2, ...```
- Declarations come in two forms: X(maxsubscript) or X(maxsubscript1,maxsubscript2)
- maxsubscripts could be either numeric constants or numeric variables
---

### 6. END
- **Syntax:** ```END```
- END statement is used to specify the end of the source program
- It can occur only at the end of the program.
- If it occurs in the middle of the program, the program will terminate giving syntax error
---

### 7. FOR
- **Syntax:**
    ```
    FOR varname=expression1 TO expression2 STEP expression3 
    or 
    FOR varname=expression1 TO expression2
    ...
    ...
    NEXT varname
    ```
- Next should be there for each for statement, if there are multiple for's then next number should be equal to the no. of for loops
---

### 8. GOSUB
- **Syntax:** ```GOSUB lineno```
- If lineno doesnot exist, it will show error in the file named syntax_errors.txt
---

### 9. GOTO
- **Syntax:** ```GOTO lineno```
- If lineno doesnot exist, it will show error in the file named syntax_errors.txt
---

### 10. IF
- **Syntax:** ```IF condition THEN lineno```
- Condtion can be any logical expression or boolean expression or any string comparison
---

### 11. LET
- **Syntax:** 
    ```
    LET string_variable = string_literal 
    or 
    LET numeric_variable = numeric_expression
    ```
- numeric_expression can be any arithmetic expression
---

### 12. INPUT
- **Syntax:** ```INPUT v1,v2,....```
- It can be either numeric_variable, string_variable or any array_type (1D or 2D)
---

### 13. PRINT
- **Syntax:** Three general forms of the PRINT
statement:
    ```
  - PRINT
  - PRINT expression1 delimiter1 ... expressionN
  - PRINT expression1 delimiter1 ... expressionN delimiter
    ```
 - Expressions are either numeric expressions, string literals, scalar string variables.
 - Two possible delimiters exist, the comma and the semicolon.
---

### 14. REM
- **Syntax:** ```REM anything```
- Any character after REM will be considered as a comment (assumption)
---

### 15. RETURN
- **Syntax:** ```RETURN```
- There is one return statement associated with each GOSUB statement. If there are more return statements, it will show error in the syntax_errors.txt file
---

### 16. STOP
- **Syntax:** ```STOP```
- Can occur anywhere within program
---

## Assumptions: 
- Consider line no. to be from 0 to 9999 only.
- We have assumed that an integer type variable can take a float value and a float type variable can take an integer value (same as C programming language) but they cannot take string value. A string can be stored in string variable only.
- Our code stops working when there is an error in the programme and will not parse it further.

---

## Authors
- **SAHIL (2021CSB1128)**
- **KARTIK YADAV (2021CSB1101)**



