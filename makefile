all: mycomp

pi_parser.tab.c pi_parser.tab.h: pi_parser.y
	bison -d -v -r all pi_parser.y

lex.yy.c: pi_lex.l
	flex pi_lex.l

mycomp: pi_parser.tab.c pi_parser.tab.h lex.yy.c cgen.c cgen.h
	gcc -o mycomp pi_parser.tab.c cgen.c lex.yy.c -lfl -DYYDEBUG=1

%.c: %.pi mycomp
	./mycomp < $< > $@
	# cat $@
