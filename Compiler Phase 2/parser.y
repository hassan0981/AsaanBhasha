%{
#include <stdio.h>
#include <stdlib.h>

int yylex();
void yyerror(const char *y);
extern int yylineno;
%}

%token AGAR WARNA BOLAY JABTUK CHALLAY KARO WARNA_AGAR
%token ANK SHABT HUKAM THEHRJAO LOTAAO
%token HANNAA SHUDH JHOOT
%token ID NUMBER STRING CHAR

%token EQ ASSIGN GT LT PLUS MINUS MUL DIV INC
%token DOT LPAREN RPAREN LBRACE RBRACE COMMA SEMICOLON

%left PLUS MINUS
%left MUL DIV
%left LT GT EQ

%start Program

%%

Program:
    Block { printf("\nSyntax Analysis Successful!\n"); }
    ;

Block:
    LBRACE StatementList RBRACE
    ;


StatementList:
    Statement StatementList
    | /* empty */
    ;

Statement:
    Declaration
    | Assignment
    | Conditional
    | Loop
    | Input
    | Output
    | Return
    | Stop
    ;

Declaration:
    ANK ID DOT
    | SHABT ID DOT
    | HANNAA ID DOT
    ;

Assignment:
    ID ASSIGN Expression DOT
    ;

LoopAssign:
    ID ASSIGN Expression
    | ID INC  
    ;

Conditional:
    AGAR LPAREN Condition RPAREN Block ElsePart
    ;

ElsePart:
    WARNA Block
  | WARNA_AGAR LPAREN Condition RPAREN Block ElsePart
  | /* empty */
  ;

Loop:
    JABTUK LPAREN Condition RPAREN Block
    | CHALLAY LPAREN LoopAssign SEMICOLON Condition SEMICOLON LoopAssign RPAREN Block
    | KARO Block JABTUK LPAREN Condition RPAREN DOT
    ;

Input:
    HUKAM ID DOT
    ;

Output:
    BOLAY Expression DOT
    ;

Return:
    LOTAAO Expression DOT
    ;

Stop:
    THEHRJAO DOT
    ;

Expression:
    ID
    | NUMBER
    | STRING
    | SHUDH
    | JHOOT
    | Expression PLUS Expression
    | Expression MINUS Expression
    | Expression MUL Expression
    | Expression DIV Expression
    | LPAREN Expression RPAREN
    ;

Condition:
    Expression GT Expression
    | Expression LT Expression
    | Expression EQ Expression
    ;

%%

void yyerror(const char *y) {
    fprintf(stderr, "Syntax Error at line %d: %s\n", yylineno, y);
}

int main() {
    yyparse();
    return 0;
}
