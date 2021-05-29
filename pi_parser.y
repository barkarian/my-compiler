%{
#include <stdlib.h>
#include <stdarg.h>
#include <stdio.h>
#include <string.h>		
#include "cgen.h"

extern int yylex(void);
extern int line_num;
%}

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
   /*
   * logic literals
   */
%token KW_IF
%token KW_ELSE
%token KW_FOR
%token KW_WHILE
%token KW_BREAK
%token KW_CONTINUE
   /*
   * function's literals
   */
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
 
// %token <crepr> STRING

// %token KW_BEGIN
// %token KW_FUNC

// %token ASSIGN

%start program

%type <crepr> decl_list body decl
//constvar
%type <crepr>constDeclaration
%type <crepr>constAssignments
%type <crepr>varDeclaration
%type <crepr>varAssignments
%type <crepr>varAssignment
//assigments expr datatypes etc.
%type <crepr>assignment
%type <crepr>expr
%type <crepr>value
%type <crepr> dataType


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
  |varDeclaration ';' { $$ = template("%s;", $1); }
  ;

body:
%empty { $$="faf";}
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

//functionsDeclaration

//useful everywhere
assignment:
  IDENTIFIER ASSIGN expr                               { $$ = template("%s = %s", $1, $3); }
  | IDENTIFIER '[' INTEGER ']' ASSIGN expr             { $$ = template("%s[%s] = %s", $1, $3, $6); }
  | IDENTIFIER '[' ']' ASSIGN expr                     { $$ = template("*%s = %s", $1, $5); }
  ;

expr: 
  value
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


%%
int main () {
  if ( yyparse() != 0 )
    printf("Rejected!\n");
}

