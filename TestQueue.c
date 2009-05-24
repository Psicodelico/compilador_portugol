#include "Queue.h"

int main(){

    char* frase1= "Marlon\n";
    char* frase2="Chalegre\n";
    char* frase3="Maria\n";
    char* frase4="Polly\n";

    enqueue(frase1);
    enqueue(frase2);
    enqueue(frase3);
    enqueue(frase4);

    printf("%s", dequeue());
    printf("%s",dequeue());
    printf("%s", dequeue());
    printf("%s", dequeue());

    return 0;
}
