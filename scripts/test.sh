#! /bin/bash

SAMPLES_DIR=./test_samples
OUTPUT_DIR=./test_outputs
IDEAOUTPUT_DIR=./test_ideaoutputs

for (( i =  0; i <= 5; i++))
do
	$1 $SAMPLES_DIR/sample${i}.bc sample${i}.c > $OUTPUT_DIR/sample${i}out.txt
done
