%{
    #include <stdio.h>
    #include <math.h>
    #include <string.h>
    #include <stdlib.h>
    #include "calculadora.h"

    FILE *file;
    void yyerror(char *);
    int yylex(void);
    void validaTipoAtribuicao(tabelaSimb *s1, tabelaSimb *s2);
    tipoDado defineTipo(tabelaSimb *s1, tabelaSimb *s2);
    void verificaUso(tabelaSimb *s);
    int yylineno;
    int if_flag = 0;
    int then_flag = 0;
    int expl_val = 0;
    extern FILE *yyout;
    %}

%union {
    tabelaSimb *tb;
    int ival;
}

%token <tb> ATOMO
%token SQRT
%token IF
%token ENQUANTO PARA
%token IMPRIMA SAIA
%token MAIORIGUAL IGUAL MENORIGUAL DIFERENTE
%right '='
%left '<' '>' MENORIGUAL MAIORIGUAL IGUAL DIFERENTE
%left '%'
%left '+' '-'
%left '*' '/'
%nonassoc UMINUS THEN ELSE AND OR NOT
%type <tb> expressao
%type <ival> expressao_relacional
%type <ival> expressao_logica
%type <tb> atribuicao
%expect 3
%%

programa:
        instrucao
        | programa instrucao 
        ;

atribuicao:
             ATOMO '=' expressao {    if(!if_flag || (if_flag && then_flag)) {
		    
      
                                if ($1->id >= 0 && $1->id < 11) {
                                    /* A - L */
                                    $1->tipo = tipoInt;
                                }
                                else if ($1->id > 10 && $1->id < 26) {
                                    /* M =- Z */
                                    $1->tipo = tipoFloat;
                                }
                                validaTipoAtribuicao($1, $3);
                                $1->val = $3->val;
			    }
		}
        /*| IDENTIFICADOR '=' atribuicao {
                                            sprintf(command,"\tmov(%s, NULL, &ts[%d]);\n", $3, $1);
                                            enqueue(queue_geral, strdup(command) );
                                            $$ = $3;
                                          }*/

        ;

expressao_relacional:
        expressao '>' expressao {
	  defineTipo($1, $3);
	  $$ = $1->val > $3->val;
                                }

	| expressao '<' expressao {
	  defineTipo($1, $3);
	  $$ = $1->val < $3->val;
                                  }

	| expressao MENORIGUAL expressao {
	  defineTipo($1, $3);
	  $$ = $1->val <= $3->val;
                                         }

	| expressao MAIORIGUAL expressao {
	  defineTipo($1, $3);
	  $$ = $1->val >= $3->val;
                                         }


	| expressao IGUAL expressao {
	  defineTipo($1, $3);
	  $$ = $1->val == $3->val;
                                         }


        | expressao DIFERENTE expressao {
	  defineTipo($1, $3);
	  $$ = $1->val != $3->val;

                                        }
        ;

expressao:
        ATOMO                       { 
	  $$ = $1;
              
                                      }

        | expressao '+' expressao   {

	  tabelaSimb *s = nova_ts();
	  s->tipo = defineTipo($1, $3);
	  s->val = $1->val + $3->val;
	  $$ = s;
                                    }

        | expressao '-' expressao   {

	  tabelaSimb *s = nova_ts();
	  s->tipo = defineTipo($1, $3);
	  s->val = $1->val - $3->val;
	  $$ = s;


                                   }

        | expressao '*' expressao   { 
	  tabelaSimb *s = nova_ts();
	  s->tipo = defineTipo($1, $3);
	  s->val = $1->val * $3->val;
	  $$ = s;

                                    }

        | expressao '/' expressao   {
	  tabelaSimb *s = nova_ts();
	  s->tipo = defineTipo($1, $3);
	  if($3->val == 0)
	    yyerror("Divisão por zero.");
	  s->val = $1->val / $3->val;
	  $$ = s;

	  }

| expressao '%' expressao   {
	  tabelaSimb *s = nova_ts();
	  s->tipo = defineTipo($1, $3);
	  s->val = ((int)$1->val) % ((int)$3->val);
	  $$ = s;
                                    }

        | '-' expressao %prec UMINUS {
	  tabelaSimb *s = nova_ts();
	  s->tipo = $2->tipo;
	  s->val = -($2->val);
	  $$ = s;
                                     }

        | '(' expressao ')'         { $$ = $2; }
        ;

sentenca:
        IMPRIMA expressao ';'
	{if(!if_flag || (if_flag && then_flag)) printf("%f\n", $2->val);}
        ;

if_then:
	     { if_flag = 1;
	   then_flag = expl_val;}
	     ;
end_if:
	     {if_flag = 0; then_flag = 0;}
 ;

selecao: 
	     IF '(' expressao_logica ')'THEN if_then instrucao end_if
	     | IF '(' expressao_logica ')'THEN if_then instrucao ELSE {then_flag = !expl_val;} instrucao end_if
	;

expressao_logica:
                expressao_relacional {
                                        $$ = $1; 
		  expl_val = $$;

                                     }

                | expressao_relacional AND expressao_logica {
		  $$ = $1 && $3;
		  expl_val = $$;

                                                            }
                | expressao_logica AND expressao_relacional {
		  $$ = $1 && $3;
		  expl_val = $$;

                                                            }
                | expressao_logica OR expressao_relacional {
		  $$ = $1 || $3;
		  expl_val = $$;

                                                           }
                | expressao_relacional OR expressao_logica {
		  $$ = $1 || $3;
		  expl_val = $$;

                                                           }
                | NOT expressao_logica {
		  $$ = !$2;
		  expl_val = $$;

                                       }

                | '(' expressao_logica ')' {
		  $$ = $2;
		  expl_val = $$;
		}
                ;

saia:
    SAIA ';' { exit(0); }
    ;

instrucao:
	selecao
        | saia
        | expressao_logica ';'
        | sentenca
	| atribuicao ';'
	| expressao ';'
        | ';' 
	;
%%

void validaTipoAtribuicao(tabelaSimb *s1, tabelaSimb *s2) {
    switch (s1->tipo) {
        case tipoInt:
            if (s2->tipo != tipoInt) {
                yyerror("Impossivel atribuir <tipoFloat> a uma variavel <tipoInt>.");
            }
            break;
        case tipoFloat:
            if (s2->tipo != tipoFloat) {
                yyerror("Impossivel atribuir <tipoInt> a uma variavel <tipoFloat>.");
            }
            break;
        default:
            yyerror("Atribuicao invalida.");
    }
}

tipoDado defineTipo(tabelaSimb *s1, tabelaSimb *s2) {
    tipoDado tipo;

    switch (s1->tipo) {
        case tipoFloat:
            tipo = tipoFloat;
            break;
        case tipoInt:
            if (s2->tipo == tipoFloat) {
                tipo = tipoFloat;
            }
            else
                tipo = tipoInt;
            break;
        default:
            yyerror("Tipos incompativeis");
            break; 
    }

    return tipo;
}

void yyerror(char *s) {
    fprintf(stderr, "line %d: %s\n", yylineno, s);
    exit(1);
}

int main(int argc, char **argv) {
    init_ts();
    yyout = stdout;
    
    /*    
    FILE *yyin;
    if (argc > 1) {
        if ((yyin = fopen(argv[1], "r")) == NULL) {
            printf("erro ao ler arquivo de entrada.\n");
            exit(1);
        }
        yyrestart(yyin); 
    }
    */      
    yyparse();
    //    if (argc > 1) fclose(yyin);    

}
