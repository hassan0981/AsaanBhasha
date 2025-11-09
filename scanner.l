%{
#include <stdio.h>
#include <string.h>

FILE *tokens;
FILE *errors;
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

"||".*      ;     /* COMMENT */

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


agar        { fprintf(tokens,"Line %d: KEYWORD → %s\n",yylineno,yytext); }
warna       { fprintf(tokens,"Line %d: KEYWORD → %s\n",yylineno,yytext); }
bolay       { fprintf(tokens,"Line %d: KEYWORD → %s\n",yylineno,yytext); }
warnaagar   { fprintf(tokens,"Line %d: KEYWORD → %s\n",yylineno,yytext); }
Hukamkaray  { fprintf(tokens,"Line %d: KEYWORD → %s\n",yylineno,yytext); }
thehrjao    { fprintf(tokens,"Line %d: KEYWORD → %s\n",yylineno,yytext); }

ank         { fprintf(tokens,"Line %d: KEYWORD → %s\n",yylineno,yytext); }
shabt       { fprintf(tokens,"Line %d: KEYWORD → %s\n",yylineno,yytext); }
jabtuk      { fprintf(tokens,"Line %d: KEYWORD → %s\n",yylineno,yytext); }
Hannaa      { fprintf(tokens,"Line %d: KEYWORD → %s\n",yylineno,yytext); }
Shudh       { fprintf(tokens,"Line %d: KEYWORD → %s\n",yylineno,yytext); }
jhoot       { fprintf(tokens,"Line %d: KEYWORD → %s\n",yylineno,yytext); }

lotaao      { fprintf(tokens,"Line %d: KEYWORD → %s\n",yylineno,yytext); }
challay     { fprintf(tokens,"Line %d: KEYWORD → %s\n",yylineno,yytext); }
karo        { fprintf(tokens,"Line %d: KEYWORD → %s\n",yylineno,yytext); }



{ID}        {
    fprintf(tokens,"Line %d: IDENTIFIER → %s\n",yylineno,yytext);
}


.           {
    fprintf(errors,"Line %d: ERROR invalid token → %s\n",yylineno,yytext);
}

%%


int main() {

    tokens = fopen("tokens.txt", "w");
    errors = fopen("errors.txt", "w");
    yyin = fopen("check.code", "r");

    if (!tokens || !errors || !yyin) {
        printf("File opening error!\n");
        return 1;
    }

    yylex();

    fclose(tokens);
    fclose(errors);
    fclose(yyin);

    return 0;
}
