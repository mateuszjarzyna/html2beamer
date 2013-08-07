#!/bin/bash

bison -d beamer.y
flex beamer.l
g++ beamer.tab.c lex.yy.c -lfl -o beamer
