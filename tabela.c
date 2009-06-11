#include <string.h>
#include "Tabela.h"

char buffer[100];

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
        int count;

	for(sp = tabSimb, count = 0; sp < &tabSimb[MAX_SIMB]; sp++, count++){ 
		/* Existe? */
		if (sp->uso && sp->idNome && !strcmp(sp->idNome, nome))
			return sp;
                /* ta livre? */
	        if (!sp->uso) { 
                    sp->uso = 1;
		    sp->idNome = strdup(nome); //coloca na tabela de simbolos
                    sp->idx = count;
                    sp->tipoD = tipoDado.tipoIdIndef;
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
                    sprintf(buffer, "%d", valor);
                    sp->uso = 1;
                    sp->ival = valor;
                    sp->sval = stddup(buffer); 
                    sp->tipoD = tipoDado.tipoConInt;
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
                    sp->fval = valor;
                    sp->tipoD = tipoDado.tipoConFloat;
		    return sp;
	        }
	}

	//a tabela de simbolos tem uma quantidade max, cuidado para n estourar
	yyerror("Espaco insuficiente.\n");
        return sp;
}
