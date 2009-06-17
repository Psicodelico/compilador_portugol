/*
    Portugol versao 1 - Stack.c
    Autores: Ed Prado, Edinaldo Carvalho, Elton Oliveira
             Marlon Chalegre, Rodrigo Castro
    Emails: {msgprado, truetypecode, elton.oliver,
             marlonchalegre, rodrigomsc}@gmail.com
*/

int stack[100];
int stack_pt = -1;

void push(int value) {
    stack[++stack_pt] = value;
}

int pop() {
    return stack[stack_pt--];
}

