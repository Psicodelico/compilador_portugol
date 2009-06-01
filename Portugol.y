%{
    #include <stdio.h>
    #include <math.h>
    #include <string.h>
    #include <stdlib.h>
    #include "Tabela.h"
    #include "Fila.h"
    #include "Stack.h"

    FILE *file;
    void yyerror(char *);
    int yylex(void);
    int *copy_int(int *value);
    void desempilhar(void);
    int tp_count = 0;
    int *l;
    int count_if_else = 0;
    int count_para = 0;
    char msg[80];
    Stack *stack_if;
    Stack *stack_enquanto;
    Stack *stack_para_label;
    Stack *stack_para_atribuicao;
    Queue *queue_geral;
%}

%union{
    char *texto;
    int sp;
}

%token <sp> IDENTIFICADOR
%token INICIO FIM
%token <texto> TEXTO
%token SQRT
%token IF
%token ENQUANTO PARA
%token IMPRIMA ABORTE SAIA
%token MAIORIGUAL IGUAL MENORIGUAL DIFERENTE
%right '='
%left '<' '>' MENORIGUAL MAIORIGUAL IGUAL DIFERENTE
%left '+' '-'
%left '*' '/'
%nonassoc UMINUS THEN ELSE AND OR NOT
%type <texto> expressao
%type <texto> expressao_relacional
%type <texto> expressao_logica
%type <texto> atribuicao
%expect 3
%%

programa:
        bloco_instrucao
        ;

atribuicao:
        IDENTIFICADOR '=' expressao {
                                            char command[50];
                                            sprintf(command,"\tmov(%s, NULL, &ts[%d]);\n", $3, $1);
                                            enqueue(queue_geral, strdup(command) );
                                            $$ = $3;
				        }
        | IDENTIFICADOR '=' atribuicao {
                                            char command[50];
                                            sprintf(command,"\tmov(%s, NULL, &ts[%d]);\n", $3, $1);
                                            enqueue(queue_geral, strdup(command) );
                                            $$ = $3;
                                          }
        ;

expressao_relacional:
        expressao '>' expressao {
                                        char command[50];
                                        sprintf(command,"\tcomp_gt(%s, %s, &temp[%d]);\n", $1, $3, tp_count++);
                                        enqueue(queue_geral, strdup(command) );
                                        
                                        sprintf(command, "temp[%d]", tp_count-1);
                                        $$ = strdup(command);
                                }

	| expressao '<' expressao {
                                        char command[50];
                                        sprintf(command, "\tcomp_lt(%s, %s, &temp[%d]);\n", $1, $3, tp_count++);
                                        enqueue(queue_geral, strdup(command) );
                                        
                                        sprintf(command, "temp[%d]", tp_count-1);
                                        $$ = strdup(command);
                                  }

	| expressao MENORIGUAL expressao {
                                            char command[50];
                                            sprintf(command, "\tcomp_le(%s, %s, &temp[%d]);\n", $1, $3, tp_count++);
                                            enqueue(queue_geral, strdup(command));
                                        
                                            sprintf(command, "temp[%d]", tp_count-1);
                                            $$ = strdup(command);
                                         }

	| expressao MAIORIGUAL expressao {
                                            char command[50];
                                            sprintf(command, "\tcomp_ge(%s, %s, &temp[%d]);\n", $1, $3, tp_count++);
                                            enqueue(queue_geral, strdup(command));
                                        
                                            sprintf(command, "temp[%d]", tp_count-1);
                                            $$ = strdup(command);
                                         }

	| expressao IGUAL expressao {
                                        char command[50];
                                        sprintf(command, "\tcomp_eq(%s, %s, &temp[%d]);\n", $1, $3, tp_count++);
                                        enqueue(queue_geral, strdup(command));
                                        
                                        sprintf(command, "temp[%d]", tp_count-1);
                                        $$ = strdup(command);
                                    }

        | expressao DIFERENTE expressao {
                                            char command[50];
                                            sprintf(command, "\tcomp_ne(%s, %s, &temp[%d]);\n", $1, $3, tp_count++);
                                            enqueue(queue_geral, strdup(command));
                                        
                                            sprintf(command, "temp[%d]", tp_count-1);
                                            $$ = strdup(command);
                                        }
        ;

expressao:
        TEXTO

        | IDENTIFICADOR             { 
                                        char buf[40];
                                        sprintf(buf, "ts[%d]", $1);
                                        $$ = strdup(buf);
                                    }

        | expressao '+' expressao   {
                                        char buf[40];
                                        sprintf(buf,"\tadd(%s, %s, &temp[%d]);\n", $1, $3, tp_count++);
                                        enqueue(queue_geral, strdup(buf) );

                                        sprintf(buf, "temp[%d]", tp_count-1);
                                        $$ = strdup(buf);
                                    }

        | expressao '-' expressao   {
                                        char buf[40];
                                        sprintf(buf,"\tsub(%s, %s, &temp[%d]);\n", $1, $3, tp_count++);
                                        enqueue(queue_geral, strdup(buf) );

                                        sprintf(buf, "temp[%d]", tp_count-1);
                                        $$ = strdup(buf);
                                    }

        | expressao '*' expressao   { 
                                        char buf[40];
                                        sprintf(buf,"\tmult(%s, %s, &temp[%d]);\n", $1, $3, tp_count++);
                                        enqueue(queue_geral, strdup(buf) );

                                        sprintf(buf, "temp[%d]", tp_count-1);
                                        $$ = strdup(buf);
                                    }

        | expressao '/' expressao   {
                                        char buf[40];
                                        sprintf(buf,"\tdivi(%s, %s, &temp[%d]);\n", $1, $3, tp_count++);
                                        enqueue(queue_geral, strdup(buf) );

                                        sprintf(buf, "temp[%d]", tp_count-1);
                                        $$ = strdup(buf);
                                    }

        | '-' expressao %prec UMINUS{
                                        char buf[40];
                                        sprintf(buf,"\tuminus(%s, NULL, &temp[%d]);\n", $2, tp_count++);
                                        enqueue(queue_geral, strdup(buf) );

                                        sprintf(buf, "temp[%d]", tp_count-1);
                                        $$ = strdup(buf);
                                    }

        | '(' expressao ')'         { $$ = $2; }
        ;

sentenca:
        IMPRIMA TEXTO ';' {
                            char command[50];
                            sprintf(command, "\tparam(%s, NULL, NULL);\n", $2); 
                            enqueue(queue_geral,strdup(command));
                            sprintf(command, "\tcall(\"imprima\", 1, NULL);\n");
                            enqueue(queue_geral,strdup(command));
                          }
        | IMPRIMA IDENTIFICADOR ';' {

                                        char command[50];
                                        sprintf(command, "\tparam(ts[%d], NULL, NULL);\n", $2); 
                                        enqueue(queue_geral,strdup(command));
                                        sprintf(command, "\tcall(\"imprima\", 1, NULL);\n");
                                        enqueue(queue_geral,strdup(command));
                                    }
        ;

label_para_inicio: {
                        char command[50];
                        sprintf(command, " l%d:\n", (*l)++);
                        enqueue(queue_geral, strdup(command));
                   }
                   ;

posicionar_segunda_atribuicao:
                    {
                        char command[50];
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
                            char command[50];
                            push(stack_para_label, (void *) copy_int(l));
                            sprintf(command,"\tjump_f(temp[%d], NULL, l%d);\n", tp_count-1, (*l)++);
                            enqueue(queue_geral,strdup(command));
                            enqueue(queue_geral, "inicio_atribuicao_para"); 
                        }
                        ;

para:
    PARA '(' atribuicao ';' label_para_inicio expressao_logica ';' marcar_inicio_atribuicao atribuicao retirar_segunda_atribuicao ')' instrucao posicionar_segunda_atribuicao
    ;

label_enquanto_inicio: {
                            char command[50];
                            sprintf(command, " l%d:\n", (*l)++);
                            enqueue(queue_geral,strdup(command));
                       }
                       ;
label_enquanto_fim: {
                        int *label = (int *) pop(stack_enquanto);
                        char command[50];
                        sprintf(command, "\tjump(NULL, NULL, l%d);\n", *label-1);
                        enqueue(queue_geral,strdup(command));
                        sprintf(command, "l%d:\n", *label); 
                        enqueue(queue_geral,strdup(command));
                        free(label);
                    }
                    ;
inicio_enquanto: {
                    char command[50];
                    push(stack_enquanto,(void *) copy_int(l));
                    sprintf(command,"\tjump_f(temp[%d], NULL, l%d);\n", tp_count-1, (*l)++);
                    enqueue(queue_geral,strdup(command));
                 }
                 ;
enquanto:
        ENQUANTO label_enquanto_inicio '(' expressao_logica ')' inicio_enquanto instrucao label_enquanto_fim
        ;

inicio_selecao: {
                char command[50];
                push(stack_if, (void *) copy_int(l));
                sprintf(command,"\tjump_f(temp[%d], NULL, l%d);\n", tp_count-1, (*l)++);
                enqueue(queue_geral,strdup(command));
                count_if_else++;
           }
           ;

label_selecao: {
                    char command[50];
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
                                       char command[50];
                                        sprintf(command, "temp[%d]", tp_count-1);
                                        $$ = strdup(command);
                                     }

                | expressao_relacional AND expressao_logica {
                                                                    char command[50];
                                                                    sprintf(command, "\trela_an(%s, %s, &temp[%d]);\n", $1, $3, tp_count++);
                                                                    enqueue(queue_geral,strdup(command));
                                                                    sprintf(command, "temp[%d]", tp_count-1);
                                                                    $$ = strdup(command);
                                                                }
                | expressao_logica AND expressao_relacional { 
                                                                    char command[50];
                                                                    sprintf(command, "\trela_an(%s, %s, &temp[%d]);\n", $1, $3, tp_count++);
                                                                    enqueue(queue_geral,strdup(command));
                                                                    sprintf(command, "temp[%d]", tp_count-1);
                                                                    $$ = strdup(command);
                                                            }
                | expressao_logica OR expressao_relacional {
                                                                    char command[50];
                                                                    sprintf(command, "\trela_or(%s, %s, &temp[%d]);\n", $1, $3, tp_count++);
                                                                    enqueue(queue_geral,strdup(command));
                                                                    sprintf(command, "temp[%d]", tp_count-1);
                                                                    $$ = strdup(command);
                                                           }
                | expressao_relacional OR expressao_logica {
                                                                    char command[50];
                                                                    sprintf(command, "\trela_or(%s, %s, &temp[%d]);\n", $1, $3, tp_count++);
                                                                    enqueue(queue_geral,strdup(command));
                                                                    sprintf(command, "temp[%d]", tp_count-1);
                                                                    $$ = strdup(command);
                                                            }
                | NOT expressao_logica {
                                                
                                            char command[50];
                                            sprintf(command, "\trela_no(%s, NULL, &temp[%d]);\n", $2, tp_count++);
                                            enqueue(queue_geral,strdup(command));
                                       }

                | '(' expressao_logica ')' { $$ = $2; }
                ;

aborte:
      ABORTE ';' {
                    enqueue(queue_geral, "\texit(1);\n");
                 }
      ;

saia:
    SAIA '(' TEXTO ')' ';' {
                                char command[50];
                                sprintf(command, "\texit(%d);\n", atoi($3));
                                enqueue(queue_geral, strdup(command));
                           }
    ;

instrucao:
	selecao { 
                    desempilhar();
                    count_if_else--;
                    if (!count_if_else) { // label de jump incondicional
                        fprintf(file, " l%d:\n", (*l)++);
                        fflush(file);
                    }
                }
        | enquanto { desempilhar(); }
        | para { desempilhar(); }
        | aborte { desempilhar(); }
        | saia { desempilhar(); }
        | expressao_logica
        | sentenca { if (count_if_else == 0) desempilhar(); }
	| atribuicao ';' { if (count_if_else == 0) desempilhar(); } 
        | expressao ';' { if (count_if_else == 0) desempilhar(); } 
	| bloco_instrucao
        | ';' { if (count_if_else == 0) {
                    fprintf(file, "\tnop(NULL, NULL, NULL);\n");
                    fflush(file);
                } else {
                    enqueue(queue_geral,"\tnop(NULL, NULL, NULL);\n");
                }
        }
	;
conjunto_instrucao:
	instrucao
	| conjunto_instrucao instrucao
	;
bloco_instrucao:
	INICIO ';' imprimir_label FIM ';' {
                           }
	| INICIO ';' imprimir_label conjunto_instrucao FIM ';' {
                                                }
	;
imprimir_label: {
                    if (count_if_else == 0 && *l > 1) // Soh imprime se nao estiver em um if
                        fprintf(file, " l%d:\n", (*l)++);
                }
%%

int *copy_int(int *value) {
    int *copy = (int *) malloc(sizeof(int));
    *copy = *value;
    return copy;
}

void desempilhar(void) {
    char *value; 
    while(!is_queue_empty(queue_geral)){
        value = dequeue(queue_geral);
        if (!strcmp(value, "jump_incondicional")) {
            fprintf(file, "\tjump(NULL, NULL, l%d);\n", *l);
        }
        else {
            fprintf(file,"%s",value);
        }
    }
    fflush(file);

}

void yyerror(char *s) {
    fprintf(stderr, "%s\n", s);
}

int main(int argc, char **argv) {
    file = fopen("Portugol.c","w");
    
    l = malloc(sizeof(int));
    *l = 1;

    stack_if = init_stack();
    stack_enquanto = init_stack();
    stack_para_label = init_stack();
    stack_para_atribuicao = init_stack();
    queue_geral = init_queue();

    fprintf(file,
                "//\tGerado pelo compilador PORTUGOL versao 1q\n"
                "//\tAutores: Ed Prado, Edinaldo Carvalho, Elton Oliveira,\n"
                "//\t\t Marlon Chalegre, Rodrigo Castro\n"
                "//\tEmail: {msgprado, truetypecode, elton.oliver,\n"
                "//\t\tmarlonchalegre, rodrigomsc}@gmail.com\n"
                "//\tData: 26/05/2009\n"
                "\n#include <stdlib.h>\n"
                "#include \"quadruplas-v1q.h\"\n\n"
                "int main(void)\n{\n"
                );

    if(!file){
        printf("O arquivo nao pode ser aberto!!\n");
        exit(1);
    }

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

    fprintf(file,"}\n");

    fclose(file);
}
