/* A Bison parser, made by GNU Bison 3.5.1.  */

/* Bison interface for Yacc-like parsers in C

   Copyright (C) 1984, 1989-1990, 2000-2015, 2018-2020 Free Software Foundation,
   Inc.

   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <http://www.gnu.org/licenses/>.  */

/* As a special exception, you may create a larger work that contains
   part or all of the Bison parser skeleton and distribute that work
   under terms of your choice, so long as that work isn't itself a
   parser generator using the skeleton or a modified version thereof
   as a parser skeleton.  Alternatively, if you modify or redistribute
   the parser skeleton itself, you may (at your option) remove this
   special exception, which will cause the skeleton and the resulting
   Bison output files to be licensed under the GNU General Public
   License without this special exception.

   This special exception was added by the Free Software Foundation in
   version 2.2 of Bison.  */

/* Undocumented macros, especially those whose name start with YY_,
   are private implementation details.  Do not rely on them.  */

#ifndef YY_YY_PI_PARSER_TAB_H_INCLUDED
# define YY_YY_PI_PARSER_TAB_H_INCLUDED
/* Debug traces.  */
#ifndef YYDEBUG
# define YYDEBUG 0
#endif
#if YYDEBUG
extern int yydebug;
#endif

/* Token type.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
  enum yytokentype
  {
    KW_INT = 258,
    KW_REAL = 259,
    KW_STRING = 260,
    KW_BOOL = 261,
    BOOL = 262,
    KW_VAR = 263,
    KW_CONST = 264,
    KW_IF = 265,
    KW_ELSE = 266,
    KW_ELSE_IF = 267,
    KW_FOR = 268,
    KW_WHILE = 269,
    KW_BREAK = 270,
    KW_CONTINUE = 271,
    KW_FUNC = 272,
    KW_NIL = 273,
    KW_AND = 274,
    KW_OR = 275,
    KW_NOT = 276,
    KW_RETURN = 277,
    KW_BEGIN = 278,
    ASSIGN = 279,
    STRING = 280,
    INTEGER = 281,
    REAL = 282,
    IDENTIFIER = 283,
    POWER = 284,
    EQ = 285,
    NEQ = 286,
    LT = 287,
    LE = 288,
    GT = 289,
    GE = 290,
    first = 291,
    second = 292,
    third = 293,
    REDUCE_PRIORITY = 294,
    IF = 295
  };
#endif

/* Value type.  */
#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
union YYSTYPE
{
#line 15 "pi_parser.y"

	char* crepr;

#line 102 "pi_parser.tab.h"

};
typedef union YYSTYPE YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define YYSTYPE_IS_DECLARED 1
#endif


extern YYSTYPE yylval;

int yyparse (void);

#endif /* !YY_YY_PI_PARSER_TAB_H_INCLUDED  */
