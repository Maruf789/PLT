OBJS = ast.cmo parser.cmo scanner.cmo translate.cmo main.cmo
MAIN = main

build : $(MAIN)

$(MAIN) : $(OBJS)
	ocamlc -o $@ $(OBJS)

scanner.ml : scanner.mll
	ocamllex scanner.mll

parser.ml parser.mli : parser.mly
	ocamlyacc parser.mly
	ocamlc -w A -c parser.mli

%.cmi : %.mli
	ocamlc -w A -c $<

%.cmo : %.ml
	ocamlc -w A -c $<

.PHONY : test clean
test : build
	./test.sh main

clean :
	-rm -f $(MAIN) parser.ml parser.mli scanner.ml testall.log \
	*.cmo *.cmi *.out *.diff
