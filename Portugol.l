%{
    #include "y.tab.h"
    #include "Tabela.h"
    #include <stdlib.h>
    #include "quadruplas-v1q.h"
    void yyerror(char *);
    extern char msg[80];
%}
%%

\/\/[^\n]*\n {;} 

sqrt        {return SQRT;}

"inicio"    { return INICIO;}
"fim"       { return FIM; }
"se"        { return IF; }
"entao"     { return THEN; }
"enquanto"  { return ENQUANTO; }
"para"      { return PARA; }
"senao"     { return ELSE; }
"imprima"   { return IMPRIMA; }
"e"         { return AND; }
"ou"        { return OR; }
"nao"       { return NOT; }
;           { return *yytext;}

[A-Z] {
            yylval.sp = ((char) *yytext) - 65;
            return IDENTIFICADOR;
      }

([0-9]+|([0-9]*\.[0-9]+)) {
                            char buf[40];
                            //float in = atof(yytext);
                            sprintf(buf, "%.2f", atof(yytext));
                            yylval.texto = strdup(buf);
                            return TEXTO;
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
