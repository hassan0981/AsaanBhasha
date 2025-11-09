%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

FILE *tokenization;
FILE *errors;

int is_keyword(const char *s) {
    const char *kw[] = {
        "agar","warna","bolay","warnaagar","Hukamkaray","thehrjao",
        "ank","shabt","jabtuk","Hannaa","Shudh","jhoot",
        "lotaao","challay","karo"
    };
    size_t n = sizeof(kw)/sizeof(kw[0]);
    for (size_t i = 0; i < n; i++) {
        const char *a = s;
        const char *b = kw[i];
        int same = 1;
        while (*a || *b) {
            if (*a != *b) {
                same = 0;
                break;
            }
            a++;
            b++;
        }
        if (same && *a == '\0' && *b == '\0')
            return 1;
    }
    return 0;
}
%}

%option noyywrap

%option yylineno

LETTER     [A-Za-z]

DIGIT      [0-9]

STR        \"([^\"\\]|\\.)*\"

FRAC       \.{DIGIT}+

CHAR       \'([^\'\\]|\\.)\'

NUMBER     ({DIGIT}+({FRAC})?({EXP})?)|({DIGIT}+{EXP})

EXP        ([eE][+-]?{DIGIT}+)

ID         {LETTER}({LETTER}|{DIGIT})*

INT        {DIGIT}+

%%

[ \t\r]+        ;

\n              ;

"||".*          ;

{STR} {
    fprintf(tokenization, "Line %d: shabt -> %s\n", yylineno, yytext);
    printf("Line %d: shabt -> %s\n", yylineno, yytext);
}

{CHAR} {
    fprintf(tokenization, "Line %d: CHAR -> %s\n", yylineno, yytext);
    printf("Line %d: CHAR -> %s\n", yylineno, yytext);
}

"=="|"="|">"|"<"|"+"|"-"|"*"|"/" {
    fprintf(tokenization, "Line %d: OPERATOR -> %s\n", yylineno, yytext);
    printf("Line %d: OPERATOR -> %s\n", yylineno, yytext);
}

"."|","|"("|")"|"{"|"}" {
    fprintf(tokenization, "Line %d: PUNCTUATION -> %s\n", yylineno, yytext);
    printf("Line %d: PUNCTUATION -> %s\n", yylineno, yytext);
}

{DIGIT}+{LETTER}+({LETTER}|{DIGIT})* {
    fprintf(errors, "Line %d: ERROR -> %s (invalid token)\n", yylineno, yytext);
    fprintf(tokenization, "Line %d: ERROR -> %s (invalid token)\n", yylineno, yytext);
    printf("Line %d: ERROR -> %s (invalid token)\n", yylineno, yytext);
}

{NUMBER} {
    fprintf(tokenization, "Line %d: ANK -> %s\n", yylineno, yytext);
    printf("Line %d: ANK -> %s\n", yylineno, yytext);
}


{ID} {
    if (is_keyword(yytext)) {
        fprintf(tokenization, "Line %d: KEYWORD -> %s\n", yylineno, yytext);
        printf("Line %d: KEYWORD -> %s\n", yylineno, yytext);
    } else {
        fprintf(tokenization, "Line %d: IDENTIFIER -> %s\n", yylineno, yytext);
        printf("Line %d: IDENTIFIER -> %s\n", yylineno, yytext);
    }
}

. {
    fprintf(errors, "Line %d: ERROR -> %s (invalid token)\n", yylineno, yytext);
    fprintf(tokenization, "Line %d: ERROR -> %s (invalid token)\n", yylineno, yytext);
    printf("Line %d: ERROR -> %s (invalid token)\n", yylineno, yytext);
}

%%

int main() {
    tokenization = fopen("tokens.txt", "w");

    if (!tokenization) { printf("Error opening tokens.txt\n"); return 1; }

    errors = fopen("error.txt", "w");

    if (!errors) { printf("Error opening error.log\n"); return 1; }

    yyin = fopen("check.code", "r");

    if (!yyin) { printf("Error opening input.txt\n"); return 1; }

    yylineno = 1;
    
    yylex();

    fclose(yyin);

    fclose(tokenization);

    fclose(errors);

    return 0;
}

