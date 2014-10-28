#! /bin/bash

cat prev_scanner > test_scanner.mll
cat scanner.mll >> test_scanner.mll
cat post_scanner >> test_scanner.mll

ocamllex test_scanner.mll
ocamlc -o test_scanner test_scanner.ml
./test_scanner < $1
