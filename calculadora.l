variavel [A-Z]
int [0-9]
float ([0-9]*\.[0-9]+)([eE][-+]?[0-9]+)?

%{
    #include <stdlib.h>
    #include <string.h>
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
;           { return *yytext;}

{variavel} { 
                yylval. = achaId(yytext);
                return ATOMO;
           }

{int}+     {                    
                int val = atoi(yytext);
                yylval.ival = val;
                return ATOMO;
           } 

{float}    {
                float val = atof(yytext);
                yylval.fval = val;
                return ATOMO;
           }

{variavel}[ \t]*\(  {
                        char *val = strdup(yytext); 
                        val[yyleng-1] = '\0';
                        trim(val); /* Elimina espacos e tabulacoes extras */
                        yyless(yyleng-1);
                        if (!strcmp(val, "ou")) {
                        //    yyless(yyleng-1);
                            return OR;
                        }
                        else if (!strcmp(val, "e")) {
                        //    yyless(yyleng-1);
                            return AND;
                        }
                        else if (!strcmp(val, "nao")) {
                         //   yyless(yyleng-1);
                            return NOT;

                        }
                        else if (!strcmp(val, "para")) {
                        //    yyless(yyleng-1);
                            return PARA;
                        }
                        else if (!strcmp(val, "enquanto")) {
                        //    yyless(yyleng-1);
                            return ENQUANTO;
                        }
                        else if (!strcmp(val, "se")) {
                        //    yyless(yyleng-1);
                            return IF;
                        }
                        else if (!strcmp(val, "aborte")) {
                        //    yyless(yyleng-1);
                            return ABORTE;
                        }
                        yylval.tb = achaFuncs(val);
                        return FUNCAO;
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

[-+><()=/*,&%] { return *yytext; }

[ \t\r]*    {;/*Ignora espaço em branco */}

                
.           {
                sprintf(msg, "Caracter Desconhecido: '%s' (%d)", yytext, yytext[0]);
                yyerror(msg);
            }

%%

int yywrap(void) {
    return 1;
}
