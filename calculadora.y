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
    %}

%union {
    tabelaSimb *tb;
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
%type <tb> expressao_relacional
%type <tb> expressao_logica
%type <tb> atribuicao
%expect 3
%%

programa:
        instrucao 
        ;

atribuicao:
        ATOMO '=' expressao {
                                if ($1->id >= 0 && $1->id < 11) {
                                    /* A - L */
                                    $1->tipo = tipoInt;
                                }
                                else if ($1->id > 10 && $1->id < 26) {
                                    /* M =- Z */
                                    $1->tipo = tipoFloat;
                                }
                                validaTipoAtribuicao($1, $3);
                                ts[$1->id] = $3->val;
			    }
        /*| IDENTIFICADOR '=' atribuicao {
                                            sprintf(command,"\tmov(%s, NULL, &ts[%d]);\n", $3, $1);
                                            enqueue(queue_geral, strdup(command) );
                                            $$ = $3;
                                          }*/
        ;

expressao_relacional:
        expressao '>' expressao {
                                        sprintf(command,"\tcomp_gt(%s, %s, &tp[%d]);\n", $1->tval, $3->tval, tp_count++);
                                        $$ = mnemonico($1, $3, strdup(command));
                                }

	| expressao '<' expressao {
                                        sprintf(command, "\tcomp_lt(%s, %s, &tp[%d]);\n", $1->tval, $3->tval, tp_count++);
                                        $$ = mnemonico($1, $3, strdup(command));
                                  }

	| expressao MENORIGUAL expressao {
                                            sprintf(command, "\tcomp_le(%s, %s, &tp[%d]);\n", $1->tval, $3->tval, tp_count++);
                                            $$ = mnemonico($1, $3, strdup(command));
                                         }

	| expressao MAIORIGUAL expressao {
                                            sprintf(command, "\tcomp_ge(%s, %s, &tp[%d]);\n", $1->tval, $3->tval, tp_count++);
                                            $$ = mnemonico($1, $3, strdup(command));
                                         }

	| expressao IGUAL expressao {
                                        sprintf(command, "\tcomp_eq(%s, %s, &tp[%d]);\n", $1->tval, $3->tval, tp_count++);
                                        $$ = mnemonico($1, $3, strdup(command));
                                    }

        | expressao DIFERENTE expressao {
                                            sprintf(command, "\tcomp_ne(%s, %s, &tp[%d]);\n", $1->tval, $3->tval, tp_count++);
                                            $$ = mnemonico($1, $3, strdup(command));
                                        }
        ;

expressao:
        ATOMO                       { 
                                        tabelaSimb *s = alloc_tabelaSimb();
                                        s->tval = strdup($1->tval);
                                        s->tipoD = $1->tipoD;
                                        if (!$1->load) {
                                            load($1);
                                        }

                                        $$ = s; 
                                    }
        | FUNCAO '(' lista_parametros ')' {
                                        tabelaSimb *s = alloc_tabelaSimb();
                                        if ($1->tipoD == tipoIdFuncVoid) {
                                            sprintf(command, "\tcall(\"%s\", %d, NULL);\n", $1->idNome, numParam, tp_count++);
                                            enqueue(queue_geral, strdup(command));
                                            s->tval = "";
                                        }
                                        else {
                                            sprintf(command, "\tcall(\"%s\", %d, &tp[%d]);\n", $1->idNome, numParam, tp_count++);
                                            enqueue(queue_geral, strdup(command));
                                            sprintf(command, "tp[%d]", tp_count-1);
                                            s->tval = strdup(command);
                                        }
                                        $1->numParam = numParam;
                                        numParam = 0;
                                        
                                        s->tipoD = $1->tipoD;
                                        $$ = s;
                                      }

        /*| IDENTIFICADOR             { 
                                        tabelaSimb *s = alloc_tabelaSimb();
                                        s->tval = strdup($1->tval);
                                        s->tipoD = $1->tipoD;

                                        $$ = s;
                                    }*/

        | expressao '+' expressao   {
                                        sprintf(command,"\tadd(%s, %s, &tp[%d]);\n", $1->tval, $3->tval, tp_count++);
                                        $$ = mnemonico($1, $3, strdup(command));
                                    }

        | expressao '-' expressao   {
                                        sprintf(command,"\tsub(%s, %s, &tp[%d]);\n", $1->tval, $3->tval, tp_count++);
                                        $$ = mnemonico($1, $3, strdup(command));
                                    }

        | expressao '*' expressao   { 
                                        sprintf(command,"\tmult(%s, %s, &tp[%d]);\n", $1->tval, $3->tval, tp_count++);
                                        $$ = mnemonico($1, $3, strdup(command));
                                    }

        | expressao '/' expressao   {
                                        sprintf(command,"\tdivi(%s, %s, &tp[%d]);\n", $1->tval, $3->tval, tp_count++);
                                        $$ = mnemonico($1, $3, strdup(command));
                                    }

        | expressao '%' expressao   {
                                        sprintf(command,"\tmod(%s, %s, &tp[%d]);\n", $1->tval, $3->tval, tp_count++);
                                        $$ = mnemonico($1, $3, strdup(command));
                                    }

        | '-' expressao %prec UMINUS {
                                        sprintf(command,"\tuminus(%s, NULL, &tp[%d]);\n", $2->tval, tp_count++);
                                        $$ = mnemonico($2, NULL, strdup(command));
                                     }

        | '(' expressao ')'         { $$ = $2; }
        ;

sentenca:
        IMPRIMA '(' ATOMO ')' ';' {
                            sprintf(command, "\tparam(%s, NULL, NULL);\n", $2->tval); 
                            enqueue(queue_geral,strdup(command));
                            sprintf(command, "\tcall(\"imprima\", 1, NULL);\n");
                            enqueue(queue_geral,strdup(command));
                          }
        | IMPRIMA IDENTIFICADOR ';' {

                                        sprintf(command, "\tparam(%s, NULL, NULL);\n", $2->tval); 
                                        enqueue(queue_geral,strdup(command));
                                        sprintf(command, "\tcall(\"imprima\", 1, NULL);\n");
                                        enqueue(queue_geral,strdup(command));
                                    }
        ;

lista_parametros:
                /* Lista vazia. Funcao sem parametros. */
                | '&'ATOMO {
                            if (!$2->load) {
                                load($2);
                            }
                            sprintf(command, "\tparam(NULL, NULL, &%s);\n", $2->tval);
                            enqueue(queue_geral, strdup(command));
                            numParam++;

                           }
                | expressao {
                            //if (!$1->load) {
                            //    load($1);
                            //}
                            sprintf(command, "\tparam(&%s, NULL, NULL);\n", $1->tval);
                            enqueue(queue_geral, strdup(command));
                            numParam++;
                        }
                | '&'ATOMO ',' lista_parametros {
                                                    if (!$2->load) {
                                                        load($2);
                                                    }
                                                    sprintf(command, "\tparam(NULL, NULL, &%s);\n", $2->tval);
                                                    enqueue(queue_geral, strdup(command));
                                                    numParam++;
                                                }
                | expressao ',' lista_parametros {
                                                //if (!$1->load) {
                                                //    load($1);
                                                //}
                                                sprintf(command, "\tparam(&%s, NULL, NULL);\n", $1->tval);
                                                enqueue(queue_geral, strdup(command));
                                                numParam++;
                                             }
                ;

label_para_inicio: {
                        sprintf(command, " l%d:\n", (*l)++);
                        enqueue(queue_geral, strdup(command));
                   }
                   ;

posicionar_segunda_atribuicao:
                    {
                        char *value;
                        Stack *stack_tmp = init_stack();
                        int *label = (int *) pop(stack_para_label);

                        value = (char *) pop(stack_para_atribuicao);
                        while (strcmp(value, "fim") && !is_stack_empty(stack_para_atribuicao)) {
                            push(stack_tmp, (void *) value);
                            value = (char *) pop(stack_para_atribuicao);
                        }

                        while (!is_stack_empty(stack_tmp)) {
                            value = (char *) pop(stack_tmp);
                            enqueue(queue_geral, value);
                        }

                        sprintf(command, "\tjump(NULL, NULL, l%d);\n", *label-1);
                        enqueue(queue_geral, strdup(command));
                        sprintf(command, " l%d:\n", *label);
                        enqueue(queue_geral, strdup(command));
                    }
                    ;

retirar_segunda_atribuicao:
                     {
                        char *value; 
                        enqueue(queue_geral, "fim_atribuicao_para");

                        while (!is_queue_empty(queue_geral)) {
                            value = dequeue(queue_geral);
                            if (!strcmp(value, "inicio_atribuicao_para"))
                                break;
                            enqueue(queue_geral, value);
                        }
                        push(stack_para_atribuicao, (void *) "fim");
                        while (!is_queue_empty(queue_geral)) {
                            value = dequeue(queue_geral);
                            if (!strcmp(value, "fim_atribuicao_para"))
                                break;
                            push(stack_para_atribuicao, (void *) value);
                        }
                     }
                     ;

marcar_inicio_atribuicao:
                        {
                            push(stack_para_label, (void *) copy_int(l));
                            sprintf(command,"\tjump_f(tp[%d], NULL, l%d);\n", tp_count-1, (*l)++);
                            enqueue(queue_geral,strdup(command));
                            enqueue(queue_geral, "inicio_atribuicao_para"); 
                        }
                        ;

para:
    PARA '(' atribuicao ';' label_para_inicio expressao_logica ';' marcar_inicio_atribuicao atribuicao retirar_segunda_atribuicao ')' instrucao posicionar_segunda_atribuicao
    ;

label_enquanto_inicio: {
                            sprintf(command, " l%d:\n", (*l)++);
                            enqueue(queue_geral,strdup(command));
                       }
                       ;
label_enquanto_fim: {
                        int *label = (int *) pop(stack_enquanto);
                        sprintf(command, "\tjump(NULL, NULL, l%d);\n", *label-1);
                        enqueue(queue_geral,strdup(command));
                        sprintf(command, "l%d:\n", *label); 
                        enqueue(queue_geral,strdup(command));
                        free(label);
                    }
                    ;
inicio_enquanto: {
                    push(stack_enquanto,(void *) copy_int(l));
                    sprintf(command,"\tjump_f(tp[%d], NULL, l%d);\n", tp_count-1, (*l)++);
                    enqueue(queue_geral,strdup(command));
                 }
                 ;
enquanto:
        ENQUANTO '(' label_enquanto_inicio expressao_logica ')' inicio_enquanto instrucao label_enquanto_fim
        ;

inicio_selecao: {
                push(stack_if, (void *) copy_int(l));
                sprintf(command,"\tjump_f(tp[%d], NULL, l%d);\n", tp_count-1, (*l)++);
                enqueue(queue_geral,strdup(command));
                count_if_else++;
           }
           ;

label_selecao: {
                    int *label = (int *) pop(stack_if);
                    sprintf(command, " l%d:\n", *label);
                    enqueue(queue_geral,strdup(command));
                    free(label);
               }
               ;
bloco_selecao: {
                    enqueue(queue_geral,"jump_incondicional");
               }
               ;
selecao: 
	IF '(' expressao_logica ')' inicio_selecao THEN instrucao label_selecao
        | IF '(' expressao_logica ')' inicio_selecao THEN instrucao ELSE bloco_selecao label_selecao instrucao
	;

expressao_logica:
                expressao_relacional {
                                        //sprintf(command, "tp[%d]", tp_count-1);
                                        $$ = $1; 
                                     }

                | expressao_relacional AND expressao_logica {
                                                                sprintf(command, "\trela_an(%s, %s, &tp[%d]);\n", $1->tval, $3->tval, tp_count++);
                                                                $$ = mnemonico($1, $3, strdup(command));
                                                            }
                | expressao_logica AND expressao_relacional { 
                                                                sprintf(command, "\trela_an(%s, %s, &tp[%d]);\n", $1->tval, $3->tval, tp_count++);
                                                                $$ = mnemonico($1, $3, strdup(command));
                                                            }
                | expressao_logica OR expressao_relacional {
                                                                sprintf(command, "\trela_or(%s, %s, &tp[%d]);\n", $1->tval, $3->tval, tp_count++);
                                                                $$ = mnemonico($1, $3, strdup(command));
                                                           }
                | expressao_relacional OR expressao_logica {
                                                                sprintf(command, "\trela_or(%s, %s, &tp[%d]);\n", $1->tval, $3->tval, tp_count++);
                                                                $$ = mnemonico($1, $3, strdup(command));
                                                           }
                | NOT expressao_logica {
                                            sprintf(command, "\trela_no(%s, NULL, &tp[%d]);\n", $2->tval, tp_count++);
                                            $$ = mnemonico($2, NULL, strdup(command));
                                       }

                | '(' expressao_logica ')' { $$ = $2; }
                ;

saia:
    SAIA ';' { exit(0); }
    ;

instrucao:
	selecao { 
                    count_if_else--;
                    if (!count_if_else) { // label de jump incondicional
                        fprintf(file, " l%d:\n", (*l)++);
                        fflush(file);
                    }
                }
        | enquanto 
        | para
        | saia
        | expressao_logica
//        | sentenca { if (count_if_else == 0) desempilhar(); }
	| atribuicao ';' { if (count_if_else == 0) desempilhar(); } 
        | expressao ';' { if (count_if_else == 0) desempilhar(); } 
        | ';' 
	;
%%

tabelaSimb *alloc_tabelaSimb() {
    tabelaSimb *s = (tabelaSimb *) malloc(sizeof(tabelaSimb));
    return s;
}

void validaTipoAtribuicao(tabelaSimb *s1, tabelaSimb *s2) {
    switch (s1->tipoD) {
        case tipoInt:
            if (s2->tipoD != tipoInt) {
                yyerror("Impossivel atribuir <tipoFloat> a uma variavel <tipoInt>.");
            }
            break;
        case tipoFloat:
            if (s2->tipoD != tipoFloat) {
                yyerror("Impossivel atribuir <tipoInt> a uma variavel <tipoFloat>.");
            }
            break;
            break;
        default:
            yyerror("Atribuicao invalida.");
    }
}

tipoDado defineTipo(tabelaSimb *s1, tabelaSimb *s2) {
    tipoDado tipo;

    switch (s1->tipoD) {
        case tipoFloat:
            tipo = tipoFloat;
            break;
        case tipoInt:
            if (s2->tipoD == tipoFloat) {
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
    file = fopen("Portugol.c","w");
    iniciarTabelaSimb();
    
    l = malloc(sizeof(int));
    *l = 1;

    stack_if = init_stack();
    stack_enquanto = init_stack();
    stack_para_label = init_stack();
    stack_para_atribuicao = init_stack();
    queue_geral = init_queue();

    if(!file){
        printf("O arquivo nao pode ser aberto!\n");
        exit(1);
    }
    
    geraSaidaTemplate(file);

    FILE *yyin;
    if (argc > 1) {
        if ((yyin = fopen(argv[1], "r")) == NULL) {
            printf("erro ao ler arquivo de entrada.\n");
            exit(1);
        }
        yyrestart(yyin); 
    }
            
    yyparse();
    if (argc > 1) fclose(yyin);    

    fprintf(file,"}\n\n");
    criar_filltf();
    fclose(file);
    geraSaidaH();
}
