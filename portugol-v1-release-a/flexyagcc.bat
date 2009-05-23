@echo off
REM  Compila arq com lex e yacc (versao win)
REM /*
REM     Autor: Ruben Carlo Benante
REM     Email: benante@gmail.com
REM     Data: 22/05/2009
REM */
REM
REM  Exemplo:
REM  ./flexyacc portugol teste
REM
REM  inicia os seguintes processos:
REM       flex portugol.l
REM       yacc -d portugol.y    		(ou bison -dy portugol.y)
REM       gcc y.tab.c lex.yy.c portugol.c -o portugol.exe
REM
REM  entrada:
REM           portugol.l (arquivo em linguagem lex, analisador lexico)
REM           portugol.y (arquivo em linguagem yacc, analisador sintatico)
REM           portugol.c (arquivo em linguagem c, gerador de codigo)
REM
REM  saida:
REM         lex.yy.c (saida do lex, em linguagem c)
REM         y.tab.c  (saida do yacc, em linguagem c)
REM         y.tab.h  (saida do yacc, definicoes da linguagem portugol)
REM         portugol.exe (saida do gcc, arquivo executavel, finalmente o compilador portugol)
REM
REM	pre-requisitos:
REM				  flex.exe                 (no diretorio corrente ou no path)
REM				  bison.exe                (no diretorio corrente ou no path)
REM				  bison.simple             (no diretorio corrente ou no path)
REM				  c:\Dev-Cpp\bin\gcc.exe   (instalacao padrao do DEV-C++)
REM
REM  Para compilar um fonte.ptg veja abaixo.

echo --- deleting y.tab.c -------- del y.tab.c
del y.tab.c
echo --- deleting y.tab.h -------- del y.tab.h
del y.tab.h
echo --- flex -------------------- flex %1.l
flex %1.l
echo --- bison ------------------- bison -dy %1.y
REM yacc -d %1.y
bison -dy %1.y
echo --- renaming y.tab.c -------- rename y_tab.c y.tab.c
rename y_tab.c y.tab.c
echo --- renaming y.tab.h -------- rename y_tab.h y.tab.h
rename y_tab.h y.tab.h
echo --- gcc --------------------- gcc y.tab.c lex.yy.c %1.c -o %1.exe -lm
c:\Dev-Cpp\bin\gcc.exe y.tab.c lex.yy.c %1.c -o %1.exe -lm

REM Descomente as ultimas linhas para compilar usando o portugol (ou compilar e executar):
REM
REM ./portugol.exe teste1.ptg teste1.c
REM
REM entrada:
REM            teste1.ptg (arquivo em linguagem portugol)
REM
REM saida:
REM            teste1.asm.c (arquivo em linguagem c -- ou .asm.c para quadruplas)
REM            teste1.exe (arquivo executavel)
REM

echo --- portugol ---------------- ./%1.exe %2.ptg  %2.asm.c
.\%1.exe %2.ptg  %2.asm.c
echo --- gcc --------------------- gcc %2.asm.c -o %2.exe -lm
c:\Dev-Cpp\bin\gcc.exe %2.asm.c -o %2.exe -lm
echo --- Running! ---------------- ./%2.asm.exe
.\%2.exe

