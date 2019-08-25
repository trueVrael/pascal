DFLAGS=-g -gl -gv -Sa -Cior
RFLAGS=-O3

all: prepare Debug/omringa Release/omringa

prepare:
	mkdir -p Debug
	mkdir -p Release
	rm -f Debug/omringa
	rm -f Release/omringa
#fpc wie, ktore pliki nalezy przekompilowac, wiec uproscilem Makefile

Debug/omringa:
	fpc $(DFLAGS) omringa.pas -oDebug/omringa
Release/omringa:
	fpc $(RFLAGS) omringa.pas -oRelease/omringa
