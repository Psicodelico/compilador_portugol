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
    int tp_count = 0;
    int l = 0;
    int count_if = 1;
    int count_else = 1;
%}

%union{
    char *texto;
    int sp;
}

%token <sp> IDENTIFICADOR
%token INICIO FIM
%token <texto> TEXTO
%token SQRT
%token IF //ELSE
%token IMPRIMA
%token MAIORIGUAL IGUAL MENORIGUAL
%left '<' '>' MENORIGUAL MAIORIGUAL IGUAL
%left '+' '-'
%left '*' '/'
%nonassoc UMINUS
%nonassoc THEN
%nonassoc ELSE
%type <texto> expressao
%type <texto> expressao_relacional
%expect 1
%%

programa:
	instrucao 
        | programa instrucao 
        ;

afirmacao:
        IDENTIFICADOR '=' expressao ';' {
                                            //fprintf(file, "mov(%s, NULL, &ts[%d]);\n", $3, $1);
                                            //fflush(file);
                                            char command[50];
                                            sprintf(command,"mov(%s, NULL, &ts[%d]);\n", $3, $1);
                                            enqueue( strdup(command) );
				        }
	//|  COMENTARIO {;}
	//|  expressao COMENTARIO { printf("= %g\n", $1); }
	//|  declaracao
        ;

expressao_relacional:
        expressao '>' expressao {
                                        char command[50];
                                        sprintf(command,"comp_gt(%s, %s, &temp[%d]);\n", $1, $3, tp_count++);
                                        enqueue( strdup(command) );
                                        
                                        sprintf(command, "temp[%d]", tp_count-1);
                                        $$ = strdup(command);
                                  }	
	| expressao '<' expressao {
                                        char command[50];
                                        sprintf(command, "comp_lt(%s, %s, &temp[%d]);\n", $1, $3, tp_count++);
                                        enqueue( strdup(command) );
                                        
                                        sprintf(command, "temp[%d]", tp_count-1);
                                        $$ = strdup(command);
                                  }
	| expressao MENORIGUAL expressao {
                                        char command[50];
                                        sprintf(command, "comp_le(%s, %s, &temp[%d]);\n", $1, $3, tp_count++);
                                        enqueue( strdup(command));
                                        
                                        sprintf(command, "temp[%d]", tp_count-1);
                                        $$ = strdup(command);
                                         }
	| expressao MAIORIGUAL expressao {
                                        char command[50];
                                        sprintf(command, "comp_ge(%s, %s, &temp[%d]);\n", $1, $3, tp_count++);
                                        enqueue( strdup(command));
                                        
                                        sprintf(command, "temp[%d]", tp_count-1);
                                        $$ = strdup(command);
                                         }
	| expressao IGUAL expressao {
                                        char command[50];
                                        sprintf(command, "comp_eq(%s, %s, &temp[%d]);\n", $1, $3, tp_count++);
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
                                    char command[50];
                                    sprintf(command, "param(ts[%d], NULL, NULL);\n", $2); 
                                    enqueue(strdup(command));
                                    sprintf(command, "call(\"imprima\", 1, NULL);\n");
                                    enqueue(strdup(command));
                                }
        ;

inicio_if: {
            desempilhar();
            fprintf(file,"jump_f(temp[%d], NULL, l%d);\n", tp_count-1, l++);
            count_else = 1;
            count_if++;
            fflush(file);
           }
           ;
if_then: {
            desempilhar();
            fflush(file);        
      }
      ;

if_else: {
            fprintf(file, "jump(l%d, NULL, NULL);\n", l);
            fprintf(file, "l%d:\n", l-count_else);
            count_else++;
            desempilhar();
            if(count_else == count_if) {
                fprintf(file, "l%d:\n", l);
                count_if = 1;
            }
            fflush(file); 
         }
         ;

selecao: 
	IF '(' expressao_relacional ')' inicio_if THEN instrucao if_then if_else
        | IF '(' expressao_relacional ')' inicio_if THEN instrucao if_then ELSE instrucao if_else
	;

instrucao:
	selecao
        |sentenca { if (count_if == 1) desempilhar(); }
	|afirmacao { if (count_if == 1) desempilhar(); } 
        |expressao ';' { if (count_if == 1) desempilhar(); } 
        |expressao_relacional ';' { if (count_if == 1) desempilhar(); } 
	|bloco_instrucao
	;
conjunto_instrucao:
	instrucao
	| conjunto_instrucao instrucao
	;
bloco_instrucao:
	INICIO ';' imprimir_label FIM ';' {
                                //fprintf(file, "l%d:\n", l++);
                                //fflush(file);
                           }
	| INICIO ';' imprimir_label conjunto_instrucao FIM ';' {
                                                    //fprintf(file, "l%d:\n", l++);
                                                    //fflush(file);
                                                }
	;
imprimir_label: {
                    if (count_if == 1) // Soh imprime se nao estiver em um if
                        fprintf(file, "l%d:\n", l++);
                }
%%

void desempilhar(void) {
    
    while(!is_empty()){
        char* value = dequeue();
        fprintf(file,"%s",value);
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
