bison -yvd calculadora.y
flex calculadora.l
gcc -lm Stack.c y.tab.c lex.yy.c -o calc3
#rm -f y.*
#rm -f lex.yy.c

