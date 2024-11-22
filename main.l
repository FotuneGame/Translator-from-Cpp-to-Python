%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "main.tab.h"
%}



%%

^#include.*$ {}
^#define.*$ {}
^using.*$ {}

"std" {}
"std::" {}

"void" {return TYPE;}
"int" {return TYPE;}
"float" {return TYPE;}
"double" {return TYPE;}
"char" {return TYPE;}
"bool" {return TYPE;}
"string" {return TYPE;}

"int*" {return POINT_TYPE;}
"float*" {return POINT_TYPE;}
"double*" {return POINT_TYPE;}
"char*" {return POINT_TYPE;}
"bool*" {return POINT_TYPE;}
"string*" {return POINT_TYPE;}

"long" {}
"const" {}
"unsigned" {}

"nullptr" {return NULLPTR;}
"true" {return TRUE;}
"false" {return FALSE;}
"switch" {return SWITCH;}
"case" {return CASE;}
"default" {return DEFAULT;}
"break" {return BREAK;}
"contuine" {return CONTINUE;}
"return" {return RETURN;}
"for" {return FOR;}
"while" {return WHILE;}
"if" {return IF;}
"else if" {return ELSEIF;}
"else" {return ELSE;}
"do" {}

"cin" {return CIN;}
"cout" {return COUT;}

[0-9]+ {
    yylval.number = atof(yytext);
    return NUMBER;
}

[0-9]*\.[0-9]* {
    yylval.number = atof(yytext);
    return NUMBER;
}

[_a-zA-Z][_a-zA-Z0-9]* {
    strcpy(yylval.var, yytext);
    return NAME;
}

"?" {return QUESTION;}
":" {return DOUBLEPOINT;}
"<<" {return OUT;}
">>" {return IN;} 
"{" { return LBRACE; }
"}" { return RBRACE; }
"(" { return LPAREN; }
")" { return RPAREN; }
";" { return SEMICOLON; }
"," { return COMMA; }
"<=" { return LE; }
">=" { return GE; }
"==" { return EQ; }
"!=" { return NE; }
"<"  { return LT; }
">"  { return GT; }
"=" { return ASSIGN; }
"+"  { return PLUS; }
"-"  { return MINUS; }
"*"  { return MUL; }
"/"  { return DIV; }
"&"  { return BYTEAND; }
"%"  { return REMDIV; }
"|"  { return BYTEOR; }
"^"  { return BYTEXOR; }
"!"  { return NOT; }
"&&"  { return AND; }
"||"  { return OR; }
"\""  { return DOBLEBUCKET; }
"'"  { return BUCKET; }


[ \t\n\r] { /* Игнорируем пробелы и переводы строк */ }

%%




int yywrap(void) {
    return 1;
}
