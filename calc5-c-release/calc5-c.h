    /* Calculadora com comandos em C
        By Ruben Carlo Benante
        Email benante@gmail.com
    */
#define NSYMS 100
#define MAX_SVAL 80

typedef enum
{
    Undefined,        /*0, brand new identificator yet to be defined*/
	typeCon,          /*1, constant int*/
    typeReal,         /*2, constant real*/
    typeStr,          /*3, constant str*/
	typeIdCon,        /*4, id int*/
    typeIdReal,       /*5, id real*/
	typeIdStr,        /*6, id str*/
    typeIdFuncCon,    /*7, id func return int*/
    typeIdFuncReal,   /*8, id func return real*/
    typeIdFuncDouble, /*9, id func return real*/
    typeIdFuncStr,    /*10, id func return str*/
    typeIdFuncVoid,   /*11, id func return void*/
} nodeEnum;

typedef struct
{
      nodeEnum type;
      int idx; /* ts[idx] ou tf[idx]*/
      char *idName;
      int ival;
      float fval;
      char sval[MAX_SVAL];
      int (*ifuncptr)();      //ponteiro para funcao que retorna inteiro
      float (*ffuncptr)();    //ponteiro para funcao que retorna double
      double (*dfuncptr)();   //ponteiro para funcao que retorna double
      char *(*sfuncptr)();    //ponteiro para funcao que retorna ponteiro para char
      void (*vfuncptr)();     //ponteiro para a funcao que retorna void
} tableSym;

typedef struct
{
      char *code;
      char *res;
      nodeEnum typeRes; //only typeCon, typeReal and typeStr
      tableSym *pSymb; //char sIndex;
} cnode;

/* Super Tipo */
typedef struct
{
      nodeEnum type;
      char   *idName;
      int    ival;
      float  fval;
      char   sval[MAX_SVAL];
      int    (*ifptr)();   //ponteiro para funcao que retorna inteiro
      float  (*ffptr)();   //ponteiro para funcao que retorna float
      double (*dfptr)();   //ponteiro para funcao que retorna double
      char   *(*sfptr)();  //ponteiro para funcao que retorna ponteiro para char
      void   (*vfptr)();   //ponteiro para a funcao que retorna void
} superTipo;

tableSym sym[NSYMS];
tableSym *symLook(char *s);
