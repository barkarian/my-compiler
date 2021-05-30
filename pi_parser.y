%{
#include <stdlib.h>
#include <stdarg.h>
#include <stdio.h>
#include <string.h>		
#include "cgen.h"
#include <math.h> //for pow function

extern int yylex(void);
extern int line_num;
%}

%define parse.error verbose

%union
{
	char* crepr;
}
//tokens
%token KW_INT
%token KW_REAL
%token KW_STRING
%token KW_BOOL
%token <crepr> BOOL
%token KW_VAR
%token KW_CONST  
// logic literals
%token KW_IF
%token KW_ELSE
%token KW_FOR
%token KW_WHILE
%token KW_BREAK
%token KW_CONTINUE
//function's literals
%token KW_FUNC
%token KW_NIL
%token KW_AND
%token KW_OR
%token KW_NOT 
%token KW_RETURN
%token KW_BEGIN
//others
%token ASSIGN
%token <crepr> STRING
%token <crepr> INTEGER
%token <crepr> REAL
%token <crepr> IDENTIFIER
//otrher telestikoi
%token POWER
%token EQ
%token NEQ
%token LT
%token LE
%token GT
%token GE

//specify the start
%start program

//types declarations
%type <crepr> decl_list body decl declInsideBody decl_list_body
//constvar
%type <crepr>constDeclaration
%type <crepr>constAssignments
%type <crepr>varDeclaration
%type <crepr>varAssignments
%type <crepr>varAssignment
//functions
%type <crepr> functionDeclaration
%type <crepr> functionParameters
%type <crepr> functionInputs
//assigments expr datatypes etc.
%type <crepr> assignment
%type <crepr> expr
%type <crepr> value
%type <crepr> dataType
%type <crepr> statementList
%type <crepr> statement
%type <crepr> statementFor
%type <crepr> statementComplex
%type <crepr> statementComplexMinusIf
%type <crepr> statementWhile
%type <crepr> statementIf

%left KW_OR
%left KW_AND
%left NEQ
%left GE LE
%left GT LT
%left EQ
%right POWER
%right '+' '-'
%left '*' '/' '%'
%left REDUCE_PRIORITY //not a token /used with prec to specify priority
%right KW_NOT
%left '(' ')'

%precedence KW_ELSE //specify precidence

%%

program: decl_list KW_FUNC KW_BEGIN '(' ')' '{' body '}' { 

 /* We have a successful parse! 
    Check for any errors and generate output. 
  */
  
  if (yyerror_count == 0) {
    // include the pilib.h file
    puts(c_prologue); 
    printf("/* program */ \n\n");
    printf("%s\n\n", $1);
    printf("int main() {\n%s\n} \n", $7);
  }
}
;


decl_list: 
decl_list decl { $$ = template("%s\n%s", $1, $2); }
|decl { $$ = $1; }
;

decl:
  constDeclaration ';' { $$ = template("%s;", $1); }
  | varDeclaration ';' { $$ = template("%s;", $1); }
  | functionDeclaration ';' { $$ = template("%s", $1); }
  ;

decl_list_body:
  %empty {$$="";}
  |decl_list_body declInsideBody { $$ = template("%s%s\n", $1, $2); }
  ;

declInsideBody:
  constDeclaration ';' { $$ = template("%s;", $1); }
  |varDeclaration ';' { $$ = template("%s;", $1); }
  ;


body: 
  decl_list_body statementList  {$$ = template("%s%s", $1, $2);}
  ;

//const declarations

constDeclaration:
  KW_CONST constAssignments dataType {$$ = template("%s %s", $3, $2);}
  ;

constAssignments:
  assignment
  | constAssignments ',' assignment { $$ = template("%s, %s", $1, $3); }
  ;

//varDeclaration

varDeclaration:
  KW_VAR varAssignments dataType {$$ = template("%s %s", $3, $2);}
  ;

varAssignments:
  varAssignment
  | varAssignments ',' varAssignment { $$ = template("%s, %s", $1, $3); }
  ;

varAssignment:
  assignment
  | IDENTIFIER
  | IDENTIFIER '[' INTEGER ']' { $$ = template("%s[%s]", $1, $3); }
  | IDENTIFIER '[' ']'         { $$ = template("*%s", $1); }
  ;

//functionsDeclaration------------

functionDeclaration: 
  KW_FUNC IDENTIFIER '(' functionParameters ')' dataType '{' body '}' {
    $$ = template("%s %s(%s){\n%s}", $6, $2, $4, $8);
  };

functionParameters:
  %empty { $$ = ""; }
  |IDENTIFIER dataType  { $$ = template("%s %s", $2, $1); }
  |functionParameters ',' IDENTIFIER dataType  { $$ = template("%s,%s %s", $1, $4, $3); }
  ;


//useful everywhere

assignment:
  IDENTIFIER ASSIGN expr                               { $$ = template("%s = %s", $1, $3); }
  | IDENTIFIER '[' INTEGER ']' ASSIGN expr             { $$ = template("%s[%s] = %s", $1, $3, $6); }
  | IDENTIFIER '[' ']' ASSIGN expr                     { $$ = template("*%s = %s", $1, $5); }
  ;

functionInputs:
  expr
  | functionInputs ',' expr  { $$ = template("%s, %s", $1, $3); }
  ;

expr: 
  value
  | IDENTIFIER
  | IDENTIFIER '[' expr ']' { $$ = template("%s[%s]", $1, $3); }
  | IDENTIFIER '(' ')' { $$ = template("%s()", $1); }
  | IDENTIFIER '(' functionInputs ')' { $$ = template("%s(%s)", $1, $3); }

  | expr '+' expr  { $$ = template("%s + %s", $1, $3); }
  | expr '-' expr  { $$ = template("%s - %s", $1, $3); }
  | expr '*' expr  { $$ = template("%s * %s", $1, $3); }
  | expr '/' expr  { $$ = template("%s / %s", $1, $3); }

  | expr '%' expr  { $$ = template("%s %% %s", $1, $3); }
  | expr POWER expr { $$ = template("pow(%s, %s)", $1, $3); }

  | expr EQ expr  { $$ = template("%s == %s", $1, $3); }
  | expr NEQ expr  { $$ = template("%s != %s", $1, $3); }
  | expr LE expr  { $$ = template("%s <= %s", $1, $3); }
  | expr LT expr   { $$ = template("%s < %s", $1, $3); }
  | expr GE expr  { $$ = template("%s >= %s", $1, $3); }
  | expr GT expr   { $$ = template("%s > %s", $1, $3); }
  | expr KW_AND expr { $$ = template("%s && %s", $1, $3); }
  | expr KW_OR expr  { $$ = template("%s || %s", $1, $3); }
  | KW_NOT expr      { $$ = template("!%s", $2); }

  | '+' expr %prec REDUCE_PRIORITY { $$ = template("+%s", $2); }
  | '-' expr %prec REDUCE_PRIORITY { $$ = template("-%s", $2); }
  | '(' expr ')'   { $$ = template("(%s)", $2); }
  ;
  
  

value:
  INTEGER
  | BOOL { $$ = strcmp($1, "true") == 0 ? "1" : "0"; }
  | REAL
  | STRING
  ;

dataType: 
  KW_INT    { $$ = "int"; }
  |KW_BOOL { $$ = "int"; }
  |KW_STRING  { $$ = "char*"; }
  ;

  //statements------------
statementList:
  statementComplex                  { $$ = template("%s", $1); }
  | statementList statementComplex { $$ = template("%s\n%s", $1, $2); }
  ;

statementComplexMinusIf:
  ';' {$$ = ";";}
  | statement ';' { $$ = template("%s;", $1); }
  | '{' statementList '}' { $$ = template("%s", $2); }
  | statementFor { $$ = $1; }
  | statementWhile { $$ = $1; }
  | KW_BREAK ';' {$$ = "break;"; }
  | KW_CONTINUE ';' {$$ = "continue;"; }
  | KW_RETURN expr ';' { $$ = template("return %s;", $2); }
  | KW_RETURN ';' {$$ = "return;"; }
  ;
  
statementComplex:
  statementIf {$$=$1;}
  | statementComplexMinusIf {$$=$1;}
  ;
  

statement:
  IDENTIFIER ASSIGN expr    { $$ = template("%s = %s", $1, $3); }
  | expr  { $$ = template("%s", $1); }
  ;

statementFor:
  KW_FOR '(' statement ';' expr ';' statement ')' statementComplex {
    $$ = template("for(%s; %s; %s){\n%s\n}", $3, $5, $7, $9);
  }
  ;

statementWhile:
  KW_WHILE '(' expr ')' statementComplex {
    $$ = template("while(%s){\n%s\n}", $3, $5);
  }
  ;

statementIf:
  KW_IF '(' expr ')' statementComplex {
    $$ = template("if(%s){\n%s\n}", $3, $5);
  }
  | KW_IF '(' expr ')' statementComplex KW_ELSE statementComplexMinusIf {
    $$ = template("if(%s){\n%s\n} \nelse {\n%s\n}", $3, $5, $7);
  }
  | KW_IF '(' expr ')' statementComplex KW_ELSE statementIf {
    $$ = template("if (%s) %s \nelse %s", $3, $5, $7);
  }
  ;


%%
int main () {
  if ( yyparse() != 0 )
    printf("Rejected!\n");
}

