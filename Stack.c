int stack[100];
int stack_pt = -1;

void push(int value) {
    stack[++stack_pt] = value;
}

int pop() {
    return stack[stack_pt--];
}

