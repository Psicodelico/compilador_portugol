#include <stdio.h>
#include <stdlib.h>

void enqueue(char*);
char* dequeue(void);

typedef struct queue{

    char* value;
    struct queue *next;

}Queue;

Queue *first;
Queue *last;

void enqueue(char* value){

    if(last != NULL){

        last->value = value;
        last->next = (Queue*)malloc(sizeof(Queue));
        last = last -> next;
    
    }else{
    
        first = (Queue*) malloc(sizeof (Queue));
        first->value = value;
        first -> next = (Queue*) malloc(sizeof(Queue));
        last = first -> next;
    }

}

char* dequeue(void){
    
    char* result;
    Queue *next;

    if(first != NULL){

        result = first->value;
        next = first->next;
        free(first);
        first = next;
        return result;
    }else{
        return NULL;
    }
}

void init_queue(){

    first = last = NULL;
}
