
%{
    #include <stdio.h>
    #include <math.h>
    void yyerror(char *);
    int yylex(void);
    double variaveis[26];
%}

%union{
    double valor;
    int index;
}

%token <index> VARIAVEL
%token <valor> VALOR
%token SQRT
%nonassoc UMINUS
%left '+' '-'
%left '*' '/'

%type <valor> expressao
%%

programa:
        afirmacao'\n'
        | programa afirmacao '\n'
        ;

afirmacao: VARIAVEL '=' expressao ';' { variaveis[$1] = $3; }
        |  expressao ';' { printf("= %g\n", $1); }
        ;

expressao:
        VALOR
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
        | '-' expressao %prec UMINUS { $$ = -($2); }
        | SQRT '(' expressao ')' { $$ = sqrt($3); }
        | '(' expressao ')'            { $$ = $2; }
        | VARIAVEL { $$ = variaveis[$1]; }
        ;

%%

void yyerror(char *s) {
    fprintf(stderr, "%s\n", s);
}

int main(void) {
    yyparse();
}
