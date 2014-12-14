BuckCal
===
A new simple and easy-to-use matrix manipulation language and a Ocaml compiler that compile the input into C++


= Language Specification =

See ./docs/BuckCal_LRM.pdf


= Folder Structure =

docs - documents: proposal LRM final_report

src - ocaml source code: *.ml scanner.mll parser.mly

lib - library written in c++ (built-in) and BuckCal (user-level)

test - automated test folder


= Build Routine =

In main folder:

$ make


= Test Routine =

In main folder:

$ make

$ make test

Or:

$ make

$ cd test

$ ./test.sh ../src/main.bin

