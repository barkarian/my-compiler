# create pi_parser.tab.c pi_parser.tab.h
pi_parser.tab.c pi_parser.tab.h: pi_parser.y
	bison -d -v -r all pi_parser.y

# create lex.yy.c
lex.yy.c: pi_lex.l
	flex pi_lex.l

# create mycomp
mycomp: pi_parser.tab.c pi_parser.tab.h lex.yy.c cgen.c cgen.h
	gcc -o mycomp pi_parser.tab.c cgen.c lex.yy.c -lfl -DYYDEBUG=1

#"$<" is the filename input to the compiler(first prerequisite) something.c
#"$@" is the target file something.pi
%.c: %.pi mycomp
	./mycomp < $< > $@
	#cat $@

clean:
	rm lex.yy.c pi_parser.tab.c pi_parser.tab.h
	rm pi_parser.output mycomp
 