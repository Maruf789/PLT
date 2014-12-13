OBJS = ast.cmo parser.cmo scanner.cmo \
       sast.cmo lib.cmo scheck_expr.cmo scheck.cmo \
       tast.cmo translate_expr.cmo translate.cmo codegen.cmo main.cmo
MAIN = main.bin
OCAMLC = ocamlc

OCFLAG = -w A

build : clean $(MAIN)

$(MAIN) : $(OBJS)
	$(OCAMLC) -o $@ $(OBJS)

scanner.ml : scanner.mll
	ocamllex scanner.mll

parser.ml parser.mli : parser.mly
	ocamlyacc parser.mly
	$(OCAMLC) $(OCFLAG) -c parser.mli

%.cmi : %.mli
	$(OCAMLC) $(OCFLAG) -c $<

%.cmo : %.ml
	$(OCAMLC) $(OCFLAG) -c $<

.PHONY : clean
clean :
	-rm -f $(MAIN) parser.ml parser.mli scanner.ml testall.log \
	*.cmo *.cmi *.output *.diff *~ *.o *.cmx
