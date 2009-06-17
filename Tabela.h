/*
    Portugol versao 1 - Tabela.h
    Autores: Ed Prado, Edinaldo Carvalho, Elton Oliveira
             Marlon Chalegre, Rodrigo Castro
    Emails: {msgprado, truetypecode, elton.oliver,
             marlonchalegre, rodrigomsc}@gmail.com
*/

#define NSYMS 20  

 struct symtab {

       char *nome;
       double valor;
       int key; //apelacao para saber se eh palavra chave

} symtab[NSYMS];

struct symtab* lookup(char *s,int key);
