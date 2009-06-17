#define STACK_MAX 50

typedef struct {
    float stack[STACK_MAX];
    int pt;
} Stack;

Stack *init_stack();
float pop(Stack *s);
void push(Stack *s, float value);
int is_stack_empty(Stack *s);
int is_stack_full(Stack *s);
