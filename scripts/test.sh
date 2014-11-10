#! /bin/bash

## echo ocaml debug message
#export OCAMLRUNPARAM='p'

$1 < ../samples/sample0.bc
$1 < ../samples/sample1.bc

$1 < ../samples/sample2.bc
$1 < ../samples/sample3.bc

#export OCAMLRUNPARAM=''
