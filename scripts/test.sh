#! /bin/bash

SAMPLES_DIR=./test_samples
OUTPUT_DIR=./test_outputs
IDEAL_DIR=./test_ideaoutputs
NU=/dev/null
DIF="diff -b -B"

for (( i=0; i<3; i++ ))
do
	$1 $SAMPLES_DIR/sample${i}.bc sample${i}.cpp
done

