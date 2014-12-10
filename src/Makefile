OBJS = ast.cmo parser.cmo scanner.cmo \
       sast.cmo lib.cmo scheck_expr.cmo scheck.cmo \
       tast.cmo translate.cmo codegen.cmo main.cmo
MAIN = main.bin

OCFLAG = -w A

build : clean $(MAIN)

$(MAIN) : $(OBJS)
	ocamlc -o $@ $(OBJS)

scanner.ml : scanner.mll
	ocamllex scanner.mll

parser.ml parser.mli : parser.mly
	ocamlyacc parser.mly
	ocamlc $(OCFLAG) -c parser.mli

%.cmi : %.mli
	ocamlc $(OCFLAG) -c $<

%.cmo : %.ml
	ocamlc $(OCFLAG) -c $<

.PHONY : clean
clean :
	-rm -f $(MAIN) parser.ml parser.mli scanner.ml testall.log \
	*.cmo *.cmi *.output *.diff *~
