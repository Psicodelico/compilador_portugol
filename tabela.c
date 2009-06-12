#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include "Tabela.h"

char buffer[100];
int idxId = 0;
int idxFunc = 0;
int idxCon = 0;

void iniciarTabelaSimb() {
        tabelaSimb *sp = NULL;
	for(sp = tabSimb; sp < &tabSimb[MAX_SIMB]; sp++) { 
            sp->uso = 0;
	}
}

/* Procura na tabela de simbolos, nela iremos colocar nossas palavras reservadas e variaveis que estao sendo criadas */
/* se a palavra nao for encontrada ela e adicionada a tabela de simbolos*/
tabelaSimb* achaId(char *nome){
        tabelaSimb *sp = NULL;

	for (sp = tabSimb; sp < &tabSimb[MAX_SIMB]; sp++) { 
		/* Existe? */
		if (sp->uso && sp->idNome && !strcmp(sp->idNome, nome))
			return sp;
                /* ta livre? */
	        if (!sp->uso) { 
                    sp->uso = 1;
                    sp->tipoD = tipoIdIndef;
		    sp->idNome = strdup(nome); //coloca na tabela de simbolos
                    sp->idx = idxId++;
                    sprintf(buffer, "ts[%d]", sp->idx);
                    sp->sval = strdup(buffer);
		    return sp; 
	        }
	}
       
	//a tabela de simbolos tem uma quantidade max, cuidado para n estourar
	yyerror("Espaco insuficiente.\n");
        return sp;
}

tabelaSimb* achaInt(int valor){
        tabelaSimb *sp = NULL;

	for(sp = tabSimb; sp < &tabSimb[MAX_SIMB]; sp++) { 
		/* Existe? */
		if (sp->uso && sp->ival == valor)
	            return sp;
                /* ta livre? */
	        if (!sp->uso) { 
                    sp->uso = 1;
                    sp->load = 0;
                    sp->tipoD = tipoConInt;
                    sp->ival = valor;
                    sp->idx = idxCon++;
                    sprintf(buffer, "tc[%d]", sp->idx);
                    sp->sval = strdup(buffer); 
		    return sp;
	        }
	}

	//a tabela de simbolos tem uma quantidade max, cuidado para n estourar
	yyerror("Espaco insuficiente.\n");
        return sp;
}

tabelaSimb* achaFloat(float valor){
        tabelaSimb *sp = NULL;

	for(sp = tabSimb; sp < &tabSimb[MAX_SIMB]; sp++) { 
		/* Existe? */
		if (sp->uso && sp->fval == valor)
	            return sp;
                /* ta livre? */
	        if (!sp->uso) { 
                    sp->uso = 1;
                    sp->load = 0;
                    sp->tipoD = tipoConFloat;
                    sp->fval = valor;
                    sp->idx = idxCon++;
                    sprintf(buffer, "tc[%d]", sp->idx);
                    sp->sval = strdup(buffer);
		    return sp;
	        }
	}

	//a tabela de simbolos tem uma quantidade max, cuidado para n estourar
	yyerror("Espaco insuficiente.\n");
        return sp;
}
