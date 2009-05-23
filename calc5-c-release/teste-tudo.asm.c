//    Gerado pelo compilador Calc versao 5
//    Autor: Ruben Carlo Benante
//    Email: benante@gmail.com
//    Data: 21/05/2009

#include <math.h>
#include "quadruplas.h"
#include "saida.h"

void filltf(void)
{
  tf[0].type=typeIdFuncVoid;
  tf[0].vfptr=(void *)printf;
  tf[0].idName=malloc(strlen("printf")+1);
  strcpy(tf[0].idName,"printf");

  tf[1].type=typeIdFuncVoid;
  tf[1].vfptr=(void *)scanf;
  tf[1].idName=malloc(strlen("scanf")+1);
  strcpy(tf[1].idName,"scanf");

  tf[2].type=typeIdFuncVoid;
  tf[2].vfptr=(void *)exit;
  tf[2].idName=malloc(strlen("exit")+1);
  strcpy(tf[2].idName,"exit");

  tf[3].type=typeIdFuncDouble;
  tf[3].dfptr=sqrt;
  tf[3].idName=malloc(strlen("sqrt")+1);
  strcpy(tf[3].idName,"sqrt");

  tf[4].type=typeIdFuncDouble;
  tf[4].dfptr=exp;
  tf[4].idName=malloc(strlen("exp")+1);
  strcpy(tf[4].idName,"exp");

}

int main(void)
{
  filltf();

  loads("\0", NULL, &ts[0]); /* str S; */
  loadi(0, NULL, &ts[1]); /* int A; */
  loadf(0.0, NULL, &ts[2]); /* float O; */
  loads("\0", NULL, &ts[3]); /* str T; */
  loadi(0, NULL, &ts[4]); /* int B; */
  loadf(0.0, NULL, &ts[5]); /* float P; */
  loadi(0, NULL, &ts[6]); /* int N; */
  loadf(0.0, NULL, &ts[7]); /* float D; */
  loadi(0, NULL, &ts[8]); /* int C; */
  loadf(0.0, NULL, &ts[9]); /* float M; */
  loads("oi", NULL, &tp[0]);
  mov(tp[0], NULL, &ts[0]); /* S = tp[0] */
  loadi(1, NULL, &tp[1]);
  mov(tp[1], NULL, &ts[1]); /* A = tp[1] */
  loadf(2.2, NULL, &tp[2]);
  mov(tp[2], NULL, &ts[2]); /* O = tp[2] */
  nop(NULL, NULL, NULL);
  mov(ts[0], NULL, &ts[3]); /* T = ts[0] */
  mov(ts[1], NULL, &ts[4]); /* B = ts[1] */
  mov(ts[2], NULL, &ts[5]); /* P = ts[2] */
  nop(NULL, NULL, NULL);
  loads("S=?", NULL, &tp[3]);
  param(tp[3], NULL, NULL);
  call("printf", 1, NULL);
  param(ts[0], NULL, NULL);
  call("printf", 1, NULL);
  loads("A=?", NULL, &tp[4]);
  param(tp[4], NULL, NULL);
  call("printf", 1, NULL);
  param(ts[1], NULL, NULL);
  call("printf", 1, NULL);
  loads("O=?", NULL, &tp[5]);
  param(tp[5], NULL, NULL);
  call("printf", 1, NULL);
  param(ts[2], NULL, NULL);
  call("printf", 1, NULL);
  nop(NULL, NULL, NULL);
  loadf(11.1, NULL, &tp[6]);
  param(tp[6], NULL, NULL);
  call("printf", 1, NULL);
  loadi(1, NULL, &tp[7]);
  param(tp[7], NULL, NULL);
  call("printf", 1, NULL);
  loads("alo cons", NULL, &tp[8]);
  param(tp[8], NULL, NULL);
  call("printf", 1, NULL);
  nop(NULL, NULL, NULL);
  nop(NULL, NULL, NULL);
  loadf(1.0, NULL, &tp[9]);
  loadi(1, NULL, &tp[10]);
  loadi(2, NULL, &tp[11]);
  loadi(3, NULL, &tp[12]);
  uminus(tp[12], NULL, &tp[13]);
  divi(tp[11], tp[13], &tp[14]);
  loadf(4.0, NULL, &tp[15]);
  add(tp[14], tp[15], &tp[16]);
  mult(tp[10], tp[16], &tp[17]);
  add(tp[9], tp[17], &tp[18]);
  mult(ts[1], ts[4], &tp[19]);
  sub(tp[18], tp[19], &tp[20]);
  add(tp[20], ts[8], &tp[21]);
  mov(tp[21], NULL, &ts[7]); /* D = tp[21] */
  loadi(1, NULL, &tp[22]);
  comp_eq(ts[1], tp[22], &tp[23]);
  loadf(2.0, NULL, &tp[24]);
  comp_ne(ts[4], tp[24], &tp[25]);
  loadf(3.0, NULL, &tp[26]);
  comp_ge(ts[8], tp[26], &tp[27]);
  rela_an(tp[25], tp[27], &tp[28]);
  rela_or(tp[23], tp[28], &tp[29]);
  jump_f(tp[29], NULL, l4); /* if */
  loadi(0, NULL, &tp[30]);
  comp_le(ts[7], tp[30], &tp[31]);
  jump_f(tp[31], NULL, l2); /* if */
  loadf(111.1, NULL, &tp[32]);
  param(tp[32], NULL, NULL);
  call("printf", 1, NULL);
  loadi(1, NULL, &tp[33]);
  loadi(1, NULL, &tp[34]);
  add(tp[33], tp[34], &tp[35]);
  param(tp[35], NULL, NULL);
  call("exit", 1, NULL);
  jump(NULL, NULL, l3);
l2: /* else */
  loads("C=?", NULL, &tp[36]);
  param(tp[36], NULL, NULL);
  call("printf", 1, NULL);
  param(ts[8], NULL, NULL);
  call("printf", 1, NULL);
  loadi(2, NULL, &tp[37]);
  comp_gt(ts[1], tp[37], &tp[38]);
  loadf(3.0, NULL, &tp[39]);
  comp_lt(ts[4], tp[39], &tp[40]);
  rela_an(tp[38], tp[40], &tp[41]);
  rela_no(tp[41], NULL, &tp[42]);
  jump_f(tp[42], NULL, l1); /* if */
  loadf(222.2, NULL, &tp[43]);
  param(tp[43], NULL, NULL);
  call("printf", 1, NULL);
l1: /* end if */
l3: /* end if */
l4: /* end if */
  nop(NULL, NULL, NULL);
  loads("M=?", NULL, &tp[44]);
  param(tp[44], NULL, NULL);
  call("printf", 1, NULL);
  call("scanf", 0, &ts[9]);
  loads("M=?", NULL, &tp[45]);
  param(tp[45], NULL, NULL);
  call("printf", 1, NULL);
  param(ts[9], NULL, NULL);
  call("printf", 1, NULL);
  loadi(0, NULL, &tp[46]);
  comp_eq(ts[9], tp[46], &tp[47]);
  jump_f(tp[47], NULL, l5); /* if */
  halt(NULL,NULL,NULL);
l5: /* end if */
  nop(NULL, NULL, NULL);
l6: /* while */
  loadi(10, NULL, &tp[48]);
  comp_lt(ts[9], tp[48], &tp[49]);
  jump_f(tp[49], NULL, l7);
  loads("M=?", NULL, &tp[50]);
  param(tp[50], NULL, NULL);
  call("printf", 1, NULL);
  param(ts[9], NULL, NULL);
  call("printf", 1, NULL);
  loadi(1, NULL, &tp[51]);
  add(ts[9], tp[51], &tp[52]);
  mov(tp[52], NULL, &ts[9]); /* M = tp[52] */
  jump(NULL, NULL, l6);
l7: /* end of while */
  loadf(1.1, NULL, &tp[53]);
  param(tp[53], NULL, NULL);
  call("sqrt", 1, &tp[54]);
  mov(tp[54], NULL, &ts[5]); /* P = tp[54] */
  loadf(2.2, NULL, &tp[55]);
  param(tp[55], NULL, NULL);
  call("exp", 1, &tp[56]);
  mov(tp[56], NULL, &ts[9]); /* M = tp[56] */
  loads("P=sqrt(1.1)?", NULL, &tp[57]);
  param(tp[57], NULL, NULL);
  call("printf", 1, NULL);
  param(ts[5], NULL, NULL);
  call("printf", 1, NULL);
  loads("M=exp(2.2)?", NULL, &tp[58]);
  param(tp[58], NULL, NULL);
  call("printf", 1, NULL);
  param(ts[9], NULL, NULL);
  call("printf", 1, NULL);
  loadi(10, NULL, &tp[59]);
  loadi(7, NULL, &tp[60]);
  mod(tp[59], tp[60], &tp[61]);
  mov(tp[61], NULL, &ts[6]); /* N = tp[61] */
  loads("N=10 % 7?", NULL, &tp[62]);
  param(tp[62], NULL, NULL);
  call("printf", 1, NULL);
  param(ts[6], NULL, NULL);
  call("printf", 1, NULL);
  nop(NULL, NULL, NULL);
  loadi(1, NULL, &tp[63]);
  mov(tp[63], NULL, &ts[6]); /* N = tp[63] */
l8: /* for */
  loadi(10, NULL, &tp[64]);
  comp_lt(ts[6], tp[64], &tp[65]);
  jump_f(tp[65], NULL, l9);
  loads("N=?", NULL, &tp[68]);
  param(tp[68], NULL, NULL);
  call("printf", 1, NULL);
  param(ts[6], NULL, NULL);
  call("printf", 1, NULL);
  loadi(1, NULL, &tp[69]);
  add(ts[6], tp[69], &tp[70]);
  mov(tp[70], NULL, &ts[6]); /* N = tp[70] */
  loadi(1, NULL, &tp[66]);
  add(ts[6], tp[66], &tp[67]);
  mov(tp[67], NULL, &ts[6]); /* N = tp[67] */
  jump(NULL, NULL, l8);
l9: /*end of for */
  nop(NULL, NULL, NULL);
  loads("Oi", NULL, &tp[71]);
  loads("la", NULL, &tp[72]);
  add(tp[71], tp[72], &tp[73]);
  add(tp[73], ts[3], &tp[74]);
  mov(tp[74], NULL, &ts[0]); /* S = tp[74] */
  loads("S='Oi' + 'la' + T?", NULL, &tp[75]);
  param(tp[75], NULL, NULL);
  call("printf", 1, NULL);
  param(ts[0], NULL, NULL);
  call("printf", 1, NULL);
  loads("oi", NULL, &tp[76]);
  comp_eq(ts[0], tp[76], &tp[77]);
  jump_f(tp[77], NULL, l10); /* if */
  loads("sim S=='oi'", NULL, &tp[78]);
  param(tp[78], NULL, NULL);
  call("printf", 1, NULL);
  jump(NULL, NULL, l11);
l10: /* else */
  loads("nao S=='oi'", NULL, &tp[79]);
  param(tp[79], NULL, NULL);
  call("printf", 1, NULL);
l11: /* end if */
  loads("oi", NULL, &tp[80]);
  comp_ne(ts[0], tp[80], &tp[81]);
  jump_f(tp[81], NULL, l12); /* if */
  loads("sim S!='oi'", NULL, &tp[82]);
  param(tp[82], NULL, NULL);
  call("printf", 1, NULL);
  jump(NULL, NULL, l13);
l12: /* else */
  loads("nao S!='oi'", NULL, &tp[83]);
  param(tp[83], NULL, NULL);
  call("printf", 1, NULL);
l13: /* end if */
  loads("oi", NULL, &tp[84]);
  comp_lt(ts[0], tp[84], &tp[85]);
  jump_f(tp[85], NULL, l14); /* if */
  loads("sim S<'oi'", NULL, &tp[86]);
  param(tp[86], NULL, NULL);
  call("printf", 1, NULL);
  jump(NULL, NULL, l15);
l14: /* else */
  loads("nao S<'oi'", NULL, &tp[87]);
  param(tp[87], NULL, NULL);
  call("printf", 1, NULL);
l15: /* end if */
  loadi(0, NULL, &tp[88]);
  param(tp[88], NULL, NULL);
  call("exit", 1, NULL);
}
