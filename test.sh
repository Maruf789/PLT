#! /bin/bash

## echo ocaml debug message
#export OCAMLRUNPARAM='p'

./$1 < sample1.bc

./$1 < sample2.bc

./$1 < sample3.bc

#export OCAMLRUNPARAM=''
