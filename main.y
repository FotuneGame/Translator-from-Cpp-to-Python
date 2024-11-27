%{
 #include <stdio.h>
 #include <stdlib.h>
 #include <string.h>

 extern FILE* yyin;
 extern FILE* yyout;

 int yylex();
 void yyerror(char *s);

 //Debug mode 
 int yydebug = 0;

 //Кол-во tab
int tab_level = 0;
char* gen_tabs();
%}



%union{
    char var[4098];
    char constant_lexems[32];
    char nonterm[64];
    double numberf;
    int number; 
}

%token<number> NUMBER;
%token<numberf> NUMBERF;
%token<var> TYPE POINT_TYPE NAME;
%token<constant_lexems> NULLPTR TRUE FALSE SWITCH CASE DEFAULT BREAK CONTINUE RETURN FOR WHILE IF ELSEIF ELSE DO CIN COUT;
%token <data> LBRACE RBRACE LPAREN RPAREN SEMICOLON COMMA BYTEAND BYTEOR BYTEXOR;
%token <data> LE GE  EQ NE LT GT ASSIGN PLUS MINUS MUL DIV REMDIV;
%token <data> NOT AND OR;
%token <data> OUT IN;
%token <data> DOBLEBUCKET BUCKET;
%token <data> QUESTION DOUBLEPOINT;

%left QUESTION DOUBLEPOINT
%left PLUS MINUS
%left MUL DIV REMDIV
%left BYTEAND BYTEOR BYTEXOR
%left NOT AND OR
%right ASSIGN
%left EQ NE LT LE GT GE
%left LPAREN RPAREN


%type<nonterm> program rule rule_func func args body statements
%type<nonterm> declar expression variable_create variable_use out_exp in_exp args_value func_call
%type<nonterm> branching if_stmt elseif_stmt else_stmt if_branch elseif_list elseif_branch else_branch 
%type<nonterm> while_branch while_stmt for_branch for_stmt

%type<nonterm> switch_branch switch_stmt case_default_branch case_default_list case_stmt default_stmt

%type<nonterm> assign_stmt

%start program




%%

program: rule {
    fprintf(yyout,"import sys\n");
    fprintf(yyout,"\n");
    fprintf(yyout,"%s",$1);

    fprintf(yyout,"\n\n\n");
    fprintf(yyout,"if __name__ == \"__main__\":\n\tmain()\n");
}

rule: 
    rule_func {
        sprintf($$,"%s\n",$1);
    }
    | rule rule_func {
        sprintf($$,"%s\n%s",$1,$2);
    }

rule_func: 
    func LPAREN RPAREN SEMICOLON{
        sprintf($$,"");
    }
    | func LPAREN args RPAREN SEMICOLON {
        sprintf($$,"");
    }
    | func LPAREN RPAREN LBRACE body RBRACE{
        sprintf($$,"def %s():\n%s",$1,$5);
    }
    | func LPAREN RPAREN LBRACE RBRACE{
        sprintf($$,"def %s():\n\treturn 0\n",$1);
    }
    | func LPAREN args RPAREN LBRACE body RBRACE{
        sprintf($$,"def %s(%s):\n%s",$1,$3,$6);
    }
    | func LPAREN args RPAREN LBRACE RBRACE{
        sprintf($$,"def %s(%s):\n\treturn 0\n",$1,$3);
    }

func: TYPE NAME {sprintf($$,"%s",$2);}
    | POINT_TYPE NAME {sprintf($$,"%s",$2);}

args: func {sprintf($$,"%s",$1);}
    | args COMMA func {sprintf($$, "%s, %s", $1, $3);}

body: statements {
    sprintf($$,"\t%s\n",$1);
}
| body statements {
    if(tab_level<0)tab_level = 0;
    char* tabs = gen_tabs();
    sprintf($$,"%s\t%s%s\n",$1,tabs,$2);
    free(tabs);
}




statements: declar SEMICOLON {sprintf($$,"%s = None",$1);}
| declar assign_stmt expression SEMICOLON {sprintf($$,"%s %s %s",$1, $2, $3);} 
| RETURN expression SEMICOLON {sprintf($$, "return %s",$2);}
| RETURN SEMICOLON {sprintf($$, "return");}
| BREAK SEMICOLON {sprintf($$,"break");}
| CONTINUE SEMICOLON {sprintf($$,"continue");}
| COUT OUT out_exp SEMICOLON {sprintf($$,"print(%s)",$3);}
| CIN IN in_exp SEMICOLON {sprintf($$,"%s",$3);}
| func_call SEMICOLON {sprintf($$,"%s",$1);}
| branching {sprintf($$,"%s",$1);}


branching: if_branch{sprintf($$,"%s",$1);}
| if_branch else_branch{
    char* tabs = gen_tabs();
    sprintf($$,"%s\t%s%s",$1,tabs,$2);
    free(tabs);
}
| if_branch elseif_branch {
    char* tabs = gen_tabs();
    sprintf($$,"%s\t%s%s",$1,tabs,$2);
    free(tabs);
}
| if_branch elseif_branch else_branch {
    char* tabs = gen_tabs();
    sprintf($$,"%s\t%s%s\t%s%s",$1,tabs,$2,tabs,$3);
    free(tabs);
}
| while_branch {sprintf($$,"%s",$1);}
| for_branch {sprintf($$,"%s",$1);}
| switch_branch {sprintf($$,"%s",$1);}

switch_branch: switch_stmt LBRACE case_default_branch RBRACE {
    char* tabs = gen_tabs();
    sprintf($$,"%s\t%s%s",$1,tabs,$3);
    free(tabs);
    tab_level--;
}
| switch_stmt LBRACE RBRACE {
    tab_level--;
    sprintf($$,"#%s",$1);
}

switch_stmt: SWITCH LPAREN expression RPAREN {tab_level++;sprintf($$,"match (%s):\n",$3);}


case_default_branch: case_default_list {sprintf($$,"%s",$1);}
| case_default_branch case_default_list {
    char* tabs = gen_tabs();
    sprintf($$,"%s\t%s%s",$1,tabs,$2);
    free(tabs);
}

case_default_list: case_stmt DOUBLEPOINT body BREAK SEMICOLON{
    char* tabs = gen_tabs();
    sprintf($$,"%s%s%s",$1,tabs,$3);
    free(tabs);
    tab_level--;
}
| case_stmt DOUBLEPOINT BREAK SEMICOLON{
    tab_level--;
    sprintf($$,"#%s",$1);
}
| default_stmt DOUBLEPOINT body{
    char* tabs = gen_tabs();
    sprintf($$,"%s%s%s",$1,tabs,$3);
    free(tabs);
    tab_level--;
}
| default_stmt DOUBLEPOINT{
    tab_level--;
    sprintf($$,"#case _:");
}

case_stmt: CASE LPAREN expression RPAREN {tab_level++; sprintf($$,"case (%s):\n",$3);}
default_stmt: DEFAULT {tab_level++; sprintf($$,"case _:\n");}



for_branch: for_stmt declar RPAREN LBRACE body RBRACE {
    char* tabs = gen_tabs();
    sprintf($$,"%s%s%s%s%s",$1,tabs,$5,tabs,$2);
    free(tabs);
    tab_level--;
}
| for_stmt declar RPAREN RBRACE{
    char* tabs = gen_tabs();
    sprintf($$,"'''\n%s%s%s%s\n%s'''",tabs,$1,tabs,$2,tabs);
    tab_level--;
    free(tabs);
}
|for_stmt declar assign_stmt expression RPAREN LBRACE body RBRACE {
    char* tabs = gen_tabs();
    sprintf($$,"%s%s%s%s\t%s %s %s",$1,tabs,$7,tabs,$2,$3,$4);
    free(tabs);
    tab_level--;
}
| for_stmt declar assign_stmt expression RPAREN LBRACE RBRACE{
    char* tabs = gen_tabs();
    sprintf($$,"'''\n%s%s%s\t%s  %s %s\n%s'''",tabs,$1,tabs,$2,$3,$4,tabs);
    tab_level--;
    free(tabs);
}

for_stmt:  FOR LPAREN declar SEMICOLON expression SEMICOLON {
    tab_level++;
    char* tabs = gen_tabs();
    sprintf($$,"%s\n%swhile (%s):\n",$3,tabs,$5);
    free(tabs);
}
| FOR LPAREN declar assign_stmt expression SEMICOLON expression SEMICOLON {
    tab_level++;
    char* tabs = gen_tabs();
    sprintf($$,"%s %s %s\n%swhile (%s):\n",$3,$4,$5,tabs,$7);
    free(tabs);
}



while_branch: while_stmt LBRACE body RBRACE {
    char* tabs = gen_tabs();
    sprintf($$,"%s%s%s",$1,tabs,$3);
    free(tabs);
    tab_level--;
}
| while_stmt LBRACE RBRACE{
    tab_level--;
    sprintf($$,"#%s",$1);
}

while_stmt:  WHILE LPAREN expression RPAREN {tab_level++;sprintf($$,"while (%s):\n",$3);}


if_branch: if_stmt LBRACE body RBRACE {
    char* tabs = gen_tabs();
    sprintf($$,"%s%s%s",$1,tabs,$3);
    free(tabs);
    tab_level--;
}
| if_stmt LBRACE RBRACE {
    tab_level--;
    sprintf($$,"#%s",$1);
}

if_stmt: IF LPAREN expression RPAREN {tab_level++;sprintf($$,"if (%s):\n",$3);}



elseif_branch: elseif_list {sprintf($$,"%s",$1);}
| elseif_branch elseif_list {
    char* tabs = gen_tabs();
    sprintf($$,"%s\t%s%s",$1,tabs,$2);
    free(tabs);
}

elseif_list: elseif_stmt LBRACE body RBRACE {
    char* tabs = gen_tabs();
    sprintf($$,"%s%s%s",$1,tabs,$3);
    free(tabs);
    tab_level--;
}
| elseif_stmt LBRACE RBRACE {
    tab_level--;
    sprintf($$,"#%s",$1);
}

elseif_stmt: ELSEIF LPAREN expression RPAREN {tab_level++;sprintf($$,"elif (%s):\n",$3);}


else_branch: else_stmt LBRACE body RBRACE {
    char* tabs = gen_tabs();
    sprintf($$,"%s%s%s",$1,tabs,$3);
    free(tabs);
    tab_level--;
}
| else_stmt LBRACE RBRACE {
    tab_level--;
    sprintf($$,"#%s",$1);
}
else_stmt: ELSE {tab_level++;sprintf($$,"else:\n");}





func_call: NAME LPAREN RPAREN {sprintf($$,"%s()",$1);}
    | NAME LPAREN args_value RPAREN {sprintf($$,"%s(%s)",$1,$3);}

args_value: expression {sprintf($$, "%s", $1);}
    | args_value COMMA expression {sprintf($$, "%s, %s", $1, $3);}



out_exp: expression {sprintf($$,"%s",$1);}
    | out_exp OUT expression {sprintf($$,"%s, %s",$1, $3);}

in_exp: NAME {sprintf($$,"%s = input()",$1)}
    | in_exp IN NAME {sprintf($$,"%s\n\t%s = input()",$1,$3);}



declar: variable_create {sprintf($$,"%s",$1);}
    | declar COMMA variable_create {sprintf($$, "%s = %s", $1, $3);}



expression: variable_use {sprintf($$,"%s",$1);}
    | func_call {sprintf($$,"%s",$1);}
    | expression PLUS expression {sprintf($$,"%s + %s",$1,$3);}
    | expression MINUS expression {sprintf($$,"%s - %s",$1,$3);}
    | PLUS expression {sprintf($$,"+ %s",$2);}
    | MINUS expression {sprintf($$,"- %s",$2);}
    | expression MUL expression {sprintf($$,"%s * %s",$1,$3);}
    | expression DIV expression {sprintf($$,"%s / %s",$1,$3);}
    | expression REMDIV expression {sprintf($$,"%s %% %s",$1,$3);}
    | expression BYTEAND expression {sprintf($$,"%s & %s",$1,$3);}
    | expression BYTEOR expression {sprintf($$,"%s | %s",$1,$3);}
    | expression BYTEXOR expression {sprintf($$,"%s ^ %s",$1,$3);}
    | expression AND expression {sprintf($$,"%s and %s",$1,$3);}
    | expression OR expression {sprintf($$,"%s or %s",$1,$3);}
    | expression NOT expression {sprintf($$,"%s not(%s)",$1,$3);}
    | LPAREN expression RPAREN {sprintf($$,"(%s)",$2);}
    | NOT expression {sprintf($$,"not(%s)", $2);}
    | expression LE expression {sprintf($$,"%s <= %s",$1,$3);}
    | expression GE expression {sprintf($$,"%s >= %s",$1,$3);}
    | expression EQ expression {sprintf($$,"%s == %s",$1,$3);}
    | expression NE expression {sprintf($$,"%s != %s",$1,$3);}
    | expression LT expression {sprintf($$,"%s < %s",$1,$3);}
    | expression GT expression {sprintf($$,"%s > %s",$1,$3);}
    | expression QUESTION expression DOUBLEPOINT expression {sprintf($$,"%s if %s else %s",$1,$3, $5);}

assign_stmt: ASSIGN {sprintf($$,"=");}
| MINUS ASSIGN {sprintf($$,"-=");}
| PLUS ASSIGN {sprintf($$,"+=");}
| MUL ASSIGN {sprintf($$,"*=");}
| DIV ASSIGN {sprintf($$,"/=");}
| REMDIV ASSIGN {sprintf($$,"%%=");}
| BYTEAND ASSIGN {sprintf($$,"= int(%s) &",yylval); if(yydebug) printf("Atantion! &= maybe not normal convert for %s!\n",yylval);}
| BYTEOR ASSIGN {sprintf($$,"= int(%s) |",yylval); if(yydebug) printf("Atantion! |= maybe not normal convert for %s!\n",yylval);}
| BYTEXOR ASSIGN {sprintf($$,"= int(%s) ^",yylval); if(yydebug) printf("Atantion! ^= maybe not normal convert for %s!\n",yylval);}

variable_create: TYPE NAME {sprintf($$,"%s",$2);}
    | POINT_TYPE NAME {sprintf($$,"%s",$2);}
    | NAME {sprintf($$,"%s",$1);}

variable_use: NAME {sprintf($$,"%s",$1);}
    | NUMBERF {sprintf($$,"%lf",$1);}
    | NUMBER {sprintf($$,"%d",$1);}
    | TRUE {sprintf($$,"True");}
    | FALSE {sprintf($$,"False");}
    | DOBLEBUCKET NAME DOBLEBUCKET {sprintf($$,"\"%s\"",$2);}
    | BUCKET NAME BUCKET {sprintf($$,"'%s'",$2);}
    | NULLPTR {sprintf($$,"None");}

%%


char* gen_tabs(){
    char* result = malloc(tab_level*sizeof(char) + 1);
    for(int i = 0; i < tab_level;i++)
        result[i]='\t';
    result[tab_level]='\0';
    return result;
}



int main(int argc, char **argv)
{
    char* filename = "main.cpp";

    if (argc < 2) {
        yydebug = 0;
    }
    else if (argc == 2) {
        if (argv[1][0] == '-' && argv[1][1] == 'd') {
            yydebug = 1;
        }
        else {
            filename = argv[1];
            filename[strlen(filename)] = '\0';
        }
    }
    else if (argc == 3) {
        if (argv[1][0] == '-' && argv[1][1] == 'd') {
            yydebug = 1;
            filename = argv[2];
            filename[strlen(filename)] = '\0';
        }
        else if (argv[2][0] == '-' && argv[2][1] == 'd') {
            filename = argv[1];
            yydebug = 1;
        }
    }
    else {
        printf("Too many arguments, usage: ./translate_program.exe [-d for debug] [filename]");
        return 1;
    }

    yyin = fopen(filename, "r");
    if (!yyin) {
        printf("No such file: %s", filename);
        return 2;
    }
    yyout = fopen("output.py", "w");



    if(yydebug){
        while(yyparse()){
            printf("numb: %lf, str: %s ;\n",yylval,yylval);
        } 
    }



    return 0;
}

void yyerror(char *s)
{
    fprintf(stderr, "error: %s\n", s);
}