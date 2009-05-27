%{
    #include <stdio.h>
    #include <math.h>
    #include <string.h>
    #include <stdlib.h>
    #include "Tabela.h"
    #include "Queue.h"

    FILE *file;
    void yyerror(char *);
    int yylex(void);
    void desempilhar(void);
    int pop();
    void push();
    int tp_count = 0;
    int l = 1;
    int count_if_else = 0;
    int stack[100];
    int stack_pt = -1;
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
%token IMPRIMA
%token MAIORIGUAL IGUAL MENORIGUAL DIFERENTE
%token AND OR NOT
%left '<' '>' MENORIGUAL MAIORIGUAL IGUAL DIFERENTE
%left '+' '-'
%left '*' '/'
%nonassoc UMINUS
%nonassoc THEN
%nonassoc ELSE
%type <texto> expressao
%type <texto> expressao_relacional
%type <texto> expressao_logica
%expect 1
%%

programa:
	instrucao 
        | programa instrucao 
        ;

afirmacao:
        IDENTIFICADOR '=' expressao ';' {
                                            char command[50];
                                            sprintf(command,"\tmov(%s, NULL, &ts[%d]);\n", $3, $1);
                                            enqueue( strdup(command) );
				        }
        ;

expressao_relacional:
        expressao '>' expressao {
                                        char command[50];
                                        sprintf(command,"\tcomp_gt(%s, %s, &temp[%d]);\n", $1, $3, tp_count++);
                                        enqueue( strdup(command) );
                                        
                                        sprintf(command, "temp[%d]", tp_count-1);
                                        $$ = strdup(command);
                                }

	| expressao '<' expressao {
                                        char command[50];
                                        sprintf(command, "\tcomp_lt(%s, %s, &temp[%d]);\n", $1, $3, tp_count++);
                                        enqueue( strdup(command) );
                                        
                                        sprintf(command, "temp[%d]", tp_count-1);
                                        $$ = strdup(command);
                                  }

	| expressao MENORIGUAL expressao {
                                            char command[50];
                                            sprintf(command, "\tcomp_le(%s, %s, &temp[%d]);\n", $1, $3, tp_count++);
                                            enqueue( strdup(command));
                                        
                                            sprintf(command, "temp[%d]", tp_count-1);
                                            $$ = strdup(command);
                                         }

	| expressao MAIORIGUAL expressao {
                                            char command[50];
                                            sprintf(command, "\tcomp_ge(%s, %s, &temp[%d]);\n", $1, $3, tp_count++);
                                            enqueue( strdup(command));
                                        
                                            sprintf(command, "temp[%d]", tp_count-1);
                                            $$ = strdup(command);
                                         }

	| expressao IGUAL expressao {
                                        char command[50];
                                        sprintf(command, "\tcomp_eq(%s, %s, &temp[%d]);\n", $1, $3, tp_count++);
                                        enqueue( strdup(command));
                                        
                                        sprintf(command, "temp[%d]", tp_count-1);
                                        $$ = strdup(command);
                                    }

        | expressao DIFERENTE expressao {
                                            char command[50];
                                            sprintf(command, "\tcomp_ne(%s, %s, &temp[%d]);\n", $1, $3, tp_count++);
                                            enqueue( strdup(command));
                                        
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
                                        enqueue( strdup(buf) );

                                        sprintf(buf, "temp[%d]", tp_count-1);
                                        $$ = strdup(buf);
                                    }

        | expressao '-' expressao   {
                                        char buf[40];
                                        sprintf(buf,"\tsub(%s, %s, &temp[%d]);\n", $1, $3, tp_count++);
                                        enqueue( strdup(buf) );

                                        sprintf(buf, "temp[%d]", tp_count-1);
                                        $$ = strdup(buf);
                                    }

        | expressao '*' expressao   { 
                                        char buf[40];
                                        sprintf(buf,"\tmult(%s, %s, &temp[%d]);\n", $1, $3, tp_count++);
                                        enqueue( strdup(buf) );

                                        sprintf(buf, "temp[%d]", tp_count-1);
                                        $$ = strdup(buf);
                                    }

        | expressao '/' expressao   {
                                        char buf[40];
                                        sprintf(buf,"\tdivi(%s, %s, &temp[%d]);\n", $1, $3, tp_count++);
                                        enqueue( strdup(buf) );

                                        sprintf(buf, "temp[%d]", tp_count-1);
                                        $$ = strdup(buf);
                                    }

        | '-' expressao %prec UMINUS{
                                        char buf[40];
                                        sprintf(buf,"\tuminus(%s, NULL, &temp[%d]);\n", $2, tp_count++);
                                        enqueue( strdup(buf) );

                                        sprintf(buf, "temp[%d]", tp_count-1);
                                        $$ = strdup(buf);
                                    }

        | '(' expressao ')'         { $$ = $2; }
        ;

sentenca:
        IMPRIMA TEXTO ';' {
                            char command[50];
                            sprintf(command, "\tparam(%s, NULL, NULL);\n", $2); 
                            enqueue(strdup(command));
                            sprintf(command, "\tcall(\"imprima\", 1, NULL);\n");
                            enqueue(strdup(command));
                          }
        | IMPRIMA IDENTIFICADOR ';' {

                                        char command[50];
                                        sprintf(command, "\tparam(ts[%d], NULL, NULL);\n", $2); 
                                        enqueue(strdup(command));
                                        enqueue(strdup(command));
                                        sprintf(command, "\tcall(\"imprima\", 1, NULL);\n");
                                        enqueue(strdup(command));
                                    }
        ;

inicio_if: {
                char command[50];
                sprintf(command,"\tjump_f(temp[%d], NULL, l%d);\n", tp_count-1, l++);
                enqueue(strdup(command));
                push(l-1);
                count_if_else++;
           }
           ;

label: {
            char command[50];
            sprintf(command, " l%d:\n", pop());
            enqueue(strdup(command));
        }

bloco: {
            enqueue("jump_incondicional");
       }

selecao: 
	IF '(' expressao_logica ')' inicio_if THEN instrucao label
        | IF '(' expressao_logica ')' inicio_if THEN instrucao ELSE bloco label instrucao
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
                                                                    enqueue(strdup(command));
                                                                    sprintf(command, "temp[%d]", tp_count-1);
                                                                    $$ = strdup(command);
                                                            }
                | expressao_relacional OR expressao_logica  {
                                                                    char command[50];
                                                                    sprintf(command, "\trela_or(%s, %s, &temp[%d]);\n", $1, $3, tp_count++);
                                                                    enqueue(strdup(command));
                                                                    sprintf(command, "temp[%d]", tp_count-1);
                                                                    $$ = strdup(command);
                                                            }
                | NOT expressao_logica {
                                                
                                            char command[50];
                                            sprintf(command, "\trela_no(%s, NULL, &temp[%d]);\n", $2, tp_count++);
                                            enqueue(strdup(command));
                                       }

                | '(' expressao_logica ')' { $$ = $2; }
                ;


instrucao:
	selecao { 
                    desempilhar();
                    count_if_else--;
                    if (!count_if_else) { // label de jump incondicional
                        fprintf(file, " l%d:\n", l++);
                        fflush(file);
                    }
                }

        | expressao_logica
        | sentenca { if (count_if_else == 0) desempilhar(); }
	| afirmacao { if (count_if_else == 0) desempilhar(); } 
        | expressao ';' { if (count_if_else == 0) desempilhar(); } 
	| bloco_instrucao
        | ';' { if (count_if_else == 0) {
                    fprintf(file, "\tnop(NULL, NULL, NULL);\n");
                    fflush(file);
                } else {
                    enqueue("\tnop(NULL, NULL, NULL);\n");
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
                    if (count_if_else == 0 && l > 1) // Soh imprime se nao estiver em um if
                        fprintf(file, " l%d:\n", l++);
                }
%%

void push(int value) {
    stack[++stack_pt] = value;
}

int pop() {
    return stack[stack_pt--];
}

void desempilhar(void) {
    char *value; 
    while(!is_empty()){
        value = dequeue();
        if (!strcmp(value, "jump_incondicional")) {
            fprintf(file, "\tjump(NULL, NULL, l%d);\n", l);
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

    init_queue();

    fprintf(file,
                "//\tGerado pelo compilador PORTUGOL versao 1q\n"
                "//\tAutores: Ed Prado, Edinaldo Santos, Elton Oliveira,\n"
                "//\t\t Marlon Chalegre, Rodrigo Castro\n"
                "//\tEmail: {msgprado, truetypecode, elton.oliver,\n"
                "//\t\tmarlonchalegre, rodrigomsc}@gmail.com\n"
                "//\tData: 26/05/2009\n"
                "\n#include \"quadruplas-v1q.h\"\n\n"
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
