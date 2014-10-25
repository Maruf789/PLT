#! /bin/bash

ocamllex scanner.mll
ocamlc -o scanner scanner.ml
./scanner < sample1.bc
