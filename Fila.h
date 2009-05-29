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
