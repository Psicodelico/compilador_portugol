//    Compilador PORTUGOL versao 2q
//    Autor: Ruben Carlo Benante
//    Email: benante@gmail.com
//    Data: 23/04/2009

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>
#include "calc5-c.h"
#include "saida.h"

#define STACK_SIZE 100
#define FUNC_NAME_SIZE 32
#define MAX_PARAM 4

superTipo gstack[STACK_SIZE];   //pilha
int gsi=0;                      //indice da pilha geral

#define jump_f(Q1,NUL1,LABEL) if(!(Q1.ival)) goto LABEL    /* jump to LABEL if Q1.ival==false */
#define jump(NUL1,NUL2,LABEL) goto LABEL            /* jump to LABEL */
void nop(superTipo  *nul1, superTipo  *nul2, superTipo  *nul3);    // do nothing
void halt(superTipo  *nul1, superTipo  *nul2, superTipo  *nul3);   // abort with exit(1)

void loadi(int i,   int *nul1,   superTipo *tn);// { tn->tipo=tipoConInt; tn->ival=i; }
void loadf(float f, float *nul1, superTipo *tn);// { tn->tipo=tipoConFloat; tn->fval=f; }
void loads(char *s, char *nul1,  superTipo *tn);// { tn->tipo=tipoConStr; strcpy(tn->sval,s); }
void mov(superTipo q1, superTipo *nul1, superTipo *qres);               //qres=q1;

void uminus(superTipo  q1, superTipo  *nul1, superTipo  *qres);    // *qres = -q1
void add(superTipo  q1, superTipo  q2, superTipo  *qres);          // *qres = q1 + q2
void sub(superTipo  q1, superTipo  q2, superTipo  *qres);          // *qres = q1 - q2
void mult(superTipo  q1, superTipo  q2, superTipo  *qres);         // *qres = q1 * q2
void divi(superTipo  q1, superTipo  q2, superTipo  *qres);         // *qres = q1 / q2
void mod(superTipo  q1, superTipo  q2, superTipo  *qres);          // *qres = q1 % q2
void comp_eq(superTipo  q1, superTipo  q2, superTipo  *qres);      // *qres = (q1 == q2)
void comp_ne(superTipo  q1, superTipo  q2, superTipo  *qres);      // *qres = (q1 != q2)
void comp_gt(superTipo  q1, superTipo  q2, superTipo  *qres);      // *qres = (q1 > q2)
void comp_lt(superTipo  q1, superTipo  q2, superTipo  *qres);      // *qres = (q1 < q2)
void comp_ge(superTipo  q1, superTipo  q2, superTipo  *qres);      // *qres = (q1 >= q2)
void comp_le(superTipo  q1, superTipo  q2, superTipo  *qres);      // *qres = (q1 <= q2)
void rela_an(superTipo  q1, superTipo  q2, superTipo  *qres);      // *qres = (q1 && q2)
void rela_or(superTipo  q1, superTipo  q2, superTipo  *qres);      // *qres = (q1 || q2)
void rela_no(superTipo  q1, superTipo  *nul1, superTipo  *qres);   // *qres = (!q1)
void param(superTipo q1, void *nul1, void *nul2); // push(q1)
void call(char *q1, int q2, superTipo  *qres);    // *qres = f_name(a[1], ..., a[q2]); where q1:f_name, q2:quantity of param

/* ------------------------------------------------------------------------------------------------- */

/* auxiliar functions */

void push(superTipo g); // poe na pilha de execucao
superTipo *pop(void);   // tira da pilha de execucao

/* function bodies */

void push(superTipo g) // poe na pilha de execucao geral
{
    gstack[gsi]=g; //copia por valor
    gsi++;
    if(gsi>=STACK_SIZE)
    {
        fprintf(stderr,"Erro: pilha de execucao geral cheia.\n");
        exit(1);
    }
}

superTipo *pop(void)    // tira da pilha de execucao geral
{
    superTipo *r;
    if(gsi<=0)
    {
        fprintf(stderr,"Erro: pilha de execucao geral vazia.\n");
        exit(1);
    }
    r=malloc(sizeof(superTipo));
    *r=gstack[--gsi]; //copia por valor
    return(r); //&gstack[--gsi]
}

/* jump operations */
//   jump(NULL,NULL,l2);
//   jump_f(temp[0],NULL,l1);
//---------------------------

//jump_f(tem[13],NULL,l1); // jump if false, i.e., if q1==false jump to label l1
#define jump_f(Q1,NUL1,LABEL) if(!(Q1.ival)) goto LABEL    /* jump to LABEL if Q1==false */
//jump(NULL,NULL,l1); // unconditional jump to label l1
#define jump(NUL1,NUL2,LABEL) goto LABEL            /* jump to LABEL */

/* misc operations */
//nop(NULL,NULL,NULL); // do nothing (just like python keyword pass)
//halt(NULL,NULL,NULL); // abort with exit(1)
//---------------------------

//nop : //do nothing
void nop(superTipo  *nul1, superTipo  *nul2, superTipo  *nul3)
{
    ;
}

// abort with exit(1)
void halt(superTipo  *nul1, superTipo  *nul2, superTipo  *nul3)
{
    exit(1);
}

/* memory operations */
//  mov(tp[8],NULL,&ts[3]);
//loadi(1,    NULL, &tp[1]);
//loadf(1.1,  NULL, &tp[1]);
//loads("oi", NULL, &tp[2]);

//---------------------------
void loadi(int i,   int *nul1,   superTipo *qres)
{
    qres->type=typeCon;
    qres->ival=i;
    qres->fval=0.0;
    qres->sval[0]='\0';
}

void loadf(float f, float *nul1, superTipo *qres)
{
    qres->type=typeReal;
    qres->ival=0;
    qres->fval=f;
    qres->sval[0]='\0';
}

void loads(char *s, char *nul1,  superTipo *qres)
{
    qres->type=typeStr;
    qres->ival=0;
    qres->fval=0.0;
    strcpy(qres->sval, s);
}

void mov(superTipo q1, superTipo *nul1, superTipo *qres)
{
    qres->type=q1.type;
    if(q1.type==typeCon)
        qres->ival=q1.ival;
    else if(q1.type==typeReal)
        qres->fval=q1.fval;
    else if(q1.type=typeStr)
        strcpy(qres->sval, q1.sval);
    else
    {
        fprintf(stderr,"invalid mov operation.\n");
        exit(1);
    }
}

/*mathematical operations */
//   uminus(3.00,NULL,&temp[1]);
//   add(temp[2],4.00,&temp[3]);
//   sub(temp[5],temp[6],&temp[7]);
//   mult(1.00,temp[3],&temp[4]);
//   divi(2.00,temp[1],&temp[2]);
//---------------------------

//  uminus  (3.00,NULL,&temp[1]); //temp[1]=-3.0;
void uminus(superTipo  q1, superTipo  *nul1, superTipo  *qres)
{
    if(q1.type==typeStr)
    {
        fprintf(stderr,"invalid uminus operation.\n");
        exit(1);
    }
    qres->type=q1.type;
    if(q1.type==typeCon)
        qres->ival=-q1.ival;
    else
        qres->fval=-q1.fval;
}
//   add(temp[2],4.00,&temp[3]); //temp[3]=temp[2]+4.0;
void add(superTipo  q1, superTipo  q2, superTipo  *qres)
{

    float arg1, arg2;

    if((q1.type == typeStr || q2.type == typeStr) && (q1.type != typeStr || q2.type != typeStr))
    {
        fprintf(stderr,"invalid add operation.\n");
        exit(1);
    }

    if(q1.type == typeStr) //se um eh, ambos sao
    {
        qres->type=typeStr;
        strcpy(qres->sval, q1.sval);
        strcat(qres->sval, q2.sval);
        return;
    }

    if(q1.type == typeReal)
        arg1=q1.fval;
    else
        arg1=(float)q1.ival;
    if(q2.type == typeReal)
        arg2=q2.fval;
    else
        arg2=(float)q2.ival;

    if(q1.type == typeReal || q2.type == typeReal)
    {
        qres->fval=arg1 + arg2;
        qres->type=typeReal;
    }
    else
    {
        qres->ival=(int)(arg1 + arg2);
        qres->type=typeCon;
    }
}

//   sub(temp[5],temp[6],&temp[7]); //temp[7]=temp[5]-temp[6];
void sub(superTipo  q1, superTipo  q2, superTipo  *qres)
{

    float arg1, arg2;

    if(q1.type == typeStr || q2.type == typeStr)
    {
        fprintf(stderr,"invalid sub operation.\n");
        exit(1);
    }

    if(q1.type == typeReal)
        arg1=q1.fval;
    else
        arg1=(float)q1.ival;
    if(q2.type == typeReal)
        arg2=q2.fval;
    else
        arg2=(float)q2.ival;

    if(q1.type == typeReal || q2.type == typeReal)
    {
        qres->fval=arg1 - arg2;
        qres->type=typeReal;
    }
    else
    {
        qres->ival=(int)(arg1 - arg2);
        qres->type=typeCon;
    }
}

//   mult(1.00,temp[3],&temp[4]); //temp[4]=1.0*temp[3];
void mult(superTipo  q1, superTipo  q2, superTipo  *qres)
{

    float arg1, arg2;

    if(q1.type == typeStr || q2.type == typeStr)
    {
        fprintf(stderr,"invalid mult operation.\n");
        exit(1);
    }

    if(q1.type == typeReal)
        arg1=q1.fval;
    else
        arg1=(float)q1.ival;
    if(q2.type == typeReal)
        arg2=q2.fval;
    else
        arg2=(float)q2.ival;

    if(q1.type == typeReal || q2.type == typeReal)
    {
        qres->fval=arg1 * arg2;
        qres->type=typeReal;
    }
    else
    {
        qres->ival=(int)(arg1 * arg2);
        qres->type=typeCon;
    }
}

//   divi(2.00,temp[1],&temp[2]); //temp[2]=2.0/temp[1];
void divi(superTipo  q1, superTipo  q2, superTipo  *qres)
{

    float arg1, arg2;

    if(q1.type == typeStr || q2.type == typeStr)
    {
        fprintf(stderr,"invalid divi operation.\n");
        exit(1);
    }

    if(q2.type == typeReal)
        arg2=q2.fval;
    else
        arg2=(float)q2.ival;
    if(arg2==0.0)
    {
        fprintf(stderr,"division by zero.\n");
        exit(1);
    }
    if(q1.type == typeReal)
        arg1=q1.fval;
    else
        arg1=(float)q1.ival;

    if(q1.type == typeReal || q2.type == typeReal)
    {
        qres->fval=arg1 / arg2;
        qres->type=typeReal;
    }
    else
    {
        qres->ival=(int)(arg1 / arg2);
        qres->type=typeCon;
    }
}

void mod(superTipo  q1, superTipo  q2, superTipo  *qres)          // *qres = q1 % q2
{

    int arg1, arg2;

    if(q1.type == typeStr || q2.type == typeStr)
    {
        fprintf(stderr,"invalid mod operation.\n");
        exit(1);
    }

    if(q2.type == typeReal)
        arg2=(int)q2.fval;
    else
        arg2=q2.ival;
    if(arg2==0)
    {
        fprintf(stderr,"mod division by zero.\n");
        exit(1);
    }
    if(q1.type == typeReal)
        arg1=(int)q1.fval;
    else
        arg1=q1.ival;

    qres->type=typeCon;
    qres->ival=arg1 % arg2;
}

/* logical operations */
//   comp_eq(ts[1],2.00,&temp[0]);
//   comp_ne(ts[1],2.00,&temp[10]);
//   comp_gt(ts[0],2.00,&temp[15]);
//   comp_lt(ts[1],3.00,&temp[16]);
//   comp_ge(ts[2],3.00,&temp[11]);
//   comp_le(ts[3],0.00,&temp[14]);
//---------------------------

//   comp_eq(ts[1],2.00,&temp[0]); //temp[0]=(ts[1]==2.0);
void comp_eq(superTipo  q1, superTipo  q2, superTipo  *qres)
{

    float arg1, arg2;

    if((q1.type == typeStr || q2.type == typeStr) && (q1.type != typeStr || q2.type != typeStr))
    {
        fprintf(stderr,"invalid comp_eq operation.\n");
        exit(1);
    }

    qres->type=typeCon;
    if(q1.type == typeStr) //se um eh, ambos sao
    {
        qres->ival = !(strcmp(q1.sval, q2.sval));
        return;
    }

    if(q1.type == typeReal)
        arg1=q1.fval;
    else
        arg1=(float)q1.ival;
    if(q2.type == typeReal)
        arg2=q2.fval;
    else
        arg2=(float)q2.ival;

    qres->ival=(int)(arg1 == arg2);
}

//   comp_ne(ts[1],2.00,&temp[10]); //temp[10]=(ts[1]!=2.0);
void comp_ne(superTipo  q1, superTipo  q2, superTipo  *qres)
{

    float arg1, arg2;

    if((q1.type == typeStr || q2.type == typeStr) && (q1.type != typeStr || q2.type != typeStr))
    {
        fprintf(stderr,"invalid comp_ne operation.\n");
        exit(1);
    }

    qres->type=typeCon;
    if(q1.type == typeStr) //se um eh, ambos sao
    {
        qres->ival = !!(strcmp(q1.sval, q2.sval));
        return;
    }

    if(q1.type == typeReal)
        arg1=q1.fval;
    else
        arg1=(float)q1.ival;
    if(q2.type == typeReal)
        arg2=q2.fval;
    else
        arg2=(float)q2.ival;

    qres->ival=(int)(arg1 != arg2);
}

//   comp_gt(ts[0],2.00,&temp[15]); //temp[15]=(ts[0]>2.0);
void comp_gt(superTipo  q1, superTipo  q2, superTipo  *qres)
{

    float arg1, arg2;

    if((q1.type == typeStr || q2.type == typeStr) && (q1.type != typeStr || q2.type != typeStr))
    {
        fprintf(stderr,"invalid comp_gt operation.\n");
        exit(1);
    }

    qres->type=typeCon;
    if(q1.type == typeStr) //se um eh, ambos sao
    {
        qres->ival = (strcmp(q1.sval, q2.sval)>0); //(bb,aa)==1
        return;
    }

    if(q1.type == typeReal)
        arg1=q1.fval;
    else
        arg1=(float)q1.ival;
    if(q2.type == typeReal)
        arg2=q2.fval;
    else
        arg2=(float)q2.ival;

    qres->ival=(int)(arg1 > arg2);
}


//   comp_lt(ts[1],3.00,&temp[16]); //temp[16]=(ts[1]<3.0);
void comp_lt(superTipo  q1, superTipo  q2, superTipo  *qres)
{
    float arg1, arg2;

    if((q1.type == typeStr || q2.type == typeStr) && (q1.type != typeStr || q2.type != typeStr))
    {
        fprintf(stderr,"invalid comp_lt operation.\n");
        exit(1);
    }

    qres->type=typeCon;
    if(q1.type == typeStr) //se um eh, ambos sao
    {
        qres->ival = (strcmp(q1.sval, q2.sval)<0); //(aa,bb)==-1
        return;
    }

    if(q1.type == typeReal)
        arg1=q1.fval;
    else
        arg1=(float)q1.ival;
    if(q2.type == typeReal)
        arg2=q2.fval;
    else
        arg2=(float)q2.ival;

    qres->ival=(int)(arg1 < arg2);
}

//   comp_ge(ts[2],3.00,&temp[11]); //temp[11]=(ts[2]>=3.0);
void comp_ge(superTipo  q1, superTipo  q2, superTipo  *qres)
{
    float arg1, arg2;

    if((q1.type == typeStr || q2.type == typeStr) && (q1.type != typeStr || q2.type != typeStr))
    {
        fprintf(stderr,"invalid comp_ge operation.\n");
        exit(1);
    }

    qres->type=typeCon;
    if(q1.type == typeStr) //se um eh, ambos sao
    {
        qres->ival = (strcmp(q1.sval, q2.sval)>=0); //(bb,aa)==1, (bb,bb)==0
        return;
    }

    if(q1.type == typeReal)
        arg1=q1.fval;
    else
        arg1=(float)q1.ival;
    if(q2.type == typeReal)
        arg2=q2.fval;
    else
        arg2=(float)q2.ival;

    qres->ival=(int)(arg1 >= arg2);
}

//   comp_le(ts[3],0.00,&temp[14]); //temp[14]=(ts[3]<=0.0);
void comp_le(superTipo  q1, superTipo  q2, superTipo  *qres)
{
    float arg1, arg2;

    if((q1.type == typeStr || q2.type == typeStr) && (q1.type != typeStr || q2.type != typeStr))
    {
        fprintf(stderr,"invalid comp_le operation.\n");
        exit(1);
    }

    qres->type=typeCon;
    if(q1.type == typeStr) //se um eh, ambos sao
    {
        qres->ival = (strcmp(q1.sval, q2.sval)<=0); //(aa,bb)==-1, (bb,bb)==0
        return;
    }

    if(q1.type == typeReal)
        arg1=q1.fval;
    else
        arg1=(float)q1.ival;
    if(q2.type == typeReal)
        arg2=q2.fval;
    else
        arg2=(float)q2.ival;

    qres->ival=(int)(arg1 <= arg2);
}

/* relational operations */
//   rela_an(temp[10],temp[11],&temp[12]);
//   rela_or(temp[9],temp[12],&temp[13]);
//   rela_no(temp[17],NULL,&temp[18]);
//---------------------------

//   rela_an(temp[10],temp[11],&temp[12]); //temp[12]=(temp[10]&&temp[11]);
void rela_an(superTipo  q1, superTipo  q2, superTipo  *qres)
{
    float arg1, arg2;

    if(q1.type == typeStr || q2.type == typeStr)
    {
        fprintf(stderr,"invalid rela_an operation.\n");
        exit(1);
    }

    qres->type=typeCon;
    if(q1.type == typeReal)
        arg1=q1.fval;
    else
        arg1=(float)q1.ival;
    if(q2.type == typeReal)
        arg2=q2.fval;
    else
        arg2=(float)q2.ival;

    qres->ival=(int)(arg1 && arg2);
}
//   rela_or(temp[9],temp[12],&temp[13]); //temp[13]=(temp[9]||temp[12]);
void rela_or(superTipo  q1, superTipo  q2, superTipo  *qres)
{
    float arg1, arg2;

    if(q1.type == typeStr || q2.type == typeStr)
    {
        fprintf(stderr,"invalid rela_or operation.\n");
        exit(1);
    }

    qres->type=typeCon;
    if(q1.type == typeReal)
        arg1=q1.fval;
    else
        arg1=(float)q1.ival;
    if(q2.type == typeReal)
        arg2=q2.fval;
    else
        arg2=(float)q2.ival;

    qres->ival=(int)(arg1 || arg2);
}

//   rela_no(temp[17],NULL,&temp[18]); //temp[18]=!(temp[17]);
void rela_no(superTipo  q1, superTipo  *nul1, superTipo  *qres)
{

    if(q1.type == typeStr)
    {
        fprintf(stderr,"invalid rela_no operation.\n");
        exit(1);
    }

    qres->type=typeCon;
    if(q1.type == typeReal)
        qres->ival=(int)(!(q1.fval));
    else
        qres->ival=!(q1.ival);
}

/*stack and function operations */
//   param(temp[1],NULL,NULL);
//   call("print",1,&ts[1]);
//---------------------------

//   param(temp[1],NULL,NULL); // put temp[1] into parameter stack
void param(superTipo q1, void *nul1, void *nul2)
{
    push(q1);
}

//  call    ("print",1,&ts[0]); //call a function "print" with 1 arg from stack, and return a value to ts[0].
void call(char *q1, int i, superTipo  *qres)
{
    int j=0, idx;
    superTipo *g[MAX_PARAM];//maximo funcao com 4 argumentos f(a0, a1, a2, a3);

    if(i>MAX_PARAM)
    {
        fprintf(stderr, "error: cant call function with more than %d (MAX_PARAM) parameters.\n", MAX_PARAM);
        exit(1);
    }

    for(j=0; j<i && j<MAX_PARAM; j++)
        g[j]=pop();    //pop all parameters

    /* lista de funcoes */
    for(idx=0; idx<MAX_TF; idx++)
        if(strcmp(tf[idx].idName, q1) == 0) //found!
            break;
    if(idx==MAX_TF)
    {
        fprintf(stderr, "error: function not in tf[] table (loop exausted).\n");
        exit(1);
    }

    switch(idx)
    {
        case 0: //printf
            if(g[0]->type==typeStr)
                (*tf[idx].vfptr)("%s\n", g[0]->sval); //printf("%s\n",sval);
            else if(g[0]->type==typeCon)
                (*tf[idx].vfptr)("%d\n", g[0]->ival); //printf("%d\n",ival);
            else /* typeFloat */
                (*tf[idx].vfptr)("%.2f\n", g[0]->fval); //printf("%.2f\n",fval);
            break;
        case 1: //scanf
            (*tf[idx].vfptr)("%f", &qres->fval); //scanf("%f",&ts[1]);
            qres->type=typeReal;
            break;
        case 2: //exit
            (*tf[idx].vfptr)("%f", g[0]->ival); //exit(ival)
            break;
        case 3: //sqrt
            qres->fval=(*tf[idx].dfptr)(g[0]->fval); //sqrt(fval)
            qres->type=typeReal;
            break;
        case 4: //exp
            qres->fval=(*tf[idx].dfptr)(g[0]->fval); //sqrt(fval)
            qres->type=typeReal;
            break;
        default:
            fprintf(stderr, "error: function not in tf[] table. (default switch)\n");
            exit(1);
    }
}
