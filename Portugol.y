%{
    #include <stdio.h>
    #include <math.h>
    #include <string.h>
    #include <stdlib.h>
    #include "Tabela.h"

    FILE* file;
    void yyerror(char *);
    int yylex(void);
    int tp_count = 0;
%}

%union{
    double valor;
    char *texto;
    int sp;
}

%token <sp> IDENTIFICADOR
%token INICIO FIM
%token <valor> VALOR
%token <texto> TEXTO
//%token <texto> TEXTO
%token SQRT
%token IF THEN ELSE
%token IMPRIMA
%token MAIORIGUAL IGUAL MENORIGUAL
%left '<' '>' MENORIGUAL MAIORIGUAL IGUAL
%left '+' '-'
%left '*' '/'
%left VALOR
//%left ELSE
//%nonassoc ELSE
%type <texto> expressao
%type <valor> sentenca
%expect 1
%%

programa:
	//afirmacao '\n'	
	instrucao '\n'
	//|selecao'\n'
        |programa instrucao '\n'
        ;

afirmacao:
        IDENTIFICADOR '=' expressao ';' {
                                fprintf(file, "mov(%s, NULL, &ts[%d])\n", $3, $1);
                                fflush(file);
				//	if($1->key != 1){
				//		$1 -> valor = $3;
				//	}else{
				//		printf("Palavra-Chave, impossivel atribuir");
				//	}
				  }
	//|  COMENTARIO {;}
	//|  expressao COMENTARIO { printf("= %g\n", $1); }
	//|  declaracao
        ;

expressao:
        //VALOR
        TEXTO
/*        | IDENTIFICADOR               { 
                                        if ($1->valor)
                                            $$ = $1->valor;
                                        else
                                            printf("erro: variavel inexistente");
                                    }*/
	//| expressao '>' expressao {$$ = $1 > $3;}	
	//| expressao '<' expressao {$$ = $1 < $3;}
	//| expressao MENORIGUAL expressao {$$ = $1 <= $3;}
	//| expressao MAIORIGUAL expressao {$$ = $1 >= $3;}
	//| expressao IGUAL expressao {$$ = $1 == $3;}
        | expressao '+' expressao     {
                                        //fprintf(file, "mov(%.2f, NULL, &temp[%d])\n", $1, tp_count++);
                                        //fprintf(file, "mov(%.2f, NULL, &temp[%d])\n", $3, tp_count++);
                                        fprintf(file, "add(%s, %s, &temp[%d])\n", $1, $3, tp_count++);
                                        fflush(file);
                                        //$$ = $1 + $3;
                                      }
        //| expressao '-' expressao     { $$ = $1 - $3; }
        //| expressao '*' expressao     { $$ = $1 * $3; }
        //| expressao '/' expressao     { 
          //                                  if($3 == 0 ){
           //                                     yyerror("Divisão por zero!");
          //                                  } else{ 
          //                                      $$ = $1 / $3;
          //                                  }
          //                            }
        //| SQRT '(' expressao ')' { $$ = sqrt($3); }
        //| '(' expressao ')'            { $$ = $2; }
        ;

sentenca:
        IMPRIMA VALOR { printf("%g\n", $2); }
/*        | IMPRIMA IDENTIFICADOR    { 
                                        if ($2->valor)
                                            printf("%g\n", $2->valor);
                                        else
                                            printf("erro: variavel inexistente\n");
                                    }*/
        ;

selecao: 
	IF '(' expressao ')' THEN instrucao %prec ELSE { fprintf(file,"IF-THEN"); fflush(file); }
	| IF '(' expressao ')' THEN instrucao ELSE instrucao {printf("IF (xxxx) yyyy else zzz");}
	;

instrucao:
	selecao
        |sentenca
	|afirmacao
        |expressao
	//|declaracao
	|bloco_instrucao
	;
conjunto_instrucao:
	instrucao
	| conjunto_instrucao instrucao
	;
bloco_instrucao:
	INICIO ';' FIM ';' {printf("Teste inicio FIM");}
	| INICIO ';' conjunto_instrucao FIM ';'
	;


//declaracao:
//	| IDENTIFICADOR ';'
//	;

%%

void yyerror(char *s) {
    fprintf(stderr, "%s\n", s);
}
 
/* Procura na tabela de simbolos, nela iremos colocar nossas palavras reservadas e variaveis que estao sendo criadas */
/* se a palavra nao for encontrada ela e adicionada a tabela de simbolos*/
struct symtab* lookup(char *s, int key){
	
	char *p;
	struct symtab *sp;

	for(sp = symtab; sp < &symtab[NSYMS]; sp++){ 
	
		/* Existe? */
		if (sp->nome && !strcmp(sp->nome, s))
			return sp;

		/* ta livre? */
		if(!sp->nome) { 
			sp->nome = strdup(s); //coloca na tabela de simbolos
			sp->key = key;			
			return sp; 
		}
  	}
        
	//a tabela de simbolos tem uma quantidade max, cuidado para n estourar
	yyerror("Too many symbols");
	return 0;
}

void print(char *text) {
    fprintf(file, "%s", text);
    fflush(file);
}

int main(void) {
//as primeiras palavras que forem adicionadas serao as palavras chaves, isso antes do lex entrar em acao
//enquanto o lex estiver rodando o usuario n podera entrar mais com essas palavras, e as que ele entrar sera variavel
    //lookup("inicio",1);
    //lookup("fim",1);
    file = fopen("Portugol.out","a+");

    if(!file){
        printf("O arquivo nao pode ser aberto!!");
        exit(1);
    }
    yyparse();
    fclose(file);
}
