#include "Tabela.h"

/* Procura na tabela de simbolos, nela iremos colocar nossas palavras reservadas e variaveis que estao sendo criadas */
/* se a palavra nao for encontrada ela e adicionada a tabela de simbolos*/
struct tabelaSimb* acharId(char *nome){
	
	for(sp = tabSimb; sp < &tabSimb[MAX_SIMB]; sp++){ 
	
		/* Existe? */
		if (sp->idNome && !strcmp(sp->idNome, s))
			return sp;

	}
       
        /* ta livre? */
	if(!sp->nome) { 
		sp->nome = strdup(s); //coloca na tabela de simbolos
		sp->key = key;			
		return sp; 
	}


	//a tabela de simbolos tem uma quantidade max, cuidado para n estourar
	yyerror("ID nao encontrado.");
	return 0;
}


