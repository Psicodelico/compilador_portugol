#define STACK_MAX 50

/*
    Calculadora versao 3 - Stack.h
    Autores: Ed Prado, Edinaldo Carvalho, Elton Oliveira
             Marlon Chalegre, Rodrigo Castro
    Emails: {msgprado, truetypecode, elton.oliver,
             marlonchalegre, rodrigomsc}@gmail.com
*/

typedef struct {
    void *stack[STACK_MAX];
    int pt;
} Stack;

Stack *init_stack();
void *pop(Stack *s);
void push(Stack *s, void *value);
int is_stack_empty(Stack *s);
int is_stack_full(Stack *s);
