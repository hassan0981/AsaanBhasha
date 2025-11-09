%{
#include <stdio.h>
#include <string.h>   

FILE *tokens;
FILE *errors;

int is_keyword(const char *word) 
{
    char *keywords[] = {
        "agar","warna","bolay","warnaagar","Hukamkaray","thehrjao",
        "ank","shabt","jabtuk","Hannaa","Shudh","jhoot",
        "lotaao","challay","karo"
    };
    int n = sizeof(keywords)/sizeof(keywords[0]);

    for (int i = 0; i < n; i++) {
        if (strcmp(word, keywords[i]) == 0)
            return 1;
    }
    return 0;
}
%}

%option noyywrap
%option yylineno

LETTER  [A-Za-z]

DIGIT   [0-9]

ID      {LETTER}({LETTER}|{DIGIT})*

NUMBER  {DIGIT}+(\.{DIGIT}+)?([eE][+-]?{DIGIT}+)? 

STR     \"([^\"\\]|\\.)*\"

CHAR    \'([^\'\\]|\\.)\'

%%

[ \t\r]+    ;           
\n          ;            

"||".*      ;           

{STR}       { fprintf(tokens,"Line %d: shabt → %s\n",yylineno,yytext); }

{CHAR}      { fprintf(tokens,"Line %d: CHAR → %s\n",yylineno,yytext); }

"=="|"="|">"|"<"|"+"|"-"|"*"|"/" {
                fprintf(tokens,"Line %d: OPERATOR → %s\n",yylineno,yytext);
            }

"."|","|"("|")"|"{"|"}" {
                fprintf(tokens,"Line %d: PUNCTUATION → %s\n",yylineno,yytext);
            }

{DIGIT}+{LETTER}+({LETTER}|{DIGIT})* {
                fprintf(errors,"Line %d: ERROR invalid token → %s\n",yylineno,yytext);
            }

{NUMBER}    { fprintf(tokens,"Line %d: ANK → %s\n",yylineno,yytext); }

{ID}        {
                if (is_keyword(yytext))
                    fprintf(tokens,"Line %d: KEYWORD → %s\n",yylineno,yytext);
                else
                    fprintf(tokens,"Line %d: IDENTIFIER → %s\n",yylineno,yytext);
            }

.           { fprintf(errors,"Line %d: ERROR invalid token → %s\n",yylineno,yytext); }

%%

int main() {

    tokens = fopen("tokens.txt", "w");

    errors = fopen("errors.txt", "w");

    yyin = fopen("check.code", "r");

    if (!tokens || !errors || !yyin) 
    {
        printf("File opening error!\n");
        return 1;
    }

    yylex();

    fclose(tokens);

    fclose(errors);

    fclose(yyin);

    return 0;
}
