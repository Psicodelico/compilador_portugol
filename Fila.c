/*
    Portugol versao 1 - Fila.c
    Autores: Ed Prado, Edinaldo Carvalho, Elton Oliveira
             Marlon Chalegre, Rodrigo Castro
    Emails: {msgprado, truetypecode, elton.oliver,
             marlonchalegre, rodrigomsc}@gmail.com
*/

#include <stdio.h>
#include <stdlib.h>
#include "Fila.h"

Queue* first;
Queue* last;

Queue* newQueue() {
	Queue* nova = (Queue*)malloc(sizeof(Queue));
	nova->value = NULL;
	nova->next = NULL;
	return nova;
}

void enqueue(char* value){
	last->value = value;
	last->next = newQueue();
	last = last->next;
}

char* dequeue(void){
	if(is_empty())
		return NULL;
	char* value = first->value;
	Queue* next = first->next;
	free(first);
	first = first->next;
	return value;
}

int is_empty() {
	return first->value == NULL;
}

void init_queue(){
	first = last = newQueue();
}


