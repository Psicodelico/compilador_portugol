#include <string.h>
#include "Tabela.h"

/* Procura na tabela de simbolos, nela iremos colocar nossas palavras reservadas e variaveis que estao sendo criadas */
/* se a palavra nao for encontrada ela e adicionada a tabela de simbolos*/
tabelaSimb* achaOuAdicionaId(char *nome){
        tabelaSimb *sp = NULL;
        int count;

	for(sp = tabSimb, count = 0; sp < &tabSimb[MAX_SIMB]; sp++, count++){ 
		/* Existe? */
		if (sp->idNome && !strcmp(sp->idNome, nome))
			return sp;
                /* ta livre? */
	        if (!sp->idNome) { 
		    sp->idNome = strdup(nome); //coloca na tabela de simbolos
                    sp->idx = count;
		    return sp; 
	        }
	}
       

	//a tabela de simbolos tem uma quantidade max, cuidado para n estourar
	yyerror("Espaco insuficiente.\n");
        return sp;
}

/* Procura na tabela de simbolos, nela iremos colocar nossas palavras reservadas e variaveis que estao sendo criadas */
/* se a palavra nao for encontrada ela e adicionada a tabela de simbolos*/
tabelaSimb* achaId(char *nome){
        tabelaSimb *sp = NULL;
        int count;

	for(sp = tabSimb, count = 0; sp < &tabSimb[MAX_SIMB]; sp++, count++){ 
		/* Existe? */
		if (sp->idNome && !strcmp(sp->idNome, nome))
			return sp;
	}

	//a tabela de simbolos tem uma quantidade max, cuidado para n estourar
	yyerror("ID nao encontrado.\n");
        return sp;
}
