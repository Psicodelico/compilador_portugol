/*
   Calculadora versao 2 - calculadora.c
   Autores: Ed Prado, Edinaldo Carvalho, Elton Oliveira
            Marlon Chalegre, Rodrigo Castro
   Emails: {msgprado, truetypecode, elton.oliver,
            marlonchalegre, rodrigomsc}@gmail.com
*/

#include <stdlib.h>
#include "calculadora.h"

tabelaSimb *nova_ts() {
    tabelaSimb *ts = (tabelaSimb *) malloc(sizeof(tabelaSimb));
    return ts;
}

void init_ts() {
    int i;
    for(i = 0; i < MAX_TS; i++)
        ts[i].tipo = tipoIndef;
}
