/*
    Portugol versao 3 - Fila.c
    Autores: Ed Prado, Edinaldo Carvalho, Elton Oliveira
             Marlon Chalegre, Rodrigo Castro
    Emails: {msgprado, truetypecode, elton.oliver,
             marlonchalegre, rodrigomsc}@gmail.com
*/

#include <stdio.h>
#include <stdlib.h>
#include "Fila.h"

Queue *init_queue(void) {
    Queue *nova = (Queue *) malloc(sizeof(Queue));
    Queue_elmt *elmt = (Queue_elmt*)malloc(sizeof(Queue_elmt));
    elmt->value = NULL;
    elmt->next = NULL;
    nova->first = nova->last = elmt;
    return nova;
}

Queue_elmt* newQueue_elmt(void) {
    Queue_elmt* elmt = (Queue_elmt*)malloc(sizeof(Queue_elmt));
    elmt->value = NULL;
    elmt->next = NULL;
    return elmt;
}

void enqueue(Queue *q, char* value){
    q->last->value = value;
    q->last->next = newQueue_elmt();
    q->last = q->last->next;
}

char *dequeue(Queue *q) {
    if (is_queue_empty(q))
	return NULL;
    char* value = q->first->value;
    Queue_elmt* next = q->first->next;
    free(q->first);
    q->first = q->first->next;
    return value;
}

int is_queue_empty(Queue *q) {
    return q->first->value == NULL;
}
