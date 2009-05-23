%{
    #include <stdio.h>
    #include <math.h>
    #include <string.h>
    #include <stdlib.h>
    #include "Tabela.h"

    FILE *file;
    void yyerror(char *);
    int yylex(void);
    int tp_count = 0;
    int l = 0;
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
%expect 1
%%

programa:
	instrucao '\n'
        | programa instrucao '\n'
        ;

afirmacao:
        IDENTIFICADOR '=' expressao ';' {
                                            fprintf(file, "mov(%s, NULL, &ts[%d]);\n", $3, $1);
                                            fflush(file);
				        }
	//|  COMENTARIO {;}
	//|  expressao COMENTARIO { printf("= %g\n", $1); }
	//|  declaracao
        ;

expressao:
        TEXTO
        | IDENTIFICADOR             { 
                                        char buf[40];
                                        sprintf(buf, "ts[%d]", $1);
                                        $$ = strdup(buf);
                                    }
	| expressao '>' expressao {
                                        fprintf(file, "comp_gt(%s, %s, &temp[%d]);\n", $1, $3, tp_count++);
                                        fflush(file);
                                        char buf[40];
                                        sprintf(buf, "temp[%d]", tp_count-1);
                                        $$ = strdup(buf);
                                  //      $$ = $1 > $3;
                                  }	
	| expressao '<' expressao {
                                        fprintf(file, "comp_lt(%s, %s, &temp[%d]);\n", $1, $3, tp_count++);
                                        fflush(file);
                                        char buf[40];
                                        sprintf(buf, "temp[%d]", tp_count-1);
                                        $$ = strdup(buf);
                                    //$$ = $1 < $3;
                                  }
	| expressao MENORIGUAL expressao {
                                        fprintf(file, "comp_le(%s, %s, &temp[%d]);\n", $1, $3, tp_count++);
                                        fflush(file);
                                        char buf[40];
                                        sprintf(buf, "temp[%d]", tp_count-1);
                                        $$ = strdup(buf);
                                    //$$ = $1 <= $3;
                                         }
	| expressao MAIORIGUAL expressao {
                                        fprintf(file, "comp_ge(%s, %s, &temp[%d]);\n", $1, $3, tp_count++);
                                        fflush(file);
                                        char buf[40];
                                        sprintf(buf, "temp[%d]", tp_count-1);
                                        $$ = strdup(buf);
                                    //$$ = $1 >= $3;
                                         }
	| expressao IGUAL expressao {
                                        fprintf(file, "comp_eq(%s, %s, &temp[%d]);\n", $1, $3, tp_count++);
                                        fflush(file);
                                        char buf[40];
                                        sprintf(buf, "temp[%d]", tp_count-1);
                                        $$ = strdup(buf);
                                    //$$ = $1 == $3;
                                    }
        | expressao '+' expressao     {
                                        fprintf(file, "add(%s, %s, &temp[%d]);\n", $1, $3, tp_count++);
                                        fflush(file);
                                        char buf[40];
                                        sprintf(buf, "temp[%d]", tp_count-1);
                                        $$ = strdup(buf);
                                      }
        | expressao '-' expressao     {
                                        fprintf(file, "sub(%s, %s, &temp[%d]);\n", $1, $3, tp_count++);
                                        fflush(file);
                                        char buf[40];
                                        sprintf(buf, "temp[%d]", tp_count-1);
                                        $$ = buf;
                                      }
        | expressao '*' expressao     { 
                                        fprintf(file, "mult(%s, %s, &temp[%d]);\n", $1, $3, tp_count++);
                                        fflush(file);
                                        char buf[40];
                                        sprintf(buf, "temp[%d]", tp_count-1);
                                        $$ = strdup(buf);
                                      }
        | expressao '/' expressao     {
                                        fprintf(file, "divi(%s, %s, &temp[%d]);\n", $1, $3, tp_count++);
                                        fflush(file);
                                        char buf[40];
                                        sprintf(buf, "temp[%d]", tp_count-1);
                                        $$ = buf;
                                      }
        | '-' expressao %prec UMINUS  {
                                        fprintf(file, "uminus(%s, NULL, &temp[%d]);\n", $2, tp_count++);
                                        fflush(file);
                                        char buf[40];
                                        sprintf(buf, "temp[%d]", tp_count-1);
                                        $$ = buf;
                                      }
        | '(' expressao ')'            { $$ = $2; }
        ;

sentenca:
        IMPRIMA TEXTO {
                            fprintf(file, "param(%s, NULL, NULL);\n", $2); 
                            fprintf(file, "call(\"imprima\", 1, NULL);\n");
                            fflush(file);
                      }
        | IMPRIMA IDENTIFICADOR { 
                                    fprintf(file, "param(ts[%d], NULL, NULL);\n", $2); 
                                    fprintf(file, "call(\"imprima\", 1, NULL);\n");
                                    fflush(file);
                                }
        ;

selecao: 
	IF '(' expressao ')' THEN instrucao {
                fprintf(file,"jump_f(temp[%d], NULL, l%d);\n", tp_count-1, l++);
                fflush(file);
            }
	| IF '(' expressao ')' THEN instrucao ELSE instrucao {printf("IF (xxxx) yyyy else zzz");}
	;

instrucao:
	selecao
        |sentenca
	|afirmacao
        |expressao
	|bloco_instrucao
	;
conjunto_instrucao:
	instrucao
	| conjunto_instrucao instrucao
	;
bloco_instrucao:
	INICIO ';' FIM ';' {
                                fprintf(file, "l%d:\n", l++);
                                fflush(file);
                           }
	| INICIO ';' conjunto_instrucao FIM ';' {
                                                    fprintf(file, "l%d:\n", l++);
                                                    fflush(file);
                                                }
	;
%%

void yyerror(char *s) {
    fprintf(stderr, "%s\n", s);
}
 
int main(void) {
//as primeiras palavras que forem adicionadas serao as palavras chaves, isso antes do lex entrar em acao
//enquanto o lex estiver rodando o usuario n podera entrar mais com essas palavras, e as que ele entrar sera variavel
    //lookup("inicio",1);
    //lookup("fim",1);
    file = fopen("Portugol.out","w");

    if(!file){
        printf("O arquivo nao pode ser aberto!!");
        exit(1);
    }
    yyparse();
    fclose(file);
}
