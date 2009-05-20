%{
    #include "y.tab.h"
    #include "Tabela.h"
    #include <stdlib.h>
    void yyerror(char *);
%}

%%

"//"(.)*\n {;}

sqrt            {return SQRT;}

"inicio"		{ return INICIO; }
"fim"			{ return FIM; }
"se"			{ return IF; }
"entao"			{ return THEN; }
"senao"			{ return ELSE; }
;			{ return *yytext;}

[A-Za-z][A-Za-z0-9]* { 

			struct symtab* sp = lookup(yytext,0);
			yylval.sp = sp;						
			return IDENTIFICADOR;
			
		     }

([0-9]+|([0-9]*\.[0-9]+)([eE][+-]?[0-9]+)?) {
                                                yylval.valor = atof(yytext);
                                                return VALOR;
                }

[-+><()=/*\n]     { return *yytext; }

"<="		  {return MENORIGUAL;}
">="		  {return MAIORIGUAL;}
"=="		  {return IGUAL;}

[ \t]   ;       /*Ignora espaço em branco */



.               yyerror("Caracter Desconhecido");

%%

int yywrap(void) {
    return 1;
}
