%{
    #include "y.tab.h"
    #include <stdlib.h>
    void yyerror(char *);
%}

%%

([0-9]+|([0-9]*\.[0-9]+)([eE][+-]?[0-9]+)?) {
                                                yylval.valor = atof(yytext);
                                                return VALOR;
                }

[-+()=/*\n]     { return *yytext; }

[ \t]   ;       /*Ignora espaço em branco */

raiz {return SQRT;}

[a-z]           { yylval.index = yytext[0] - 'a';
                  return VARIAVEL;
                }
.               yyerror("Caracter Desconhecido");

%%

int yywrap(void) {
    return 1;
}
