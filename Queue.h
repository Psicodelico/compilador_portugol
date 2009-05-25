#include <stdio.h>
#include <stdlib.h>

void enqueue(char*);
char* dequeue(void);

typedef struct queue{

    char* value;
    struct queue *next;

}Queue;

int size = 0;

Queue *first;
Queue *last;

void enqueue(char* value){

    //printf("entrou %s\n", value);
    if(last != NULL){
    
        last->next = (Queue*)malloc(sizeof(Queue));
        last->next->value = value;
        last->next->next = NULL;
        last = last -> next;

        if(first == NULL){
            first = last;
        }
   
    }else{
    
        first = (Queue*) malloc(sizeof (Queue));
        first->value = value;
        first -> next = NULL;
        last = first;
    }

        size++;
}

char* dequeue(void){
    
    char* result;
    Queue *next;

    if(first != NULL){

        result = first->value;
        next = first->next;
        free(first);
        first = next;
        
        size--;
        
        return result;

    }else{

        return NULL;
    }
}

int is_empty() {
        
    if(first == NULL)
        return 1;
    else
        return 0;
}

void init_queue(){

    first = last = NULL;
}
