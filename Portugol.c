//	Gerado pelo compilador PORTUGOL versao 1q
//	Autores: Ed Prado, Edinaldo Carvalho, Elton Oliveira,
//		 Marlon Chalegre, Rodrigo Castro
//	Email: {msgprado, truetypecode, elton.oliver,
//		marlonchalegre, rodrigomsc}@gmail.com
//	Data: 26/05/2009

#include "quadruplas-v1q.h"

int main(void)
{
	comp_gt(3.00, 4.00, &temp[0]);
	comp_gt(4.00, 5.00, &temp[1]);
	comp_gt(4.00, 54.00, &temp[2]);
	rela_or(temp[1], temp[2], &temp[3]);
	rela_an(temp[0], temp[3], &temp[4]);
	jump_f(temp[4], NULL, l1);
	add(4.00, 4.00, &temp[5]);
 l1:
 l2:
