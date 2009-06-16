variavel [A-Z]
int [0-9]
float ([0-9]*\.[0-9]+)([eE][-+]?[0-9]+)?

%{
    #include <stdlib.h>
    #include <string.h>
    #include "calculadora.h"
    #include "y.tab.h"

    void yyerror(char *);
    extern char msg[80];

//"imprima"   { return IMPRIMA; }
//"para"      { return PARA; }
//"enquanto"  { return ENQUANTO; }
//"se"        { return IF; }
//"aborte"    { return ABORTE; }
//"saia"      { return SAIA; }
%}
%%

((\/\/[^\n]*\n)|\n) { yylineno++; } 

"se"        { return IF; }
"entao"     { return THEN; }
"senao"     { return ELSE; }
"e"         { return AND; }
"ou"        { return OR; }
"nao"       { return NOT; }
"para"      { return PARA; }
"enquanto"  { return ENQUANTO; }
"saia"      { return SAIA; }
"imprima"   { return IMPRIMA; }
;           { return *yytext; }

{variavel} { 
                int id = ((char) *yytext) - 65;
                yylval.tb = &ts[id];
                return ATOMO;
           }
{int}+     {                    
                int val = atoi(yytext);
                yylval.tb->tipo = tipoInt;
                yylval.tb->val = val;
                return ATOMO;
           } 
{float}    {
                float val = atof(yytext);
                yylval.tb->tipo = tipoFloat;
                yylval.val = val;
                return ATOMO;
           }

"<="        {return MENORIGUAL;}
">="        {return MAIORIGUAL;}
"=="        {return IGUAL;}
"!="        {return DIFERENTE;}

[-+><()=/*%] { return *yytext; }

[ \t\r]*    {;/*Ignora espaço em branco */}

.           {
                sprintf(msg, "Caracter Desconhecido: '%s' (%d)", yytext, yytext[0]);
                yyerror(msg);
            }

%%

int yywrap(void) {
    return 1;
}
