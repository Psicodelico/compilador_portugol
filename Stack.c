#include <stdlib.h>
#include <stdio.h>
#include "Stack.h"

/*
    Calculadora versao 3 - Stack.c
    Autores: Ed Prado, Edinaldo Carvalho, Elton Oliveira
             Marlon Chalegre, Rodrigo Castro
    Emails: {msgprado, truetypecode, elton.oliver,
             marlonchalegre, rodrigomsc}@gmail.com
*/


Stack *init_stack() {
    Stack *s = (Stack *) malloc(sizeof(Stack));
    s->pt = -1;
    return s;
}

void push(Stack *s, void *value) {
    if (!is_stack_full(s))
        s->stack[++s->pt] = value;
    else
        printf("Error: stack full.\n");
}

void *pop(Stack *s) {
    if (!is_stack_empty(s))
        return s->stack[s->pt--];
    else {
        printf("Error: stack empty.\n");
        return (void *)-1;
    }
}

int is_stack_empty(Stack *s) {
    return s->pt == -1;
}

int is_stack_full(Stack *s) {
    return s->pt == STACK_MAX;
}
