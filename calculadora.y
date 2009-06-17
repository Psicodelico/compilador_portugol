%{
    /*
        Calculadora versao 3 - yacc
        Autores: Ed Prado, Edinaldo Carvalho, Elton Oliveira
                 Marlon Chalegre, Rodrigo Castro
        Emails: {msgprado, truetypecode, elton.oliver,
                 marlonchalegre, rodrigomsc}@gmail.com
    */

    #include <stdio.h>
    #include <stdlib.h>
    #include <math.h>
    #include "Stack.h"
    void yyerror(char *);
    int yylex(void);
    float variaveis[26];
    Stack *s;
%}

%union{
    float valor;
    int index;
}

%token <index> VARIAVEL
%token <valor> VALOR
%token SQRT
%left '+' '-'
%left '*' '/'
	//%nonassoc UMINUS

%type <valor> expressao
%%

programa:
        afirmacao'\n'
        | programa afirmacao '\n'
        | error '\n'			{ ; }
        | programa error '\n'		{ ; }
        ;

afirmacao: VARIAVEL '=' expressao ';' {
					float *val = pop(s);
					variaveis[$1] = *val;
					free(val);
				      }
        |  expressao ';'	{
					float *val = pop(s);
					printf("= %g\n", *val);
					free(val);
					while(!is_stack_empty(s)) {
						val = pop(s);
						//printf("lixo %g", *val); //Debug
						free(val);
					}
				}
	| error ';'  { ; }
        ;

expressao:
        VALOR			{
					float  *v = ((float *)malloc(sizeof(float)));
					*v = $1;
					push(s, v);
				}
        | expressao expressao '+'	{
						float *arg2 = pop(s);
						float *arg1 = pop(s);
						float *val = ((float *)malloc(sizeof(float)));
						*val = *arg1 + *arg2;
						free(arg1);
						free(arg2);
						push(s, val);
						$$ = *val;
					}
        | expressao expressao '-'	{
						float *arg2 = pop(s);
						float *arg1 = pop(s);
						float *val = ((float *)malloc(sizeof(float)));
						*val = *arg1 - *arg2;
						free(arg1);
						free(arg2);
						push(s, val);
						$$ = *val;
					}
        | expressao expressao '*'	{
						float *arg2 = pop(s);
						float *arg1 = pop(s);
						float *val = ((float *)malloc(sizeof(float)));
						*val = (*arg1) * (*arg2);
						free(arg1);
						free(arg2);
						push(s, val);
						$$ = *val;
					}
        | expressao expressao '/'	{
						float *arg2 = pop(s);
						float *arg1 = pop(s);
						float *val = ((float *)malloc(sizeof(float)));
						if(*arg2 == 0)
							yyerror("Divisão por zero!");
						else {
							*val = *arg1 / *arg2;
							push(s, val);
							$$ = *val;
						}
						free(arg1);
						free(arg2);
						printf("chegou\n");
					}
        | expressao SQRT	{
					float *arg1 = pop(s);
					*arg1 = sqrt(*arg1);
					push(s, arg1);
					$$ = sqrt(*arg1);
				}
        | expressao '-'	{
						float *arg1 = pop(s);
						*arg1 = -(*arg1);
						push(s, arg1);
						$$ = sqrt(*arg1);
					}
        | '(' expressao ')'            { $$ = $2; }
        | VARIAVEL	{
				float *val = ((float *)malloc(sizeof(float)));
				*val = variaveis[$1];
				push(s, val);
				$$ = *val;
			}
	;

%%

void yyerror(char *s) {
    fprintf(stderr, "%s\n", s);
}

int main(void) {
    s = init_stack();
    yyparse();
}
