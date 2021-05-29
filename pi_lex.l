%{
#include <assert.h>
#include <stdio.h>
#include <string.h>
#include "pi_parser.tab.h"
#include "cgen.h"

int line_num = 1;

%}

/*NUMBERS*/
DIGIT  [0-9]
NUM  {DIGIT}+
INTEGER ([1-9]({NUM}*)|0)
DECIMAL (0|{INTEGER})"."{NUM}
REAL [+-]?{DECIMAL}([eE][+-]?{INTEGER})?
/*STRINGS*/
/*STRING  '[^'\n]*'*/
ALLOWED_CHARS     [A-Za-z0-9\-+*\/:_$!#@&~^(),\. ]
ALLOWED_ESCAPES   [ntr\\'\"]
STRING            \"({ALLOWED_CHARS}|{ALLOWED_ESCAPES})*\"
/*IDS*/
ID [a-zA-Z][0-9a-zA-Z_]*

%x comment

%%
   /*
   * Keywords
   */
begin return KW_BEGIN;
func  return KW_FUNC;
   /*
   * type literals
   */
int            return KW_INT;
real           return KW_REAL;
string         return KW_STRING;
bool           return KW_BOOL;
(true|false) { yylval.crepr = strdup(yytext); 
              return BOOL; } //yytext is either true or false 
var            return KW_VAR;
const          return KW_CONST;
   /*
   * logic literals
   */
if          return KW_IF;
else        return KW_ELSE;
for         return KW_FOR;
while       return KW_WHILE;
break       return KW_BREAK;
continue    return KW_CONTINUE;
   /*
   * function's literals
   */
   /*
   * func        return KW_FUNC;
   */
nil         return KW_NIL;
and         return KW_AND;
or          return KW_OR;
not         return KW_NOT;
return      return KW_RETURN;
   /*
   * begin       return KW_BEGIN;
   */

{STRING}    {   yylval.crepr = strdup(yytext);
                return STRING; } //yytext is the string content
{ID}        {   yylval.crepr = strdup(yytext);
                return IDENTIFIER; } //yytext is the string content
{INTEGER}    {  yylval.crepr = strdup(yytext);
                return INTEGER; } //yytext is the string content
{REAL}      {   yylval.crepr = strdup(yytext);
                return REAL; } //yytext is the string content

"="	return ASSIGN;
";" 	return ';';
"," 	return ',';
")"	return ')';
"("	return '(';
"{"	return '{';
"}"	return '}';
"["	return '[';
"]"	return ']';
"+" 	return '+';
"-" 	return '-';
\*\*  return POWER;
"*"   return '*';
"%"   return '%';
"/"   return '/';
==   return EQ;
!=   return NEQ;
\<   return LT;
\<\=  return LE;
\>   return GT;
\>\=  return GE;

"//"[^\n]*  	/* eat line comments */

"/*"		BEGIN(comment);
<comment>[^*\n]*        /* eat anything that's not a '*' */
<comment>"*"+[^*/\n]*   /* eat up '*'s not followed by '/'s */
<comment>\n             ++line_num;
<comment>"*"+"/"        BEGIN(INITIAL);


[ \r\t]		/* skip whitespace */
\n 		++line_num;
<<EOF>> 	return EOF;

.             { yyerror("lexical error: unrecognized literal '%s'\n", yytext); }


%%

// int main ()
// {
//    int token;
//    while ( (token = yylex()) != EOF )
//       printf("Line %d Token %d: %s\n", line_num, token, yytext);
// }

