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
    //int pop_rel();
    //void push_rel();
    int tp_count = 0;
    int l = 0;
    int count_if_else = 0;
    int stack[100];
    int stack_pt = -1;
    //int stack_rel[100];
    //int stack_rel_pt = -1;
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
//%expect 1
%%

programa:
	instrucao 
        | programa instrucao 
        ;

afirmacao:
        IDENTIFICADOR '=' expressao ';' {
                                            char command[50];
                                            sprintf(command,"mov(%s, NULL, &ts[%d]);\n", $3, $1);
                                            enqueue( strdup(command) );
				        }
        ;

expressao_relacional:
        expressao '>' expressao {
                                        char command[50];
                                        sprintf(command,"comp_gt(%s, %s, &temp[%d]);\n", $1, $3, tp_count++);
                                        enqueue( strdup(command) );
                                        //push(tp_count-1);
                                        
                                        sprintf(command, "temp[%d]", tp_count-1);
                                        $$ = strdup(command);
                                  }	
	| expressao '<' expressao {
                                        char command[50];
                                        sprintf(command, "comp_lt(%s, %s, &temp[%d]);\n", $1, $3, tp_count++);
                                        enqueue( strdup(command) );
                                        //push(tp_count-1);
                                        
                                        sprintf(command, "temp[%d]", tp_count-1);
                                        $$ = strdup(command);
                                  }
	| expressao MENORIGUAL expressao {
                                        char command[50];
                                        sprintf(command, "comp_le(%s, %s, &temp[%d]);\n", $1, $3, tp_count++);
                                        enqueue( strdup(command));
                                        //push(tp_count-1);
                                        
                                        sprintf(command, "temp[%d]", tp_count-1);
                                        $$ = strdup(command);
                                         }
	| expressao MAIORIGUAL expressao {
                                        char command[50];
                                        sprintf(command, "comp_ge(%s, %s, &temp[%d]);\n", $1, $3, tp_count++);
                                        enqueue( strdup(command));
                                        //push(tp_count-1);
                                        
                                        sprintf(command, "temp[%d]", tp_count-1);
                                        $$ = strdup(command);
                                         }
	| expressao IGUAL expressao {
                                        char command[50];
                                        sprintf(command, "comp_eq(%s, %s, &temp[%d]);\n", $1, $3, tp_count++);
                                        enqueue( strdup(command));
                                        //push(tp_count-1);
                                        
                                        sprintf(command, "temp[%d]", tp_count-1);
                                        $$ = strdup(command);
                                    } 
        | expressao DIFERENTE expressao {
                                            char command[50];
                                            sprintf(command, "comp_ne(%s, %s, &temp[%d]);\n", $1, $3, tp_count++);
                                            enqueue( strdup(command));
                                            //push(tp_count-1);
                                        
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
        | expressao '+' expressao     {
                                        char buf[40];
                                        sprintf(buf,"add(%s, %s, &temp[%d]);\n", $1, $3, tp_count++);
                                        enqueue( strdup(buf) );

                                        sprintf(buf, "temp[%d]", tp_count-1);
                                        $$ = strdup(buf);
                                      }
        | expressao '-' expressao     {
                                        char buf[40];
                                        sprintf(buf,"sub(%s, %s, &temp[%d]);\n", $1, $3, tp_count++);
                                        enqueue( strdup(buf) );

                                        sprintf(buf, "temp[%d]", tp_count-1);
                                        $$ = strdup(buf);
                                      }
        | expressao '*' expressao     { 
                                        char buf[40];
                                        sprintf(buf,"mult(%s, %s, &temp[%d]);\n", $1, $3, tp_count++);
                                        enqueue( strdup(buf) );

                                        sprintf(buf, "temp[%d]", tp_count-1);
                                        $$ = strdup(buf);
                                      }
        | expressao '/' expressao     {
                                        char buf[40];
                                        sprintf(buf,"divi(%s, %s, &temp[%d]);\n", $1, $3, tp_count++);
                                        enqueue( strdup(buf) );

                                        sprintf(buf, "temp[%d]", tp_count-1);
                                        $$ = strdup(buf);
                                      }
        | '-' expressao %prec UMINUS  {
                                        char buf[40];
                                        sprintf(buf,"uminus(%s, NULL, &temp[%d]);\n", $2, tp_count++);
                                        enqueue( strdup(buf) );

                                        sprintf(buf, "temp[%d]", tp_count-1);
                                        $$ = strdup(buf);
                                      }
        | '(' expressao ')'            { $$ = $2; }
        ;

sentenca:
        IMPRIMA TEXTO ';' {
                            char command[50];
                            sprintf(command, "param(%s, NULL, NULL);\n", $2); 
                            enqueue(strdup(command));
                            sprintf(command, "call(\"imprima\", 1, NULL);\n");
                            enqueue(strdup(command));
                      }
        | IMPRIMA IDENTIFICADOR ';' {
                                    printf("entrou\n");
                                    char command[50];
                                    sprintf(command, "param(ts[%d], NULL, NULL);\n", $2); 
                                    enqueue(strdup(command));
                                    enqueue(strdup(command));
                                    printf("empty: %d\n", is_empty());
                                    sprintf(command, "call(\"imprima\", 1, NULL);\n");
                                    enqueue(strdup(command));
                                    printf("empty: %d\n", is_empty());
                                }
        ;

inicio_if: {
            char command[50];
            sprintf(command,"jump_f(temp[%d], NULL, l%d);\n", tp_count-1, l++);
            enqueue(strdup(command));
            push(l-1);
            count_if_else++;
           }
           ;

label: {
            char command[50];
            sprintf(command, "l%d:\n", pop());
            enqueue(strdup(command));
        }

bloco: {
            enqueue("jump_incondicional");
       }

selecao: 
	IF '(' expressao_logica ')' inicio_if THEN instrucao label
        | IF '(' expressao_logica ')' inicio_if THEN instrucao label ELSE bloco instrucao
	;

expressao_logica:
                expressao_relacional {
                    char command[50];
                    sprintf(command, "temp[%d]", tp_count-1);
                    $$ = strdup(command);
                }
                | expressao_relacional AND expressao_logica { 
                                                                    char command[50];
                                                                    sprintf(command, "rela_an(%s, %s, temp[%d]);\n", $1, $3, tp_count++);
                                                                    enqueue(strdup(command));
                                                                    sprintf(command, "temp[%d]", tp_count-1);
                                                                    $$ = strdup(command);
                                                            }
                | expressao_relacional OR expressao_logica {
                                                                    char command[50];
                                                                    sprintf(command, "rela_or(%s, %s, temp[%d]);\n", $1, $3, tp_count++);
                                                                    enqueue(strdup(command));
                                                                    sprintf(command, "temp[%d]", tp_count-1);
                                                                    $$ = strdup(command);
                                                           }
                | NOT expressao_logica {
                                                
                                                char command[50];
                                                sprintf(command, "rela_no(%s, NULL, temp[%d]);\n", $2, tp_count++);
                                                enqueue(strdup(command));
                                       }
                | '(' expressao_logica ')' { $$ = $2; }
                ;


instrucao:
	selecao { 
                desempilhar();
                count_if_else--;
                if (!count_if_else) { // label de jump incondicional
                    fprintf(file, "l%d:\n", l++);
                    fflush(file);
                }
        }
        | expressao_logica
        | sentenca { if (count_if_else == 0) desempilhar(); }
	| afirmacao { if (count_if_else == 0) desempilhar(); } 
        | expressao ';' { if (count_if_else == 0) desempilhar(); } 
        //| expressao_relacional ';' { if (count_if_else == 0) desempilhar(); } // Nao faz sentido!
	| bloco_instrucao
        | ';' { if (count_if_else == 0) {
                    fprintf(file, "nop(NULL, NULL, NULL);\n");
                    fflush(file);
                } else {
                    enqueue("nop(NULL, NULL, NULL);\n");
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
                    if (count_if_else == 0 && l > 0) // Soh imprime se nao estiver em um if
                        fprintf(file, "l%d:\n", l++);
                }
%%

void push(int value) {
    stack[++stack_pt] = value;
}

int pop() {
    return stack[stack_pt--];
}
//void push_rel(int value) {
//    stack_rel[++stack_rel_pt] = value;
//}

//int pop_rel() {
//    return stack_rel[stack_rel_pt--];
//}
void desempilhar(void) {
    char *value; 
    while(!is_empty()){
        value = dequeue();
        if (!strcmp(value, "jump_incondicional")) {
            fprintf(file, "jump(l%d, NULL, NULL);\n", l);
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
 
/*void escreverLabel(){
    if(flag){
        fprintf(file, "l%d:\n", l-1);
        flag = 0;
    }
}
*/
int main(int argc, char **argv) {
//as primeiras palavras que forem adicionadas serao as palavras chaves, isso antes do lex entrar em acao
//enquanto o lex estiver rodando o usuario n podera entrar mais com essas palavras, e as que ele entrar sera variavel
    //lookup("inicio",1);
    //lookup("fim",1);
    file = fopen("Portugol.out","w");

    init_queue();
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
    fclose(file);
}
