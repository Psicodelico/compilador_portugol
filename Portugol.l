variavel [a-zA-Z]([a-zA-Z0-9]|_)*
num [0-9]
tipo ("int"|"real")

%{
    #include "quadruplas.h"
    #include "y.tab.h"
    #include <stdlib.h>
    void yyerror(char *);
    extern char msg[80];

%}
%%

((\/\/[^\n]*\n)|\n) { yylineno++; } 

sqrt        { return SQRT; }
"inicio"    { return INICIO; }
"fim"       { return FIM; }
"int"       { return INT; }
"real"      { return FLOAT; }
"texto"     { return TEXTO; }
"se"        { return IF; }
"entao"     { return THEN; }
"enquanto"  { return ENQUANTO; }
"para"      { return PARA; }
"senao"     { return ELSE; }
"imprima"   { return IMPRIMA; }
"aborte"    { return ABORTE; }
"saia"      { return SAIA; }
"e"         { return AND; }
"ou"        { return OR; }
"nao"       { return NOT; }
;           { return *yytext;}

{variavel} { 
                yylval.tb = achaId(yytext);
                return ATOMO;
           }

{num}+     {                    
                int val = atoi(yytext);
                yylval.tb = achaInt(val);
                return ATOMO;
           } 

{num}*\.{num}+ {
                    float val = atof(yytext);
                    yylval.tb = achaFloat(val);
                    return ATOMO;
               }

\"[^"\n]*["\n] {
                    char *val = strdup(yytext+1);
                    if (val[yyleng-2] != '"')
                        yyerror("String terminada incorretamente.");
                    else
                        val[yyleng-2] = '\0';
                    yylval.tb = achaStr(val);
                    return ATOMO;
               }


"<="        {return MENORIGUAL;}
">="        {return MAIORIGUAL;}
"=="        {return IGUAL;}
"!="        {return DIFERENTE;}

[-+><()=/*] { return *yytext; }

[ \t\n\r]*    {;/*Ignora espaço em branco */}

                
.           {
                sprintf(msg, "Caracter Desconhecido: '%s' (%d)", yytext, yytext[0]);
                yyerror(msg);
            }

%%

int yywrap(void) {
    return 1;
}
