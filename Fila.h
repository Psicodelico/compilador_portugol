/*
    Portugol versao 1 - Fila.h
    Autores: Ed Prado, Edinaldo Carvalho, Elton Oliveira
             Marlon Chalegre, Rodrigo Castro
    Emails: {msgprado, truetypecode, elton.oliver,
             marlonchalegre, rodrigomsc}@gmail.com
*/

#include <stdio.h>
#include <stdlib.h>

typedef struct queue{

    char* value;
    struct queue *next;

} Queue;

Queue* newQueue(void);
void enqueue(char* value);
char* dequeue(void);
int is_empty(void);
void init_queue(void);
