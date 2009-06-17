%{
    #include <stdio.h>
    #include <math.h>
    #include <string.h>
    #include <stdlib.h>
    #include "calculadora.h"
    #include "Stack.h"

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
    int count_if = 0;
    Stack *if_stack;
    %}

%union {
    tabelaSimb *tb;
    int ival;
}

%token <tb> ATOMO
%token SQRT EXP AJUDA
%token IF
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
        | SQRT '(' expressao ')' {
          tabelaSimb *s = nova_ts();
	  s->tipo = tipoFloat;
	  s->val = sqrt($3->val);
	  $$ = s;
                                 }

        | EXP '(' expressao ')' {
          tabelaSimb *s = nova_ts();
	  s->tipo = tipoFloat;
	  s->val = exp($3->val);
	  $$ = s;
                                 }
        | '(' expressao ')'         { $$ = $2; }
        ;

ajuda:
     AJUDA {
            printf("Projeto: Calc v2\n"
                   "Disciplina Compiladores - UPE/POLI - Recife - Prof. Ruben C. Benante\n"
                   "Eng. da computacao / 2009\n"
                   "Autores: Ed Prado, Edinaldo Santos, Elton Oliveira, Marlon Chalegre, Rodrigo Castro\n\n"
                   "Exemplos:\n\n"
                   "\tOperacoes basicas:\n"
                   "\tExemplo: 3 + 4;\n"
                   "\tSao aceitas as operacoes '+' '-' '*' '/' '%' '-' (menos unario)\n"
                   "\tParentesis podem ser usados para especificar a precedencia de uma expressao.\n\n"
                   "\tOperadores relacionais:\n"
                   "\tExemplo: 3 > 4\n"
                   "\tSao aceitos os aperadores '>' '>=' '<' '<=' '==' '!='\n\n"
                   "\tFuncao raiz:\n"
                   "\tExemplo: raiz(n);\n"
                   "\tCalcula a raiz quadrada de n. Onde n eh um numero inteiro ou real.\n\n"
                   "\tFuncao exp:\n"
                   "\tExemplo: exp(x);\n"
                   "\tCalcula e elevado a x\n\n"
                   "\tAtribuicao de variaveis:\n"
                   "\tExemplo: A = 4;\n"
                   "\tNome de variaveis sao formados por uma unica letra maiuscula.\n"
                   "\tA ate L: variaveis inteiras\n"
                   "\tM ate Z: variaveis reais\n\n"
                   "\tControle de fluxo:\n"
                   "\tExemplo: se (condicao) entao 3 + 3; senao 6 + 8;\n"
                   "\tCalcula 3 + 3 se condicao for verdadeira. Caso contrario, calcula 6 + 8.\n\n"
                   "\tFuncao imprima:\n"
                   "\tExemplo: imprima 3 + 4;\n"
                   "\tImprime valores constantesm expressoes ou variaveis (ou combinacoes destes).\n\n"
                   "\tFuncao saia:\n"
                   "\tExemplo: saia\n"
                   "\tTermina a execucao da calculadora.\n"
                  );
           }

sentenca:
        IMPRIMA expressao ';'
	{if(!if_flag || (if_flag && then_flag)) printf("%f\n", $2->val);}
        ;

if_then:
	   {
            count_if++;
            if_flag = 1;
	    then_flag = expl_val;
            push(if_stack, then_flag);
           }
	     ;
end_if:
	   {
            if (--count_if == 0)
                if_flag = 0;
            then_flag = 0;
           }
 ;

selecao: 
	     IF '(' expressao_logica ')' THEN if_then instrucao end_if
	   | IF '(' expressao_logica ')' THEN if_then instrucao ELSE {then_flag = !pop(if_stack);} instrucao end_if
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
    SAIA { exit(0); }
    ;

instrucao:
	selecao
        | ajuda
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
    if_stack = init_stack();
    yyparse();
}
