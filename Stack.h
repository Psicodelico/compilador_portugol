#define STACK_MAX 50

typedef struct {
    int stack[STACK_MAX];
    int pt;
} Stack;

Stack *init_stack();
int pop(Stack *s);
void push(Stack *s, int value);
int is_stack_empty(Stack *s);
int is_stack_full(Stack *s);
