%{
#include "parser.tab.h"
#include <stdio.h>
%}

%option noyywrap
%option yylineno

LETTER   [A-Za-z]
DIGIT    [0-9]
ID       {LETTER}({LETTER}|{DIGIT})*
NUMBER   {DIGIT}+(\.{DIGIT}+)?([eE][+-]?{DIGIT}+)? 
STR      \"([^\"\\]|\\.)*\"                          
CHAR     \'([^\'\\]|\\.)\'                           

%%

[ \t\r\n]+       ; 
"||".* ; 

"warna agar"    { return WARNA_AGAR; }
"agar"           { return AGAR; }
"warna"          { return WARNA; }
"bolay"          { return BOLAY; }
"jabtuk"         { return JABTUK; }
"challay"        { return CHALLAY; }
"karo"           { return KARO; }
"ank"            { return ANK; }
"shabt"          { return SHABT; }
"Han naa"        { return HANNAA; }
"Shudh"          { return SHUDH; }
"jhoot"          { return JHOOT; }

"Hukamkaray"     { return HUKAM; }
"thehrjao"       { return THEHRJAO; }
"lotaao"         { return LOTAAO; }


"=="             { return EQ; }
"="              { return ASSIGN; }
">"              { return GT; }
"<"              { return LT; }
"++"             { return INC; }
"+"              { return PLUS; }
"-"              { return MINUS; }
"*"              { return MUL; }
"/"              { return DIV; }

"."              { return DOT; }
","              { return COMMA; }
";"              { return SEMICOLON; }
"("              { return LPAREN; }
")"              { return RPAREN; }
"{"              { return LBRACE; }
"}"              { return RBRACE; }

{NUMBER}         { return NUMBER; }
{STR}            { return STRING; }
{CHAR}          { return CHAR; }
{ID}             { return ID; }

.                { printf("Lexical Error at line %d\n", yylineno); }

%%