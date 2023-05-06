# CS202-PROJECT

Name - Kartik Yadav(2021csb1101)
       Sahil Mangla(2021csb1128)

To run the  programs use the command given below :
flex BMM_Scanner.l; BMM_Parser.y ; gcc lex.yy.c BMM_Scanner.tab.c;
If you are using 

We have made the following assumptions to the project :
1. We have assumed that an integer type variable can take a float value
and a float type variable can take an integer value(same as C programming language);
2. We have assumed that the user don't use a tab in the input file.
3. Our code stops working when there is an error in the programme and will not parse it further.


My programme contains the following elements:
1. In .l file we have mentioned the tokens which we have passed to the parser in .y file 
like FOR , STOP ,END etc...
2. Even in .y file we have clearly mentioned the tokens using %token .
3. In .y file we have made the tokens and non terminal and clearly defined the grammer rules 
clearly.
4. We have made a sumbol_table array which simply maps a variable to its corresponding ascii 
values.
5. In the same way we have made some arrays , which were also used to map variables to their required values.
6. We are taking input from the input file (CorrectSample.bmm and IncorrectSample.bmm) and giving output in a lexout.txt and parseout.txt file.
7. One file contains its syntax analysis and another contains its semantics ananlysis.