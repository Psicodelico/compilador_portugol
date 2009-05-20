%{
    #include <stdio.h>
    #include <math.h>
    #include <string.h>
    #include "Tabela.h"

    void yyerror(char *);
    int yylex(void);
%}

%union{
    double valor;
    struct symtab* sp;
}

%token <sp> IDENTIFICADOR
%token INICIO FIM
%token <valor> VALOR
%token SQRT
%token IF THEN ELSE
%token MAIORIGUAL IGUAL MENORIGUAL
%left '<' '>' MENORIGUAL MAIORIGUAL IGUAL
%left '+' '-'
%left '*' '/'
%left VALOR
%type <valor> expressao
%%

programa:
	//afirmacao '\n'	
	instrucao '\n'
	//|selecao'\n'
        |programa instrucao '\n'
        ;

afirmacao: IDENTIFICADOR '=' expressao {
					if($1->key != 1){
						$1 -> valor = $3;
					}else{
						printf("Palavra-Chave, impossivel atribuir");
					}
				  }
	//|  COMENTARIO {;}
	//|  expressao COMENTARIO { printf("= %g\n", $1); }
	//|  declaracao
        ;

expressao:
        VALOR
	| expressao '>' expressao {$$ = $1 > $3;}	
	| expressao '<' expressao {$$ = $1 < $3;}
	| expressao MENORIGUAL expressao {$$ = $1 <= $3;}
	| expressao MAIORIGUAL expressao {$$ = $1 >= $3;}
	| expressao IGUAL expressao {$$ = $1 == $3;}
        | expressao '+' expressao     { $$ = $1 + $3; }
        | expressao '-' expressao     { $$ = $1 - $3; }
        | expressao '*' expressao     { $$ = $1 * $3; }
        | expressao '/' expressao     { 
                                            if($3 == 0 ){
                                                yyerror("Divisão por zero!");
                                            } else{ 
                                                $$ = $1 / $3;
                                            }
                                      }
        | SQRT '(' expressao ')' { $$ = sqrt($3); }
        | '(' expressao ')'            { $$ = $2; }
        ;

selecao: 
	IF '(' expressao ')' THEN expressao {printf("IF (xxxx) yyyy");}
	| IF '(' expressao ')' THEN expressao ELSE expressao {printf("IF (xxxx) yyyy else zzz");}
	;

instrucao:
	selecao
	|afirmacao
        |expressao { printf("= %g\n", $1); }
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

int main(void) {
//as primeiras palavras que forem adicionadas serao as palavras chaves, isso antes do lex entrar em acao
//enquanto o lex estiver rodando o usuario n podera entrar mais com essas palavras, e as que ele entrar sera variavel
    lookup("inicio",1);
    lookup("fim",1);
    yyparse();
}
