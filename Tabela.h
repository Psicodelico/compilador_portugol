#define NSYMS 20  

 struct symtab {

       char *nome;
       double valor;
       int key; //apelacao para saber se eh palavra chave

} symtab[NSYMS];

struct symtab* lookup(char *s,int key);
